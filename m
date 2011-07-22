Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1GVQnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:43:37 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:57927 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1GVQng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:43:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E29A8B6.3060002@cam.ac.uk>
Date: Fri, 22 Jul 2011 17:43:34 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
References: <4E1D6900.6040500@cam.ac.uk> <20110713133139.GO2872@htj.dyndns.org> <4E1DA232.30408@cam.ac.uk> <878vrs2if3.fsf@rustcorp.com.au> <20110721081946.GB3455@htj.dyndns.org> <20110721083501.GC3455@htj.dyndns.org> <87sjpyzhz2.fsf@rustcorp.com.au>
In-Reply-To: <87sjpyzhz2.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/11 12:13, Rusty Russell wrote:
> On Thu, 21 Jul 2011 10:35:01 +0200, Tejun Heo <tj@kernel.org> wrote:
>> On Thu, Jul 21, 2011 at 10:19:46AM +0200, Tejun Heo wrote:
>>> On Thu, Jul 21, 2011 at 05:07:36PM +0930, Rusty Russell wrote:
>>>> From: Rusty Russell <rusty@rustcorp.com.au>
>>>> Subject: ida: Simplified functions for id allocation.
>>>>
>>>> The current hyper-optimized functions are overkill if you simply want
>>>> to allocate an id for a device.  Create versions which use an internal
>>>> lock.
>>>>
>>>> Thanks to Tejun for feedback.  Feel free to delete the #ifdef TEST
>>>> code.
>>>>
>>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>> ...
>>>>  static struct kmem_cache *idr_layer_cache;
>>>> +static DEFINE_SPINLOCK(simple_ida);
>>>
>>> I think the name is a bit confusing.  Maybe simple_ida_lock is better?
>>> Other than that,
>>
>> Ooh, one more thing, maybe it would be better to use spin_lock_irq()
>> to allow calling free under other irq locks.
> 
> Jonathan, please take original patch and mod it to taste, and produce a
> series on it you can push to Andrew.
> 
> As for irqsave etc, as soon as someone needs that we can add
> it... Jonathan will run into it soon enough.
> 
> Thanks,
> Rusty.
> 
Given the timing, it's clearly 3.2 merge window material anyway. Too late to
push any users this time round even if we hustled it through.

Quite a few 'interesting' users out there now I look into them.  Might take
a little while to get them past the relevant maintainers.

I've just sent out a few of the simpler cases.  I guess Andrew may take the core
patch and the others will route through relevant subsystems.

A few more to do. Some of them need a little more thought.

Jonathan
