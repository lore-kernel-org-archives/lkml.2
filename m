Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1AZRFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:05:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:48512 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab1AZRFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:05:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Emil Langrock <emil.langrock@gmx.de>
Subject: Re: =?utf-8?b?e3BhaW5mdWxseQ==?= =?utf-8?b?QklTRUNURUR9?= Please revert f25c80a4b2: arch/um/drivers: remove duplicate structure field initialization
Date: Wed, 26 Jan 2011 16:32:33 +0000 (UTC)
Message-ID: <loom.20110126T170748-626@post.gmane.org>
References: <4CA09977.80506@panasas.com> <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 89.246.164.138 (Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.45 Safari/534.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds <at> linux-foundation.org> writes:

> The real problem is that maintainers often pick random - and not at
> all stable - points for their development to begin with. They just
> pick some random "this is where Linus -git tree is today", and do
> their development on top of that. THAT is the problem - they are
> unaware that there's some nasty bug in that version.
> 
> It's actually made worse by rebasing. A lot of people end up rebasing
> on top of such a random kernel (again, just because it's the 'most
> recent'). It's very annoying.
> 
> Not to mention that rebasing easily results in bugs of its own, when
> you do hit merge conflicts or double-apply something that already got
> applied (and wasn't seen as a duplicate and merged away automatically,
> because the code had been further modified since). We had that in the
> DVB pull request just yesterday.
> 
> > So in short this is a call for, possibly, cleaner History in main Kernel.
> > Please remind me why re-writing history is a bad thing.
> 
> Rebasing doesn't result in cleaner history. It just results in
> _incorrect_ history that looks simpler.
> 
> To get cleaner history, people should try to keep their tree clean.
> Not add random patches to random branches, and not start random
> branches at random points in time that aren't necessarily stable.

I understand what you want to say, but I don't see how you define stable points. 
Maybe you mean that a stable point is a non-rc release of Linux. This of course 
sounds like a good idea when you start a complete new development without any 
dependencies, but think about following events (ordered by time of event):

 * v2.6.37 was released
 * foo starts to code the feature bar
 * foo asks a subtree maintainer to merge his stuff (subtree maintainer doesn't 
merge it because 2.6.38-rc1 wasn't released yet)
 * v2.6.38-rc1 was released
 * subtree maintainer merges the commit because we need more bar in Linux
 * v2.6.38 was released
 * subtree maintainer asks you to merge his tree with the cool bar feature
 * foo wants to extent the bar feature to superbar and get it in 2.6.40
 * v2.6.39-rc1 gets released with the cool bar feature
 * v2.6.39 gets released with the final and bugfixed bar feature
 * (your merge window - time were foo will not be able to get new patches to the 
subtree maintainer for v2.6.40-rc1)
 * v2.6.40-rc1 gets released

Even if this is a relative small example and the usual problem is more complex - 
what starting point should be used for his superbar feature? My obvious answer 
would be 2.6.39-rc1 (but is it really a stable starting point?)

Kind regards,
Emil Langrock

