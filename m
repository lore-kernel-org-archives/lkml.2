Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1CBSbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:31:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab1CBSbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:31:32 -0500
Date: Wed, 2 Mar 2011 19:31:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110302183123.GE13693@elte.hu>
References: <20110226143730.GA26864@htj.dyndns.org>
 <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
 <20110302161900.GP3319@htj.dyndns.org>
 <AANLkTi=SYRK+iKT-Zwuyv=e6dLqmoL4cUts2Xoyq-M=1@mail.gmail.com>
 <20110302170702.GS3319@htj.dyndns.org>
 <20110302180827.GA13693@elte.hu>
 <4D6E8874.6070000@zytor.com>
 <20110302181941.GD13693@elte.hu>
 <20110302182551.GB28266@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302182551.GB28266@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On Wed, Mar 02, 2011 at 07:19:41PM +0100, Ingo Molnar wrote:
> > Hm, i thought the revert was for tip:x86/mm, not x86/urgent. The development window 
> > for 2.6.39 is closing down.
> > 
> > A revert (without an actual bug that it fixes) for -rc8 is definitely out of 
> > question.
> 
> It is for x86/mm and it does address the unnecessarily smaller mapping
> problem, which Yinghai's further patches address too.  Those patches
> are what triggered me to ask for a revert because they kinda show how
> ugly the underlying code is and add on top of it.

Yeah - i agree with you and hpa that deferring this to .40 is the most sensible 
approach.

The splitting up into small regions side-effect was rather nasty to begin with - it 
would have taken who knows how many cycles for someone to notice that based on raw 
analysis of the pagetables ...

We need to slow down here for .39.

Thanks,

	Ingo
