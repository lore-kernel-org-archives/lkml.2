Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0FPNbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:31:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:34309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab0FPNbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:31:17 -0400
Message-ID: <4C18D1FD.9060804@kernel.org>
Date: Wed, 16 Jun 2010 15:30:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
In-Reply-To: <1276694825.9309.12.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 13:30:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 03:27 PM, Daniel Walker wrote:
>> Yes, that is.  With new cmwq, a wq can't assume association with
>> specific kthread and thus can't use wq as simple frontend to kthreads,
>> but if somebody wants dedicated kthreads instead of shared ones in
>> units of work, [s]he should be using kthread.
> 
> I'm not talking about coders using workqueues when they should be using
> kthreads .. We're talking about currently existing workqueues. Aren't
> you converting all _current_ workqueues to your system?

Yes, sure I'm but which current users are you talking about?

>> wq does provide nicer tools for synchronization but in general I don't
>> think using kthread is too hard and there aren't too many cases
>> anyway.  If there are many users && kthread is difficult to use
>> directly, we can definitely write up a wrapping layer tho.  But I
>> really think using wq as wrapper around kthreads and manipulating
>> worker thread directly is an abusement.
> 
> It would be a hack the user would have to patch onto there kernel in
> order to get back functionality your taking away.
> 
> I think from your perspective workqueue threads are all used for
> "concurrency management" only, but I don't think that's true. Some will
> be user for prioritization (I'm talking about _current_ workqueues).
> 
> Could you address or ponder how the work items could be prioritized
> under your system?

Again, please give me some examples.

Thanks.

-- 
tejun
