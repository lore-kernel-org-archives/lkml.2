Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1KDMXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:23:06 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63241 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1KDMXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:23:05 -0400
Date: Fri, 4 Nov 2011 13:23:00 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: siglesia@cern.ch, manohar.vanga@cern.ch
Subject: [RGC PATCH 0/2] split file2alias using elf sections
Message-ID: <cover.1320408578.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding a new bus type with autoloading of modules, people should
always change the global scripts/mod/file2alias.c source file, whereas
most of the new code is just new files and individual Makefile/Kconfig
lines.

The first patch turns all the "normal" alias generation in a
table-driven loop. The second patch moves a few alias types out of the
main file2alias.c source, as a demonstration that the thing works.

I didn't move all bus/alias types out of the main file, as it's a huge
work. But if the approach is going to be accepted I can do that (or
happily leave the task to who volunteers).

/alessandro

Alessandro Rubini (2):
  modpost: use table-lookup to build module aliases
  modpost: use config and ELF sections to build file2alias

 scripts/mod/Makefile        |   13 ++-
 scripts/mod/alias_acpi.c    |   14 ++
 scripts/mod/alias_bcma.c    |   25 ++++
 scripts/mod/alias_pci.c     |   49 +++++++
 scripts/mod/alias_spi.c     |   15 +++
 scripts/mod/device_switch.h |   47 +++++++
 scripts/mod/file2alias.c    |  294 ++++++++-----------------------------------
 scripts/mod/modpost.h       |   18 +++
 scripts/mod/modpost.lds     |    9 ++
 9 files changed, 243 insertions(+), 241 deletions(-)
 create mode 100644 scripts/mod/alias_acpi.c
 create mode 100644 scripts/mod/alias_bcma.c
 create mode 100644 scripts/mod/alias_pci.c
 create mode 100644 scripts/mod/alias_spi.c
 create mode 100644 scripts/mod/device_switch.h
 create mode 100644 scripts/mod/modpost.lds
