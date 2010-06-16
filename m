Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546Ab0FPT7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:59:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0FPT7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:59:19 -0400
Message-ID: <4C192CD5.8080602@kernel.org>
Date: Wed, 16 Jun 2010 21:58:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>	 <4C191BE9.1060400@kernel.org>  <4C192404.7000004@kernel.org> <1276717576.9309.218.camel@m0nster>
In-Reply-To: <1276717576.9309.218.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 19:58:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/16/2010 09:46 PM, Daniel Walker wrote:
>> If you actually _solve_ the problem like this, other users wouldn't
>> experience the problem at all once the update reaches them and you
>> won't have to worry about your workaround breaking with the next
>> kernel update or unexpected suspend/resume and we won't be having this
>> discussion about adjusting workqueue priorities from userland.
> 
> What you suggesting just means the user has to adjust an interrupt
> thread instead of a workqueue thread. That really doesn't change
> anything, since it's just another type of kernel thread.

It allows writing an interrupt handler which requires context and
PREEMPT_RT kernel will handle priority inheritance correctly with
them, so there's no priority inversion problem.

>> There are many wrong things about working around RT latency problems
>> by setting workqueue priorities from userland.  Please think about why
>> the driver would have a separate workqueue for itself in the first
>> place.  It was to work around the limitation of workqueue facility and
>> you're arguing that, because that work around allows yet another very
>> fragile workaround, the property which made the original work around
>> necessary in the first place needs to stay.  That sounds really
>> perverse to me.
> 
> I have no idea what your trying to say here.. I'm sure there is no one
> reason why people use workqueues in their drivers. In fact I'm sure
> there are many reasons to use workqueues or not to use them.

I mean that if workqueues don't have current limitations, there's no
reason for most drivers which aren't in the allocation path to use
separate workqueues.  They can simply use the default system one.

Thanks.

-- 
tejun
