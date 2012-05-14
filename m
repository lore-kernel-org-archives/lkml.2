Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2ENL47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:56:59 -0400
Received: from smtp24.mail.ru ([94.100.176.177]:53301 "EHLO smtp24.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2ENL46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:56:58 -0400
Date: Mon, 14 May 2012 15:57:02 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] update i_blocks on UFS
Message-ID: <20120514115702.GA11251@maclin>
Mail-Followup-To: Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko <phcoder@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <4FAFBCAE.1050401@gmail.com>
 <20120513215925.GA1998@maclin>
 <4FB032BB.6060209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB032BB.6060209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:16:27AM +0200, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> On 13.05.2012 23:59, Evgeniy Dushistov wrote:
> 
> > On Sun, May 13, 2012 at 03:52:46PM +0200, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> >> UFS code dosn't update i_blocks which leads to the problems ranging from wrong
> >> stat/du to long symlinks (as opposed to inline ones) being damaged. This is
> >> a fix.
> >>
> > 
> > Yes, when quota support was removed, code that update statistic
> > about usage of blocks also was removed. But why so big change to fix this?
> > I found this problem some time ago and fixed it with code bellow,
> > but may be I missed something?
> > 
> 
> Hm, I don't know why this code wasn't in my copy. Was it already
> propagated to Linus' tree? When will it be? Which tree I should merge
> from to get your latest fixes?

I created this patch some time ago, but forgot to merge it to main tree.
You email remind me about this problem.

> My code avoided counting metadata blocks (the ones holding the pointers
> to actual blocks in indirect, double-indirect and triple-indirect
> chains). I thought that i_blocks doesn't take into account the
> metablocks but quick experiment with NetBSD image proved me wrong. So I
> retract this patch altogether.
> My UFS file size limit patch remains though.
> 

ok, so I will test your patch and my and then take care about merging
them into mainline.


-- 
/Evgeniy

