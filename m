Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1HYT3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:29:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37444 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab1HYT3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:29:07 -0400
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1108251341230.27407@router.home>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
	 <20110818144025.8e122a67.akpm@linux-foundation.org>
	 <1314284272.27911.32.camel@twins>
	 <alpine.DEB.2.00.1108251009120.27407@router.home>
	 <1314289208.3268.4.camel@mulgrave>
	 <alpine.DEB.2.00.1108251128460.27407@router.home>
	 <986ca4ed-6810-426f-b32f-5c8687e3a10b@email.android.com>
	 <alpine.DEB.2.00.1108251206440.27407@router.home>
	 <1e295500-5d1f-45dd-aa5b-3d2da2cf1a62@email.android.com>
	 <alpine.DEB.2.00.1108251341230.27407@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 12:29:06 -0700
Message-ID: <1314300546.3268.8.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1+jejb.1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 13:46 -0500, Christoph Lameter wrote:
> On Thu, 25 Aug 2011, James Bottomley wrote:
> 
> > >Well then what is "really risc"? RISC is an old beaten down marketing
> > >term
> > >AFAICT and ARM claims it too.
> >
> > Reduced Instruction Set Computer.  This is why we're unlikely to have
> > complex atomic instructions: the principle of risc is that you build
> > them up from basic ones.
> 
> RISC cpus have instruction to construct complex atomic actions by the cpu
> as I have shown before for ARM.
> 
> Principles always have exceptions to them.
> 
> (That statement in itself is a principle that should have an exception I
> guess. But then language often only makes sense when it contains
> contradictions.)

We seem to be talking at cross purposes.  I'm not saying a risc system
can't do this ... of course the risc primitives can build into whatever
you want.  To make it atomic, you simply add locking.  What I'm saying
is that open coding asm in a macro makes no sense because the compiler
will do it better from C.  Plus, since the net purpose of this patch is
to require us to lock around each op instead of doing a global lock (or
in this case preempt disable) then you're making us less efficient at
executing it.

Therefore from the risc point of view, most of the this_cpu_xxx
operations are things that we don't really care about except that the
result would be easier to read in C.

James


