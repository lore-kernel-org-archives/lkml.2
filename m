Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0FHWTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:19:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59523 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab0FHWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:19:06 -0400
Date: Tue, 8 Jun 2010 23:19:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT PULL] x86 platform driver updates for 2.6.35-rc3
Message-ID: <20100608221901.GA25294@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some fixes for error paths, some config fixes, a minor update to hp-wmi 
that deals with some annoying corner cases like AC adapter events being 
interpreted as brightness down keystrokes and the Intel IPS driver. This 
requires a small addition to the timer API but doesn't modify any 
existing code. Should all be entirely low impact.

The following changes since commit 3975d16760d4be7402d1067c548c30c427971331:
  Linus Torvalds (1):
        Merge git://git.infradead.org/~dwmw2/mtd-2.6.35

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Axel Lin (1):
      intel_menlow: fix memory leaks in error path

Jesse Barnes (3):
      timer: add on-stack deferrable timer interfaces
      x86 platform driver: intelligent power sharing driver
      IPS driver: add GPU busy and turbo checking

Julia Lawall (1):
      drivers/platform/x86: Eliminate a NULL pointer dereference

Randy Dunlap (1):
      platform/x86: msi-laptop depends on SERIO_I8042

Thadeu Lima de Souza Cascardo (1):
      classmate-laptop: depends on RFKILL or RFKILL=n

Thomas Renninger (3):
      x86 platform drivers: hp-wmi Reorder event id processing
      x86 platform drivers: hp-wmi Add media key 0x20e8
      x86 platform drivers: hp-wmi fix buffer size depending on ACPI version

 drivers/platform/x86/Kconfig        |   12 +
 drivers/platform/x86/Makefile       |    1 +
 drivers/platform/x86/hp-wmi.c       |   82 ++-
 drivers/platform/x86/intel_ips.c    | 1659 +++++++++++++++++++++++++++++++++++
 drivers/platform/x86/intel_menlow.c |   33 +-
 drivers/platform/x86/sony-laptop.c  |   10 +-
 include/drm/i915_drm.h              |    9 +
 include/linux/timer.h               |   15 +
 kernel/timer.c                      |   13 +
 9 files changed, 1796 insertions(+), 38 deletions(-)
 create mode 100644 drivers/platform/x86/intel_ips.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org
