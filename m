Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0F2MSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:18:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52231 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0F2MSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FD5vXdOnC8DfQX57/UZ86WSLWyePm2VoRyjPnQJZelmDGSRm71twVgiYGFR3XVpANI
         Q6BlQyZTJ36xUxuF+1HnyqHcnJTCXyg6vJwV1shfCa09mrGoxFagQXLjhz5AH3HkQtvF
         juX0IOgPQ9K4PCMS+7e87B7uL8FMu5qeOhW8E=
Date: Tue, 29 Jun 2010 14:18:58 +0200
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
Message-ID: <20100629121855.GA5318@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C299FD8.7030904@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 09:25:12AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/29/2010 12:55 AM, Frederic Weisbecker wrote:
> > On Mon, Jun 28, 2010 at 11:04:22PM +0200, Tejun Heo wrote:
> >> Replace private worker pool with system_long_wq.
> > 
> > It appeared to me that async is deemed to parallelize as much as
> > possible, to probe devices faster on boot for example, while cmwq
> > seems to do the opposite: trying to execute in batches as much as
> > possible, and fork when a work goes to sleep voluntarily.
> 
> Yeah, well, that's kind of the whole point of cmwq.  It would try to
> minimize the number of used workers but the provided concurrency will
> still be enough.  No async probe will be stalled due to lack of
> execution context and the timings should be about the same between the
> original async implemetnation and cmwq based one.
> 
> Thanks.


Right. I just don't know what is supposed to be slow on boot that needs
to use async. Is that because reading some ports is slow or because we
need to do something and wait for some times to get the result.

If there is a question of slow ports to probe, then cmwq wouldn't seem the
right thing here, as it only forks when we go to sleep.

