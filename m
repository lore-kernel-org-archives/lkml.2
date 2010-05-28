Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0E1SZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:25:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57066 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab0E1SZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:25:55 -0400
Date: Fri, 28 May 2010 19:25:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT PULL] x86 platform driver updates for 2.6.35
Message-ID: <20100528182549.GA32694@srcf.ucam.org>
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

The hp-wmi update looks large but is mostly code cleanup with no 
functional change. The rest is obvious fixes plus Jesse's IPS driver for 
power saving on recent Intel.

The following changes since commit 9dda696f0de87a2e5cfabb147e28c76b7d3c6846:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

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

Thomas Renninger (7):
      x86 platform drivers: hp-wmi Reorder event id processing
      x86 platform drivers: hp-wmi Catch and log unkown event and key codes correctly
      x86 platform drivers: hp-wmi Use consistent prefix string for messages.
      x86 platform drivers: hp-wmi Add media key 0x20e8
      x86 platform drivers: hp-wmi Set placeholder for unimplemented events
      x86 platform drivers: hp-wmi fix buffer size depending on ACPI version
      X86 platform: hp-wmi Better match the HP WMI query interface

 drivers/platform/x86/Kconfig        |   12 +
 drivers/platform/x86/Makefile       |    1 +
 drivers/platform/x86/hp-wmi.c       |  234 ++++--
 drivers/platform/x86/intel_ips.c    | 1659 +++++++++++++++++++++++++++++++++++
 drivers/platform/x86/intel_menlow.c |   33 +-
 drivers/platform/x86/sony-laptop.c  |   10 +-
 include/drm/i915_drm.h              |    9 +
 include/linux/timer.h               |   15 +
 kernel/timer.c                      |   13 +
 9 files changed, 1920 insertions(+), 66 deletions(-)
 create mode 100644 drivers/platform/x86/intel_ips.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org
