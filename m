Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab0KKX6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:58:17 -0500
Received: from claw.goop.org ([74.207.240.146]:33425 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0KKX6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:58:15 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/3] Xen Microcode update driver for 2.6.38
Date: Thu, 11 Nov 2010 15:58:03 -0800
Message-Id: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi all,

This series adds a new microcode driver for Xen.  The Xen hypervisor
can deal with all the low-level details of doing a microcode update
(Intel vs AMD, doing all the physical CPUs present on the system,
current and future, etc), so all the driver has to do is make a
hypercall to upload the microcode into Xen.

This only works on a privileged domain, of course.  But the Xen driver
also detects any time we're running paravirtualized under Xen to
prevent any attempts at a microcode update from a non-privileged
domain as well.

Thanks,
	J

Jeremy Fitzhardinge (2):
  xen: add CPU microcode update driver
  xen/microcode: partially enable even for non-privileged kernels

Stephen Tweedie (1):
  xen dom0: Add support for the platform_ops hypercall

 arch/x86/include/asm/microcode.h     |    9 ++
 arch/x86/include/asm/xen/hypercall.h |    8 ++
 arch/x86/kernel/Makefile             |    1 +
 arch/x86/kernel/microcode_core.c     |    5 +-
 arch/x86/kernel/microcode_xen.c      |  201 ++++++++++++++++++++++++++++++
 arch/x86/xen/Kconfig                 |    8 ++
 include/xen/interface/platform.h     |  222 ++++++++++++++++++++++++++++++++++
 include/xen/interface/xen.h          |    2 +
 8 files changed, 455 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/microcode_xen.c
 create mode 100644 include/xen/interface/platform.h

-- 
1.7.2.3

