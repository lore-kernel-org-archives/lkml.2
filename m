Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab1EaRoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:44:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34577 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab1EaRog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:44:36 -0400
Date: Tue, 31 May 2011 10:44:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU fix
Message-ID: <20110531174430.GG2393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110531162726.GA15162@elte.hu>
 <BANLkTi=aWc2c18OohJVmVn_aniyxDKO9Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=aWc2c18OohJVmVn_aniyxDKO9Rw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 02:05:21AM +0900, Linus Torvalds wrote:
> On Wed, Jun 1, 2011 at 1:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest core-urgent-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus
> 
> So remind me again why RCU switched to the stupid threads? It caused
> problems for rcutiny, it now causes silly problems for rcutree. Why do
> it? It's just extra complexity and no real advantage afaik.

The reason for the switch is to allow threads blocked in TREE_PREEMPT_RCU
and TINY_PREEMPT_RCU RCU read-side critical sections to have their
priority boosted in order to avoid OOM.  People have made these OOMs
happen, so this is not longer just a theoretical concern.

							Thanx, Paul
