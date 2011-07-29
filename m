Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1G2Ou3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:50:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51697 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1G2Ou2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:50:28 -0400
Message-ID: <4E32C89C.4010609@gmail.com>
Date: Fri, 29 Jul 2011 22:50:04 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>	<CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>	<4E325F98.5090308@gmail.com>	<CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>	<4E32A105.6080509@gmail.com>	<CAJSP0QUV1C3O6SuXzFKMi5t61T+Qa-Yy2yWEevuuAvyQarJ47g@mail.gmail.com> <CAJSP0QUbZ=RAkn_kbDupeA9QYYnzGd+u5M2duEg==e8ACjAqXg@mail.gmail.com> <4E32C79A.80606@gmail.com>
In-Reply-To: <4E32C79A.80606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 10:45 PM, Liu Yuan wrote:
> On 07/29/2011 08:50 PM, Stefan Hajnoczi wrote:
>> I hit a weirdness yesterday, just want to mention it in case you 
>> notice it too.
>>
>> When running vanilla qemu-kvm I forgot to use aio=native.  When I
>> compared the results against virtio-blk-data-plane (which *always*
>> uses Linux AIO) I was surprised to find average 4k read latency was
>> lower and the standard deviation was also lower.
>>
>> So from now on I will run tests both with and without aio=native.
>> aio=native should be faster and if I can reproduce the reverse I'll
>> try to figure out why.
>>
>> Stefan
> On my laptop, I don't meet this weirdo. the emulated POSIX AIO is much 
> worse than the Linux AIO as expected. If iodepth goes deeper, the gap 
> gets wider.
>
> If not set aio=none, qemu uses emulated posix aio interface to do the 
> IO. I peek at the posix-aio-compat.c,it uses thread pool and sync 
> preadv/pwritev to emulate the AIO behaviour. The sync IO interface 
> would even cause much poorer performance for random rw, since 
> io-scheduler would possibly never get a chance to merge the requests 
> stream. (blk_finish_plug->queue_unplugged->__blk_run_queue)
>
> Yuan
Typo. not merge, I mean *sort* the reqs
