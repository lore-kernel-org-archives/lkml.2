Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1LQND7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 08:03:59 -0500
Received: from d1.icnet.pl ([212.160.220.21]:47777 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab1LQNDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 08:03:55 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: Fix cross compilation broken by failing size command
Date: Sat, 17 Dec 2011 14:01:30 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20111214215815.GP32251@atomide.com> <1324032146-723-1-git-send-email-jkrzyszt@tis.icnet.pl> <20111217105737.GO14542@n2100.arm.linux.org.uk>
In-Reply-To: <20111217105737.GO14542@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112171401.30635.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 of December 2011 at 11:57:37, Russell King - ARM Linux wrote:
> On Fri, Dec 16, 2011 at 11:42:26AM +0100, Janusz Krzysztofik wrote:
> > Unfortunately, I've already pushed that old version to the patch system
> > at http://www.arm.linux.org.uk/developer/patches/, which I know is not
> > a review system. Apparently, I was not patient enough, not waiting more
> > than a week with that regression fix for a single reply to my initial
> 
> I'll disagree with you there: this is not a regression fix.  A regression
> fix implies that it was something that worked before, a change happened
> to the kernel, and now it's broken.
> 
> That is not the case: a change happened to binutils

Not to mine, I'm still using the same version as before.

> which meant 'size'
> no longer parses foreign ELF formats. 

But 'size' was not there before v3.2-rc1! The problem has arised because 
arch/arm/boot/compress/Makefile, which belongs to the kernel sources, 
not to binutils you're trying to blame, was changed. The 'size' call was 
introduced into that Makefile, i.e. the file that belongs to the kernel 
sources, whithout taking care of what can happen if that command fails. 
And I was just lucky enough to find out it may fail in certains build 
environments, like mine.

> This is not a change to the
> kernel, 

but a change to a file in the kernel source tree. Isn't it the same?

> and therefore it is not a kernel regression.

Than, you say that if a kernel Makefile is broken, effectively breaking 
the kernel compilation in certain build environments, then it's not a 
kernel regression and can be released as is? Funny.

> Therefore, I consider it lower priority than true kernel regression
> fixes, and also lower priority than normal bug fixes to the kernel:
> it's actually a feature change - changing the kernel to work with a
> new toolchain.

I repeat: I haven't changed my toolchain. A file that belongs to the 
kernel sources was changed.

> Since the original proposed change causes _me_ problems (I'm missing
> an arm-linux-size for some unknown reason - which I've yet to resolve
> one way or other) I've not yet considered the change any further than
> noting that fact.

If you were so kind to share your findings once discovered, you would 
give me a chance to correct that problem with missing 
$(CROSS_COMPILE)size tool already several weeks ago. Fortunately, Tony 
was kind enough to comment, better late than never.

> If it turns out that older versions of binutils do not supply a 'size'
> command, then we need something like your v2 patch.  If it's the case
> that for some reason it never got transferred when I changed machines,
> then your v1 patch is appropriate and I need to fix that.  But that
> requires investigation on my side, and I've not been able to do that
> yet.

Thanks to Tony's help, you now have two versions of the patch to choose 
from, the initial one, with its own issue, and the corrected one, with 
Tony's Ack.

If you are sure this is not a regression and can wait while the stable 
kernel version is released with that issue not corrected - your choice. 
You are the ARM port maintainer, not me, and I respect your rights to 
manage things the way you like. I only disagree with your opinion about 
this issue not being a regression.

I'm not representing any third party interests, only my own (and public 
to some extent, I thought), and even if not happy, I'm willing to handle 
that issue myslef in my build environment as long as it exists in the 
official kernel sources, in order to be able to still help solving other 
kernel issues I happen to find out from time to time.

Thanks,
Janusz
