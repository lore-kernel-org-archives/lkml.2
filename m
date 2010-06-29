Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0F2Pst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:48:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:51708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458Ab0F2Psr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:48:47 -0400
Message-ID: <4C2A1558.7060007@kernel.org>
Date: Tue, 29 Jun 2010 17:46:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere>
In-Reply-To: <20100629121855.GA5318@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 15:46:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 02:18 PM, Frederic Weisbecker wrote:
>> Yeah, well, that's kind of the whole point of cmwq.  It would try to
>> minimize the number of used workers but the provided concurrency will
>> still be enough.  No async probe will be stalled due to lack of
>> execution context and the timings should be about the same between the
>> original async implemetnation and cmwq based one.
> 
> Right. I just don't know what is supposed to be slow on boot that
> needs to use async.  Is that because reading some ports is slow or
> because we need to do something and wait for some times to get the
> result.

It's things like ATA bus resetting and probing.  They're usually
composed of short CPU activities and rather long sleeps.

> If there is a question of slow ports to probe, then cmwq wouldn't seem the
> right thing here, as it only forks when we go to sleep.

I lost you here.  If something during boot has to burn cpu cycles
(which it shouldn't, really), it has to burn cpu cycles and having
multiple concurent threads won't help anything.  If something doesn't
burn cpu cycles but takes long, it gotta sleep and cmwq will start a
new thread immediately.  So, can you please elaborate why cmwq would
be problematic?

Thanks.

-- 
tejun
