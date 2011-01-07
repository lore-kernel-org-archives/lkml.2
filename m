Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1AGRRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:17:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51921 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1AGRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CeDVgAnQSNBRffbKX+71K8yT/rK/0GYUC8aA+8tGzWzIM+Sp7dLiEVUZhANfOoPbKo
         vsMQmykDc67RnRu9tzeOclkWOUqV6sPKdUTAC1gkQskTwGJecjg7q2qSqSChxX426wzy
         F1DnSqCaQGUR/jWQn/WBmt+i5uoeprWnAjx4o=
Date: Fri, 7 Jan 2011 18:17:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>,
        "H. Peter Anvin" <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq entry
Message-ID: <20110107171707.GC3066@nowhere>
References: <4D25FE5B020000780002AC50@vpn.id2.novell.com>
 <20110106165452.GC2308@nowhere>
 <4D2602DE020000780002ACA3@vpn.id2.novell.com>
 <20110106171231.GD2308@nowhere>
 <4D26D2C2020000780002AECB@vpn.id2.novell.com>
 <20110107123130.GB20761@elte.hu>
 <20110107160459.GA2751@nowhere>
 <4D2749D6020000780002B0BC@vpn.id2.novell.com>
 <20110107162722.GA3066@nowhere>
 <20110107165843.GA7376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107165843.GA7376@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 05:58:43PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Jan 07, 2011 at 04:13:58PM +0000, Jan Beulich wrote:
> > > >>> On 07.01.11 at 17:05, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > Once I'll have perf callchain based on CFI ready, we'll perhaps find some 
> > > > issues
> > > > there. Although I guess there are already tools that can make use of that.
> > > 
> > > Is this to read that you're planning to do a re-spin of the CFI
> > > unwinding code (which I'm not allowed to submit another time,
> > > but which we've been using for years in SuSE distros) then?
> > 
> > An in-kernel CFI unwinder?
> > 
> > No the intended CFI unwinding that I'm working on for perf is made
> > on post-processing, on top of partial stack and regs snapshots.
> > 
> > The true unwinding is computed in userspace.
> 
> I think that design will be fundamentally more robust and more flexible than an 
> in-kernel unwinder.

But in fact for the kernel unwinding it still uses frame pointers which is certainly
the fastest and lightest way to unwind a stack. Very nice for our profiling.

Now one may argue about the loss of a register and its associated overhead, not
sure it's always noticeable though...
