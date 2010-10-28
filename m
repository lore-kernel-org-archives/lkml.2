Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0J1JKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:10:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63956 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0J1JJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wZ5mT55z7h1QOEbm8fJiauC1ClxVOgi3fynDlNTRieQy1HoImZ9Dvhc3GuGMNM1tDI
         bEwbDPxqSA/OttIo7g0tAehAFtJ30cRwQOmrynleKxE7gMsmHaSkzDA6KgN5KacC2C2e
         iLrzXMxWmHJbkBwAMv94gxkqvr2zouc1HNkxs=
Date: Thu, 28 Oct 2010 13:09:53 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [GIT PULL] battery-2.6.git (a last minute fix)
Message-ID: <20101028090953.GA28283@oksana.dev.rtsoft.ru>
References: <20101026144118.GA9335@oksana.dev.rtsoft.ru>
 <20101028065457.GA29856@elte.hu>
 <20101028000710.2039c2f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101028000710.2039c2f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 12:07:10AM -0700, Andrew Morton wrote:
[...]
> > The new driver does not build at its own commit point either, as the missing symbol 
> > definition is simply not there. It appears that commit 2e727f1 could not have been 
> > build-tested by anyone before it got upstream (let alone boot and functionality 
> > tested). As a temporary workaround i'm disabling it in -tip.
> > 
> 
> Those definitions get added by the MFD tree and used by the battery
> tree.  Things arrived in the wrong order (and, yes, didn't get tested).

My bad. :-/

> The fix is for Samuel to get a wiggle on with his merge?  The -rc1
> window is about to slam shut on his fingers anyway.

I guess the best thing for now would be to be safe and to disable
the new driver via 'depends on BROKEN', so it won't scare testers
away from -rc1.

Linus,

Please pull battery-2.6.git tree again, this is to disable the
non-buildable (as it appears w/o MFD tree) driver.

The following changes since commit 81280572ca6f54009edfa4deee563e8678784218:
  Linus Torvalds (1):
        Merge branch 'upstream-merge' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git master

Anton Vorontsov (1):
      power_supply: Mark twl4030_charger as broken

 drivers/power/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


commit 23886839a752401aba66517bff8a8b91549279ce
Author: Anton Vorontsov <cbouatmailru@gmail.com>
Date:   Thu Oct 28 12:44:16 2010 +0400

    power_supply: Mark twl4030_charger as broken
    
    The driver is not buildable without MFD changes. For now, let's
    disable the driver as it breaks build for major platforms (i.e. x86).
    
      CC [M]  drivers/power/twl4030_charger.o
    drivers/power/twl4030_charger.c: In function 'twl4030_clear_set_boot_bci':
    drivers/power/twl4030_charger.c:105: error: 'TWL4030_PM_MASTER_BOOT_BCI' undeclared (first use in this function)
    drivers/power/twl4030_charger.c:105: error: (Each undeclared identifier is reported only once
    drivers/power/twl4030_charger.c:105: error: for each function it appears in.)
    drivers/power/twl4030_charger.c: In function 'twl4030_bci_have_vbus':
    drivers/power/twl4030_charger.c:137: error: 'TWL4030_PM_MASTER_STS_HW_CONDITIONS' undeclared (first use in this function)
    drivers/power/twl4030_charger.c: In function 'twl4030_bci_probe':
    drivers/power/twl4030_charger.c:477: warning: overflow in implicit constant conversion
    drivers/power/twl4030_charger.c:485: warning: overflow in implicit constant conversion
    make[2]: *** [drivers/power/twl4030_charger.o] Error 1
    
    We can re-enable it if MFD tree will finally merge into 2.6.37.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 60d83d9..ec44477 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -182,6 +182,7 @@ config CHARGER_ISP1704
 config CHARGER_TWL4030
 	tristate "OMAP TWL4030 BCI charger driver"
 	depends on TWL4030_CORE
+	depends on BROKEN
 	help
 	  Say Y here to enable support for TWL4030 Battery Charge Interface.
 
