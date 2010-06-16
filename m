Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab0FPNkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:40:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:60763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab0FPNke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:40:34 -0400
Message-ID: <4C18D420.8090008@kernel.org>
Date: Wed, 16 Jun 2010 15:39:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org> <1276695468.3640.19.camel@jlt3.sipsolutions.net>
In-Reply-To: <1276695468.3640.19.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 13:39:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 03:37 PM, Johannes Berg wrote:
>> As multiple execution contexts are available for each wq, deadlocks
>> around execution contexts is much harder to create.  The default
>> workqueue, system_wq, has maximum concurrency level of 256 and unless
>> there is a use case which can result in a dependency loop involving
>> more than 254 workers, it won't deadlock.
> 
> I see a lot of stuff about the current limitations etc., but nothing
> about code that actually _relies_ on the synchronisation properties of
> the current wqs. We talked about that a long time ago, is it still
> guaranteed that a single-threaded wq will serialise all work put onto
> it? It needs to be, but I don't see you explicitly mentioning it.

Oh yeah, if you have WQ_SINGLE_CPU + max inflight of 1, works on the
wq are fully ordered.

-- 
tejun
