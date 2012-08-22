Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2HVUEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:04:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2HVUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:04:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 0/4] [RFC] ARM: multiplatform: rename all mach headers
Date: Wed, 22 Aug 2012 20:04:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
References: <201208221253.07278.arnd@arndb.de> <50353689.6060404@wwwdotorg.org>
In-Reply-To: <50353689.6060404@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208222004.06179.arnd@arndb.de>
X-Provags-ID: V02:K0:luUdOuqZ6Vy2ZDMllKKs/3gF44NJFOB6auYjWO9FTQY
 wrz+78cGiVLxGBLPJ/MdfFGJVv2/Zjibv9FJZx+5s8EpRaY2jq
 7YXthsQ3dr86A9pKDFGSQnNFDg1Y1mMxQSRBV87XDHC0nZh/hd
 8f+2A+Ujjf6ogZSKoLCApjbyYrCmZ7YpZtEHRvLX1xKokuAz6c
 SNPiUE6av4kEWh0OnC53Pi+lK1MrQcaiHQCAQk4YyIF+dvGcc9
 j2BtO7Lm7spYjbgVqFIvt+5kIinjTjitq0kqbDfx8qFMY3NBoP
 1BwOBuStIrzqlcLSJUryRPS90APYaH/dEsCB1N5aPzqFwwUR4m
 LeFsJATdu6BSnx200nQc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Stephen Warren wrote:
> On 08/22/2012 06:53 AM, Arnd Bergmann wrote:
> > I've created this series some time ago, and updated it now to
> > v3.6-rc1. The idea is to get us a big step closer to the
> > single zImage kernel across multiple ARM platforms by
> > untangling the duplicate header file names.
> > 
> > There are two branches available in the arm-soc tree:
> > 
> > 1. This series,
> >    http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=shortlog;h=refs/heads/testing/mach-headers
> >    This just moves header files around and changes most of the
> >    files including them. There are a few remaining drivers
> >    and platform files that keep including a generic file name
> >    like <mach/uncompress.h>....
> 
> FWIW, I merged this with next-20120820, ignored all the non-Tegra
> conflicts, and it built and ran just fine on Tegra. There were a lot of
> conflicts overall though...

Ah, very cool, thanks for the testing. If you want, you can also
try to merge in the testing/randconfig branch and see how far
you get with enabling tegra in there. That does however require
that you also use the COMMON_CLK and SPARSE_IRQ options, and I'm
not sure what your status on those is.

> > I would like to get the first series merged in v3.7 if we can agree
> > on the general approach. So far, feedback in Linaro internal
> > meetings has been very positive, but Russell had concerns when
> > we first discussed it a few months ago.
> > 
> > A patch set this large means a lot of churn, and there are a few
> > ways we could deal with this:
> > 
> > a) Put the branch into linux-next now, and have everyone who
> > encounters conflicts pull it into their own branch to resolve
> > the conflicts. This can be a lot of work, and it means we
> > cannot rebase this branch any more.
> 
> I did a very quick test of rebasing all the Tegra branches onto this,
> and it worked out to be very easy; very few conflicts and mostly just
> files deleted in the Tegra tree this time around. One of the Tegra
> branches depends on v3.6-rc2 in order to pick up some changes that
> conflict with changes made there. If we convert to dmaengine in 3.7,
> then we'll probably depend on a later v3.6-rc for a dmaengine driver
> bug-fix. Does it make sense to rebase this mach-headers onto a later
> v3.6-rc? I suppose I could branch from v3.6-rc2, merge in mach-headers,
> and then build on that if needed.

It's only problematic if multiple people merge the same branch with
later -rc releases and fix the same conflicts in different ways.
If we get such conflicts, it would probably be best if I merge a
new -rc into my branch and let other people base on my merge
commit.

> > b) Involve Linus Torvalds in the process and get him to
> > take the series at the end of the v3.7 merge window, after
> > rebasing it on top of all the other branches he merged.
> > This means it happens pretty much ad-hoc and there is little
> > testing on the patches that actually get merged.
> 
> Given the number of merge conflicts this has with next-20120820, that
> sounds like a lot of work you need to do at the end of the merge window,
> but I suppose if it's mostly scripted, it wouldn't be too hard to
> recreate the series in a short time.

Yes, I've done it a few times.

	Arnd
