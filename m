Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab2B2MPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:15:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2B2MPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:15:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91 first cleanup series for 3.4
Date: Wed, 29 Feb 2012 12:15:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4F4674F2.8090603@atmel.com> <201202281218.39428.arnd@arndb.de> <4F4DF2AB.6060403@atmel.com>
In-Reply-To: <4F4DF2AB.6060403@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202291215.32801.arnd@arndb.de>
X-Provags-ID: V02:K0:wPxpcoP0avbqIf0XAcawtE34pNXivFMr5fCmUttCCam
 TS+e0JU95YjkBASH6FHw+NGrTXbP407wLIOtAKL74y9s5xteHo
 W3YSeYhIqvoD/36IPE18N9P1k/mc5FT+2suFK2ojuYVXyLOcG3
 K5CTxpcXyZ3Wgd5xNgYduUfch/IMRANokAAHSFx/S/YOzx+kIv
 ll0WLUw5/29iRxBwwIkygYzcRSg30cIV4EQAmBO1zGSVu8tPw0
 DqBc7V2Udxu/B5+tnXpwJvE8xfv6rqUIDTYMa4lJLHPXVMDgul
 G/T3zkOK+iEXfBtQfZax+otedXQ/PWGMsKhmhcE+UyDfoAIzug
 hsdhXwP4LZtmDFatXz7A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 February 2012, Nicolas Ferre wrote:
> On 02/28/2012 01:18 PM, Arnd Bergmann :
> > On Tuesday 28 February 2012, Nicolas Ferre wrote:

> > Hmm I think I missed that part. My point was that we try to reduce the number
> > of instances of __raw_readl. These patches spread them to more places that
> > will require cleaning up later. I can see how you want to keep the two changes
> > (__raw_readl -> readl_relaxed and at91_sys_xxx -> at91_yyy_xxx) separate, but
> > it would be less churn to add one patch first that converts at91_sys_xxx
> > to use readl_relaxed and then spread that out than converting them all after
> > the fact.
> 
> Yes, indeed that would have been a good way to proceed but
> unfortunately, this at91_sys_xxx() removal action has begun a while ago
> (mainline patches that I can link to this action are from Sept. 2011).
> We did not have in mind this move from __raw_xxxx() to xxxx_relaxed() at
> that time. Jean-Christophe wanted and still want to finish this action
> before switching to those new functions and I agree with him.
> 
> We discussed together and decided to move to xxxx_relaxed() in the core
> AT91 for early 3.5 development cycle. There will be more to convert, but
> it will be safer at that time.

Ok, sounds good.

> > These can no longer get reordered when I do that, but any other branches are
> > still independent of these and can be arbitrarily moved around anywhere after
> > next/cleanup2.
> 
> Ok, I understand your point and all the implications. But the problem
> with at91/9x5 branch is that it is a product introduction and it is our
> responsibility to no leave it on the side. This material represents in
> fact a kind of "base" for our 3.4 development (second step "base" actually).
> 
> So if you can create this next/cleanup2, please do: it will help us a
> lot. I have created a rebased branch which only relies on
> at91/pm_cleanup and at91/9x5 here:
> 
> git://github.com/at91linux/linux-at91.git at91-3.4-for_cleanup2

Ok.

> (do you want me to send you another pull request?)

No, I'll just upgrade the staging branch into a proper one.

> > We can easily put the irqdomain tree into one of the next/* branches as a
> > dependency, which causes that particular branch to get delayed until Grant
> > has got his patches upstream. If you send me a series for next/boards that
> > depend on irqdomain, I would probably put that into a next/boards2 branch
> > or into a next/irqdomain branch in case I get similar things from multiple
> > people. If Grant's patches are already upstream by the time I get to send
> > out the next/boards branch to Linus, I would probably merge next/boards2
> > into next/boards and send all of it together.
> 
> Ok, we will be able to give you AT91 subsequent development based on
> both next/cleanup2 and the future next/irqdomain. So you can forget the
> other pull request I have sent some days ago:
> "[GIT PULL] at91: irqdomain and device tree for AIC and GPIO"
> I will rebase it once you will publish the two branches cited above.

Hmm, incidentally I had already forgotten about that one ;-)

FWIW, I think it's better not to pull the branches from arm-soc.git
back into your own tree, just base your future pull requests on the
branches that you sent me earlier. Otherwise we just get extra
merge commits into the history that don't add any information like you
have here:

11a25ea Merge remote-tracking branch 'armsoc/at91/9x5' into at91-3.4-base2
9acacb1 Merge remote-tracking branch 'armsoc/at91/device-board' into at91-3.4-base2
76e8057 Merge branch 'at91-3.4-base+9x5' of git://github.com/at91linux/linux-at91 into at91/9x5
018b5e1 Merge branch 'at91-3.4-base+pm_cleanup' of git://github.com/at91linux/linux-at91 into at91/pm_cleanup
92b0b63 Merge branch 'at91-3.4-base+device_board' of git://github.com/at91linux/linux-at91 into at91/device-board
6848523 Merge branch 'at91-3.4-base' of git://github.com/at91linux/linux-at91 into at91/base

The lower four merges may or may not make sense for the branch, but the
most recent two are rather pointless here.

	Arnd
