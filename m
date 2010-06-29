Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0F2H0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:26:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:48428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab0F2H0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:26:41 -0400
Message-ID: <4C299FD8.7030904@kernel.org>
Date: Tue, 29 Jun 2010 09:25:12 +0200
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
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere>
In-Reply-To: <20100628225513.GB10104@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 07:25:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 12:55 AM, Frederic Weisbecker wrote:
> On Mon, Jun 28, 2010 at 11:04:22PM +0200, Tejun Heo wrote:
>> Replace private worker pool with system_long_wq.
> 
> It appeared to me that async is deemed to parallelize as much as
> possible, to probe devices faster on boot for example, while cmwq
> seems to do the opposite: trying to execute in batches as much as
> possible, and fork when a work goes to sleep voluntarily.

Yeah, well, that's kind of the whole point of cmwq.  It would try to
minimize the number of used workers but the provided concurrency will
still be enough.  No async probe will be stalled due to lack of
execution context and the timings should be about the same between the
original async implemetnation and cmwq based one.

Thanks.

-- 
tejun
