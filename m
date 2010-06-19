Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0FSJOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:14:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:48734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab0FSJOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:14:06 -0400
Message-ID: <4C1C8A18.2030709@kernel.org>
Date: Sat, 19 Jun 2010 11:12:56 +0200
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
References: <1276694825.9309.12.camel@m0nster> <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster> <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster> <1276776066.2461.15.camel@localhost> <87vd9fo1sk.fsf@basil.nowhere.org> <4C1C8263.9040404@kernel.org> <87fx0jo0z6.fsf@basil.nowhere.org> <4C1C8772.8090406@kernel.org> <20100619090851.GF18946@basil.fritz.box>
In-Reply-To: <20100619090851.GF18946@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Jun 2010 09:12:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/19/2010 11:08 AM, Andi Kleen wrote:
> I think it's reasonable to just put on front. The individual
> items shouldn't take that long, right?
> 
> (in fact I have an older patch for work queues which implemented
> that) 

Well, in general, queueing to execution latency should be fairly low
especially if it's put at the front of the queue but well it's nothing
with any kind of guarantee.

>> If there are multiple of such use cases, it would make sense to create
>> a prioritized worker pools along with prioritized per-cpu queues but
>> if there are only a few of them, I think it makes more sense to use
>> dedicated threads for them.  Do those threads need to be per-cpu?
> 
> Not strictly, although it might be useful on a error flood when
> a whole DIMM goes bad.

I'm currently writing a kthread wrapper which basically provides
similar interface to wq but guarantees binding to a specific thread
which can be RT of course.  If single threadedness is acceptable, I
think this would render better behavior.  What do you think?

Thanks.

-- 
tejun
