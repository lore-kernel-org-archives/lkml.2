Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1DKPIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:08:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab1DKPIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:08:24 -0400
Date: Mon, 11 Apr 2011 17:08:21 +0200
From: Michal Marek <mmarek@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
Message-ID: <20110411150820.GA22004@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-10-git-send-email-mmarek@suse.cz>
 <4D9B3581.6080105@zytor.com>
 <4D9C1AA0.9030008@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9C1AA0.9030008@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 09:47:44AM +0200, Michal Marek wrote:
> On 5.4.2011 17:30, H. Peter Anvin wrote:
> >> --- a/arch/x86/boot/Makefile
> >> +++ b/arch/x86/boot/Makefile
> >> @@ -13,7 +13,7 @@
> >>  # This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
> >>  # the default of FLOPPY is used by 'build'.
> >>  
> >> -ROOT_DEV	:= CURRENT
> >> +ROOT_DEV	?= CURRENT
> >>  
> >>  # If you want to preset the SVGA mode, uncomment the next line and
> >>  # set SVGA_MODE to whatever number you want.
> > 
> > Is this a good thing?  As far as I understand ?= it may mean picking
> > something up from the outside environment.
> > 
> > Since ROOT_DEV has been obsolete for 15 years or more, this would seem
> > to be a needless new error mode.
> 
> So can we just set the default root device to (0, 0)?

Like this?

Subject: [PATCH] x86: Do not set the rood_dev field in bzImage

This has been obsoleted by the root= commandline for several years.
People who still depend on this will surely have a copy of the rdev
command around, the rest of the world gets rid of another piece of
buildhost-dependent data in the build.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/x86/boot/Makefile |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index f7cb086..95365a8 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -9,12 +9,6 @@
 # Changed by many, many contributors over the years.
 #
 
-# ROOT_DEV specifies the default root-device when making the image.
-# This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
-# the default of FLOPPY is used by 'build'.
-
-ROOT_DEV	:= CURRENT
-
 # If you want to preset the SVGA mode, uncomment the next line and
 # set SVGA_MODE to whatever number you want.
 # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
@@ -75,8 +69,7 @@ GCOV_PROFILE := n
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
 quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
-	$(ROOT_DEV) > $@
+cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin > $@
 
 $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
-- 
1.7.4.1

