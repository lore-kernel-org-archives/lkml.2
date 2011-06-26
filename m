Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1FZMe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 08:34:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab1FZMdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 08:33:18 -0400
Subject: Re: [rfc patch] x86,apic: fix DEBUG_PREEMPT gripe when booting
 with threadirqs=1
From: Mike Galbraith <mgalbraith@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110626104521.GE11093@elte.hu>
References: <1308743825.8568.3.camel@marge.simson.net>
	 <20110626104521.GE11093@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Jun 2011 14:33:14 +0200
Message-ID: <1309091594.11217.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-26 at 12:45 +0200, Ingo Molnar wrote:
> * Mike Galbraith <mgalbraith@suse.de> wrote:
> 
> > x86,apic: fix DEBUG_PREEMPT gripe when booting with threadirqs=1
> > 
> > If CONFIG_PREEMPT and CONFIG_INTR_REMAP are both set, and a box is
> > booted with threadirqs, the gripe below is emitted.  It was suggested
> > that native_smp_prepare_cpus() shouldn't need to be run with preemption
> > disabled, and indeed, box boots with no hint of trouble.  Remove it.
> 
> Would also require a careful review of the code we take out of 
> preempt protection now - have you done that by any chance? (if not, 
> mind doing it?)

No, I haven't, I have only empirical evidence of having yet to see any
nastiness with an RT kernel.

I'll crawl through it once I get a couple PCI configuration space
thingies sorted.  I'm rather expecting to then find out why
INTR_REMAP/DMAR + X2APIC is disabled.. the head-on collision way.

	-Mike

