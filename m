Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0G2Jjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:39:53 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58791 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0G2Jjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:39:48 -0400
Date: Thu, 29 Jul 2010 11:39:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100729093946.GA6725@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <4C51473A.4000605@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C51473A.4000605@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 11:17:46AM +0200, Michal Marek wrote:
> On 28.7.2010 22:36, Sam Ravnborg wrote:
> > Hi Michal.
> > 
> > I cooked up the following to introduce long options in conf.
> > But in the process I dropped the short options. Is this OK?
> 
> Nice! I would probably name the option and the enum value for randconfig
> simply --randconfig to not introduce new names (the scripts/kconfig/conf
> call is displayed to the user).

I had in mind to deprecate randconfig in favour of allrandconfig
to get more consitency in the names.
But I failed to document this in the changelog.

I can submit the following as a real patch if you agree.

	Sam

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 1290ac3..9670323 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -101,12 +101,12 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
+PHONY += allnoconfig allyesconfig allmodconfig allrandconfig randconfig defconfig
 
-randconfig: $(obj)/conf
-	$< --allrandconfig $(Kconfig)
+# Support deprecated randconfig target
+randconfig: allrandconfig
 
-allnoconfig allyesconfig allmodconfig: $(obj)/conf
+allnoconfig allyesconfig allmodconfig allrandconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 defconfig: $(obj)/conf
@@ -131,7 +131,7 @@ help:
 	@echo  '  localmodconfig  - Update current config disabling modules not loaded'
 	@echo  '  localyesconfig  - Update current config converting local mods to core'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
-	@echo  '  randconfig	  - New config with random answer to all options'
+	@echo  '  allrandconfig	  - New config with random answer to all options'
 	@echo  '  defconfig	  - New config with default answer to all options'
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
 	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
