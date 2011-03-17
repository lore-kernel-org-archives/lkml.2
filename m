Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1CQCBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:01:09 -0400
Received: from kroah.org ([198.145.64.141]:59198 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1CQCBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:01:05 -0400
Date: Wed, 16 Mar 2011 19:02:12 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for .39
Message-ID: <20110317020212.GA2115@kroah.com>
References: <20110316210300.GA3311@kroah.com>
 <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
 <20110317002818.GA19812@kroah.com>
 <AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
 <AANLkTinznDAXuxv8AU=tZpTq81f_S8vTyAqRMm=nfAKS@mail.gmail.com>
 <20110317015239.GB31754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317015239.GB31754@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 06:52:39PM -0700, Greg KH wrote:
> On Wed, Mar 16, 2011 at 05:34:08PM -0700, Linus Torvalds wrote:
> > On Wed, Mar 16, 2011 at 5:32 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > The one with inifinite errors was vt6655.
> > 
> > vt6656 had same/similar issues. In fact, maybe it's simply because I
> > built both of them in, and get infinite "multiple definitions" because
> > they are the same driver with small differences?
> 
> Ah, probably, if they are both built into the kernel that might happen
> due to the global symbols in them.  Actually that's odd, Randy's usual
> 'randconfig' tester usually catches these, I'll make the Kconfig files
> force them to be modules to keep this from happening in the future.

Yes, that looks like the problem, as building them as modules in your
tree right now works just fine.

This patch below should solve your build issue, let me know if it
doesn't.

thanks,

greg k-h

-----------------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: staging: force vt6655 and vt6656 drivers to be built as modules

If they both get built into the kernel, the global symbols in them
conflict and lots of link errors happen.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
index 061e730..c3ba693 100644
--- a/drivers/staging/vt6655/Kconfig
+++ b/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,6 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on PCI && WLAN
+   depends on PCI && WLAN && m
    select WIRELESS_EXT
    select WEXT_PRIV
    ---help---
diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
index a441ba5..f89ab20 100644
--- a/drivers/staging/vt6656/Kconfig
+++ b/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on USB && WLAN
+	depends on USB && WLAN && m
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER

