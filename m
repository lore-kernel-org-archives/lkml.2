Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2AUCNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 21:13:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab2AUCN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 21:13:28 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 0/3] ACPI: Re-factor and remove ./drivers/acpi/atomicio.[ch]
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, ying.huang@intel.com,
        bhelgaas@google.com, trenn@suse.de, linux-kernel@vger.kernel.org
Date: Fri, 20 Jan 2012 19:13:18 -0700
Message-ID: <20120121021318.14723.45698.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently submitted a patch series that re-factored some existing
work that Huang Ying introduced adding support for accessing ACPI
generic registers, backed by Memory Mapped I/O (MMIO), while within
interrupt context:
  Original series: http://marc.info/?l=linux-acpi&m=128769263327206&w=2
  Follow on series: http://marc.info/?l=linux-kernel&m=132070825520957&w=2

An underlying goal has been to re-factor ./drivers/acpi/atomicio.c into
./drivers/acpi/osl.c, providing equivalent functionality but in a more
generalized manner, to allow usage in non-specific (i.e. APEI) contexts
and remove atomicio.c.

In the most recent follow on series, there ended up being additions to
atomicio.c that coincided with the attempt to remove it and as such, the
series final removal patch could not be taken without first pulling the
additions into osl.c.  The fact that the follow on series conversion
patch - commit 700130b41f4 - was taken has inadvertently created
regressions with respect to the recent atomicio.c additions due to the
conversion patch effectively making atomicio.c obsolete.

The additions were commit 04c25997c97 "ACPI, Add 64bit read/write
support to atomicio on i386" and commit 76da3fb3575 "ACPI, Add RAM
mapping support to ACPI atomic IO support".

This patch series addresses both of these issues, bringing in the
additional functionality into the re-factored files (apei-base.c and
osl.c) and then again, reintroduces the patch to remove
./drivers/acpi/atomicio.[ch].
---

Myron Stowe (3):
      ACPI: Remove ./drivers/acpi/atomicio.[ch]
      ACPI, APEI: Add RAM mapping support to ACPI
      ACPI, APEI: Add 64-bit read/write support for APEI on i386


 drivers/acpi/Makefile         |    1 
 drivers/acpi/apei/apei-base.c |   35 ---
 drivers/acpi/atomicio.c       |  422 -----------------------------------------
 drivers/acpi/osl.c            |  152 +++++++++++++++
 include/acpi/acpiosxf.h       |    4 
 include/acpi/atomicio.h       |   10 -
 6 files changed, 158 insertions(+), 466 deletions(-)
 delete mode 100644 drivers/acpi/atomicio.c
 delete mode 100644 include/acpi/atomicio.h

-- 
