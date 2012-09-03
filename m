Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2ICFU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:20:56 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46064 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2ICFUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:20:54 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 22:20:48 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 0/5] x86: Improve defconfigs for use on current systems
Message-ID: <cover.1346649518.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After repeatedly going through the cycle of building a "make defconfig" kernel,
trying to boot it, getting a kernel panic, turning on ext4, and rebuilding, I
figured I'd actually get the defconfigs fixed to work on modern systems with
ext4 root filesystems.  Patch 2 of this patch series does exactly that.
Hopefully this will prove uncontroversial.

To avoid extraneous noise in patch 2, I first updated the defconfigs to match
the current results of "make defconfig && make savedefconfig", resulting in
patch 1.

Finally, while reviewing the defconfigs, I also ran into a few other random
things to clean up, resulting in patches 3-5.  Patch 3 disables some library
code that only exists to support out-of-tree modules (in-tree modules properly
depend on it); patch 4 disables initrd support (in favor of initramfs); patch 5
disables a special-purpose test module that represents the one and only module
built by default.  These seem reasonable to me, but if anyone finds one of
these three changes objectionable, please feel free to drop that change.  I
primarily care about getting patches 1-2 merged, to avoid a very common
annoyance.

Josh Triplett (5):
  x86: Update defconfigs to current results of "make savedefconfig"
  x86: Switch to ext4 in defconfigs
  x86: Disable CONFIG_CRC_T10DIF in defconfigs
  x86, defconfig: Turn off CONFIG_BLK_DEV_RAM
  x86: Turn off DEBUG_NX_TEST module in defconfigs

 arch/x86/configs/i386_defconfig   |   23 +++++++----------------
 arch/x86/configs/x86_64_defconfig |   23 +++++++----------------
 2 files changed, 14 insertions(+), 32 deletions(-)

-- 
1.7.10.4

