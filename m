Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0FSIlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:41:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46534 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0FSIlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:41:23 -0400
Message-ID: <4C1C8263.9040404@kernel.org>
Date: Sat, 19 Jun 2010 10:40:03 +0200
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
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	<1276776066.2461.15.camel@localhost> <87vd9fo1sk.fsf@basil.nowhere.org>
In-Reply-To: <87vd9fo1sk.fsf@basil.nowhere.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Jun 2010 08:40:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 10:38 AM, Andi Kleen wrote:
> Andy Walls <awalls@md.metrocast.net> writes:
>>
>> I'm going to agree with Tejun, that tweaking worker thread priorities
>> seems like an odd thing, since they are meant to handle deferable
>> actions - things that can be put off until later.
> 
>> If one needs to support Real Time deadlines on deferable actions,
>> wouldn't using dedicated kernel threads be more deterministic?
>> Would the user ever up the priority for a workqueue other than a
>> single-threaded workqueue?
> 
> One exceptional case here are things like high priority error handling
> which is rare.
> 
> For example you get an MCE that tells you some of your
> memory got corrupted and you should handle it ASAP.
> Better give it high priority then.
> 
> But it's still a rare event so you don't want dedicated
> threads hanging around for it all time
> (that's what we currently have and it causes all sorts
> of problems)
> 
> So yes I think having a priority mechanism for work items
> is useful.

Wouldn't that be better served by cpu_stop?

Thanks.

-- 
tejun
