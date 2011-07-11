Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab1GKNzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:55:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49734 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab1GKNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:55:16 -0400
Date: Mon, 11 Jul 2011 14:55:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] x86 platform driver fixes for 3.0
Message-ID: <20110711135510.GA11129@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some small fixes for 3.0 - reversion of a commit that broke some Dells, 
a fix for a regression in acer-wmi and some trivial fixups for a couple 
of other drivers.

The following changes since commit e3bbfa78bab125f58b831b5f7f45b5a305091d72:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-07-10 10:24:47 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Andre Bartke (1):
      drivers/platform/x86: Fix memory leak

Axel Lin (1):
      platform-drivers-x86: set backlight type to BACKLIGHT_PLATFORM

Eric Dumazet (1):
      hp-wmi: fix use after free

Henrique de Moraes Holschuh (2):
      thinkpad-acpi: handle some new HKEY 0x60xx events
      thinkpad-acpi: handle HKEY 0x4010, 0x4011 events

Jose Alonso (1):
      dell-laptop - using buffer without mutex_lock

Keng-Yu Lin (1):
      Revert: "dell-laptop: Toggle the unsupported hardware killswitch"

Lee, Chun-Yi (1):
      acer-wmi: fix bitwise bug when set device state

Seth Forshee (1):
      acer-wmi: Only update rfkill status for associated hotkey events

 Documentation/laptops/thinkpad-acpi.txt |    5 ++
 drivers/platform/x86/acer-wmi.c         |   47 ++++++++++++--------
 drivers/platform/x86/asus-wmi.c         |    1 +
 drivers/platform/x86/compal-laptop.c    |    4 +-
 drivers/platform/x86/dell-laptop.c      |   30 ++-----------
 drivers/platform/x86/hp-wmi.c           |   11 +++--
 drivers/platform/x86/intel_oaktrail.c   |    1 +
 drivers/platform/x86/thinkpad_acpi.c    |   72 +++++++++++++++++++++++++------
 8 files changed, 108 insertions(+), 63 deletions(-)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
