Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0JLJro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:47:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47871 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab0JLJrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:47:42 -0400
Date: Tue, 12 Oct 2010 11:47:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Pitcock <nenolod@dereferenced.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
        kernel@kolivas.org
Subject: Re: [PATCH try 5] CFS: Add hierarchical tree-based penalty.
Message-ID: <20101012094735.GH20366@elte.hu>
References: <20101012093044.GD20366@elte.hu>
 <8358526.1721286876359420.JavaMail.root@ifrit.dereferenced.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8358526.1721286876359420.JavaMail.root@ifrit.dereferenced.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* William Pitcock <nenolod@dereferenced.org> wrote:

> Hi,
> 
> ----- "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> > * William Pitcock <nenolod@dereferenced.org> wrote:
> > 
> > > Inspired by the recent change to BFS by Con Kolivas, this patch
> > causes 
> > > vruntime to be penalized based on parent depth from their root task
> > 
> > > group.
> > > 
> > > I have, for the moment, decided to make it a default feature since
> > the 
> > > design of CFS ensures that broken applications depending on task 
> > > enqueue behaviour behaving traditionally will continue to work.
> > 
> > Just curious, is this v5 submission a reply to Peter's earlier review
> > of 
> > your v3 patch? If yes then please explicitly outline the changes you
> > did 
> > so that Peter and others do not have to guess about the direction your
> > 
> > work is taking.
> 
> I just did that in the email I just sent.  Simply put, I was talking 
> with Con a few weeks ago about the concept of having a maximum amount 
> of service for all threads belonging to a process.  This did not work 
> out so well, so Con proposed penalizing based on fork depth, which 
> still allows us to maintain interactivity with make -j64 running in 
> the background.
> 
> Actually, I lie: it works great for server scenarios where you have 
> some sysadmin also running azureus.  Azureus gets penalized instead, 
> but other apps like audacious get penalized too.

Thanks for the explanation!

	Ingo
