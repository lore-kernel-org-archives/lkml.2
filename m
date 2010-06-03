Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0FCPQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:16:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36839 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab0FCPQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:16:00 -0400
Date: Thu, 3 Jun 2010 17:15:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       john cooper <john.cooper@third-harmonic.com>,
       Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com,
       john cooper <john.cooper@redhat.com>
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603151558.GD4166@basil.fritz.box>
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com> <4C05493F.1040107@third-harmonic.com> <20100601193659.GC11880@basil.fritz.box> <1275563199.2383.1873.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275563199.2383.1873.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:06:39PM +0100, David Woodhouse wrote:
> On Tue, 2010-06-01 at 21:36 +0200, Andi Kleen wrote:
> > > Collecting the contention/usage statistics on a per spinlock
> > > basis seems complex.  I believe a practical approximation
> > > to this are adaptive mutexes where upon hitting a spin
> > > time threshold, punt and let the scheduler reconcile fairness.
> > 
> > That would probably work, except: how do you get the
> > adaptive spinlock into a paravirt op without slowing
> > down a standard kernel?
> 
> It only ever comes into play in the case where the spinlock is contended
> anyway -- surely it shouldn't be _that_ much of a performance issue?

The problem is fitting the state into the u32

Also "lightly contended" is not that uncommon.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
