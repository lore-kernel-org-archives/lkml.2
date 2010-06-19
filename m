Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0FSJC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:02:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:34456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab0FSJC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:02:58 -0400
Message-ID: <4C1C8772.8090406@kernel.org>
Date: Sat, 19 Jun 2010 11:01:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	<1276776066.2461.15.camel@localhost>	<87vd9fo1sk.fsf@basil.nowhere.org> <4C1C8263.9040404@kernel.org> <87fx0jo0z6.fsf@basil.nowhere.org>
In-Reply-To: <87fx0jo0z6.fsf@basil.nowhere.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Jun 2010 09:01:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/19/2010 10:55 AM, Andi Kleen wrote:
> Tejun Heo <tj@kernel.org> writes:
>>
>> Wouldn't that be better served by cpu_stop?
> 
> No the error handling has to be able to sleep to take VM
> locks. That's the whole point its handed off to a
> workqueue. Otherwise it could be done directly.

I see.  The thing is that if you have "as soon as possible" + "high
priority", you're basically required to have a dedicated worker or
dedicated pool of them.  Making cmwq to support some level of priority
definitely is possible (multiple prioritized queues or pushing work at
the front at the simplest) but for such emergency works it doesn't
make sense to share the usual worker pool, as resource pressure can
easily make any work wait regardless of where they're in the queue.

If there are multiple of such use cases, it would make sense to create
a prioritized worker pools along with prioritized per-cpu queues but
if there are only a few of them, I think it makes more sense to use
dedicated threads for them.  Do those threads need to be per-cpu?

Thanks.

-- 
tejun
