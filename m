Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0L3Ri4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:38:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab0L3Riz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:38:55 -0500
Date: Thu, 30 Dec 2010 18:38:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.37
Message-ID: <20101230173847.GA2734@elte.hu>
References: <20101229144702.GL4739@erda.amd.com>
 <20101229163743.GA27109@elte.hu>
 <20101230130853.GA21073@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101230130853.GA21073@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 29.12.10 11:37:43, Ingo Molnar wrote:
> 
> > Hm, i'm not sure this fix is correct:
> > 
> >  static int op_amd_init(struct oprofile_operations *ops)
> >  {
> > +       /*
> > +        * init_ibs() preforms implictly cpu-local operations, so pin this
> > +        * thread to its current CPU
> > +        */
> > +       preempt_disable();
> >         init_ibs();
> > +       preempt_enable();
> > 
> > If init_ibs() is indeed CPU local, then it needs to be called on all CPUs. Does 
> > that happen and if not why not? AFAICS it's only called on one CPU.
> 
> It is correct to run init_ibs() only on one cpu.  It only checks the ibs 
> capabilities and sets up pci devices (if necessary). It runs only on one cpu but 
> operates with the local APIC and some MSRs, thus it is better to disable 
> preemption.

Ok, but in that case the prempt_disable()/enable() should be put into init_ibs(), 
not be open-coded at the caller like that.

The comment about its cpu-localness could move to init_ibs() as well.

Thanks,

	Ingo
