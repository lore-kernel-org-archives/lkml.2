Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0LVRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:25:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34364 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0LVRZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:25:25 -0500
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Miklos Vajna <vmiklos@frugalware.org>, Mike Galbraith <efault@gmx.de>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <20101222171655.GB25611@elte.hu>
References: <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
	 <1293007311.11370.172.camel@marge.simson.net>
	 <1293008842.2170.70.camel@laptop>
	 <20101222133154.GS10557@genesis.frugalware.org>
	 <1293026422.2170.136.camel@laptop> <1293027112.2170.140.camel@laptop>
	 <20101222151434.GW10557@genesis.frugalware.org>
	 <1293037718.2170.155.camel@laptop>  <20101222171655.GB25611@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 18:25:20 +0100
Message-ID: <1293038720.2170.167.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 18:16 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-12-22 at 16:14 +0100, Miklos Vajna wrote:
> > > kernel-build is a git build using the config I already sent and after a
> > > 'git checkout v2.6.36'. I can try to build master as well, so far what I
> > > saw is that the bug occurs there as well, but less frequently, so maybe
> > > that's a bit harder to debug. 
> > 
> > Right, so I've got v2.6.36 exploding, current -git and -tip won't
> > explode for me, tried both about 20 times. So I'll try and figure out
> > wth makes .36 explode and then see if further kernel still suffer that
> > problem.
> 
> Does it explode if you change some of the CONFIG_CC flags, such as 
> CONFIG_CC_OPTIMIZE_FOR_SIZE? I.e. is the crash dependent on the precise kernel image 
> layout perhaps? If it's sensitive to that then this might keep you from chasing 
> shadows ...

I've since changed the .config slightly (enabled frame pointers, added
debug info, enabled the function tracer) and its still exploding. Also,
I suspect Miklos and me have different gcc versions.

So I suspect its really something weird, I just can't really make sense
of it yet.
