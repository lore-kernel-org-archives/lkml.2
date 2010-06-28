Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0F1Ssy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:48:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34103 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0F1Ssx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:48:53 -0400
Message-ID: <4C28EE93.3080908@kernel.dk>
Date: Mon, 28 Jun 2010 20:48:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cfq: allow dispatching of both sync and async I/O
 together
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>	<1277149789-4493-3-git-send-email-jmoyer@redhat.com>	<4C1FC4B4.3060700@kernel.dk> <20100621232208.GA10175@redhat.com>	<20100622040700.GA12502@redhat.com> <x49lj9zdmr2.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lj9zdmr2.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 20.40, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
>> On Mon, Jun 21, 2010 at 07:22:08PM -0400, Vivek Goyal wrote:
>>> On Mon, Jun 21, 2010 at 09:59:48PM +0200, Jens Axboe wrote:
>>>> On 21/06/10 21.49, Jeff Moyer wrote:
>>>>> Hi,
>>>>>
>>>>> In testing a workload that has a single fsync-ing process and another
>>>>> process that does a sequential buffered read, I was unable to tune CFQ
>>>>> to reach the throughput of deadline.  This patch, along with the previous
>>>>> one, brought CFQ in line with deadline when setting slice_idle to 0.
>>>>>
>>>>> I'm not sure what the original reason for not allowing sync and async
>>>>> I/O to be dispatched together was.  If there is a workload I should be
>>>>> testing that shows the inherent problems of this, please point me at it
>>>>> and I will resume testing.  Until and unless that workload is identified,
>>>>> please consider applying this patch.
>>>>
>>>> The problematic case is/was a normal SATA drive with a buffered
>>>> writer and an occasional reader. I'll have to double check my
>>>> mail tomorrow, but iirc the issue was that the occasional reader
>>>> would suffer great latencies since service times for that single
>>>> IO would be delayed at the drive side. It could perhaps just be
>>>> a bug in how we handle the slice idling on the read side when the
>>>> IO gets delayed initially.
>>>>
> 
> [...]
> 
>> Some primilinary testing results with and without patch. I started a
>> buffered writer and started firefox and monitored how much time firefox
>> took.
>>
>> dd if=/dev/zero of=zerofile bs=4K count=1024M
>>
>> 2.6.35-rc3 vanilla
>> ==================
>> real    0m22.546s
>> user    0m0.566s
>> sys     0m0.107s
>>
>>
>> real    0m21.410s
>> user    0m0.527s
>> sys     0m0.095s
>>
>>
>> real    0m27.594s
>> user    0m1.256s
>> sys     0m0.483s
>>
>> 2.6.35-rc3 + jeff's patches
>> ===========================
>> real    0m20.372s
>> user    0m0.635s
>> sys     0m0.128s
>>
>> real    0m22.281s
>> user    0m0.509s
>> sys     0m0.093s
>>
>> real    0m23.211s
>> user    0m0.674s
>> sys     0m0.140s
>>
>> So looks like firefox launching times have not changed much in the presence
>> of heavy buffered writting going on root disk. I will do more testing tomorrow.
> 
> Jens,
> 
> What are your thoughts on this?  Can we merge it?

I'll add it to the .36 testing mix. I will re-run my older tests on the
end result, I really don't want to regress on the latency side. The above
numbers look OK.

-- 
Jens Axboe

