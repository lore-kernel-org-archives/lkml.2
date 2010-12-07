Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0LGPSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:18:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52059 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab0LGPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:17:59 -0500
Date: Tue, 7 Dec 2010 15:17:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT PULL] x86 platform driver tree
Message-ID: <20101207151753.GA18490@srcf.ucam.org>
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

A few small fixes and one fairly significant one in WMI (strcmp/memcmp 
confusion), along with relaxing the check in the IBM RTL driver so it 
works on all the hardware that supports it:

The following changes since commit 22a5b566c8c442b0b35b3b106795e2f2b3578096:

  Merge branch 'for_linus' of git://github.com/at91linux/linux-2.6-at91 (2010-11-30 17:57:57 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Anisse Astier (2):
      msi-wmi: Add mute key support
      msi-wmi: fix semantically incorrect use of keycode instead of scancode

Chris Bagwell (1):
      eeepc-wmi: add cpufv sysfs documentation

Corentin Chary (1):
      asus-laptop: add wimax and wwan support

Dmitry Torokhov (1):
      eeepc-wmi: fix compiler warning

Jon Dowland (1):
      toshiba_acpi.c: Add key_entry for a lone FN keypress

Julia Lawall (1):
      drivers/platform/x86/thinkpad_acpi.c: delete double assignment

Randy Dunlap (1):
      ibm_rtl: fix printk format warning

Thadeu Lima de Souza Cascardo (1):
      wmi: use memcmp instead of strncmp to compare GUIDs

Vernon Mauery (2):
      ibm_rtl: Loosen the DMI criteria to all IBM machines
      ibm_rtl: _RTL_ is not available in UEFI mode

Zeng Zhaoming (1):
      ACPI, hp-wmi: Fix memory leak in acpi query

 .../ABI/testing/sysfs-platform-asus-laptop         |   16 +++-
 Documentation/ABI/testing/sysfs-platform-eeepc-wmi |   10 ++
 drivers/platform/x86/asus-laptop.c                 |   97 +++++++++++++++++++-
 drivers/platform/x86/eeepc-wmi.c                   |    4 +-
 drivers/platform/x86/hp-wmi.c                      |    2 +
 drivers/platform/x86/ibm_rtl.c                     |   34 ++-----
 drivers/platform/x86/msi-wmi.c                     |   16 ++--
 drivers/platform/x86/thinkpad_acpi.c               |    1 -
 drivers/platform/x86/toshiba_acpi.c                |    1 +
 drivers/platform/x86/wmi.c                         |    2 +-
 10 files changed, 144 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-eeepc-wmi

-- 
Matthew Garrett | mjg59@srcf.ucam.org
