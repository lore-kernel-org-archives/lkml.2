Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0F2PwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:52:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34691 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0F2PwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C+t7EvmdtCS4LkU4Z8dtdHYxQjYCHsNMR+Gfu4980SmHYv+nX97Qyhh7makXExlAO6
         qDURzswVBMsG2R9ggZK8q+Ke/iQ+nxroVtH7dBjTxANWLvtYjafHsZRTSJsJ6I3vGY4X
         3nYQHyzNhoVeP+2WcTAGAFVlxMkVx7+i6s02E=
Date: Tue, 29 Jun 2010 17:52:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
Message-ID: <20100629155228.GK5318@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2A1558.7060007@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 05:46:32PM +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/29/2010 02:18 PM, Frederic Weisbecker wrote:
> >> Yeah, well, that's kind of the whole point of cmwq.  It would try to
> >> minimize the number of used workers but the provided concurrency will
> >> still be enough.  No async probe will be stalled due to lack of
> >> execution context and the timings should be about the same between the
> >> original async implemetnation and cmwq based one.
> > 
> > Right. I just don't know what is supposed to be slow on boot that
> > needs to use async.  Is that because reading some ports is slow or
> > because we need to do something and wait for some times to get the
> > result.
> 
> It's things like ATA bus resetting and probing.  They're usually
> composed of short CPU activities and rather long sleeps.


Ok.


 
> > If there is a question of slow ports to probe, then cmwq wouldn't seem the
> > right thing here, as it only forks when we go to sleep.
> 
> I lost you here.  If something during boot has to burn cpu cycles
> (which it shouldn't, really), it has to burn cpu cycles and having
> multiple concurent threads won't help anything.



It would on SMP.



> If something doesn't
> burn cpu cycles but takes long, it gotta sleep and cmwq will start a
> new thread immediately.  So, can you please elaborate why cmwq would
> be problematic?


No in this case it's not problematic, as far as the things that were using
async have a small cpu burn and long sleep waiting, it looks like cmwq
fits :)

