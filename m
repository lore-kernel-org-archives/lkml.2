Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0DOXuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:50:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45652 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab0DOXum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:50:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=FYeICH68G3hq8/klNPfaH3y6w0YITwEMiT069WJa65GlK3BYCL589ML4ijal/w3ki
	G3SUvvg0q1Yaa6W7tFcXQ==
MIME-Version: 1.0
In-Reply-To: <x49zl14hm18.fsf@segfault.boston.devel.redhat.com>
References: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com> 
	<x49zl14hm18.fsf@segfault.boston.devel.redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Thu, 15 Apr 2010 16:50:17 -0700
Message-ID: <w2laf41c7c41004151650j1c1bdbb6s2ccce50b2de2fbd1@mail.gmail.com>
Subject: Re: [PATCH 0/4] block: Per-partition block IO performance histograms
To: Jeff Moyer <jmoyer@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       rickyb@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 6:40 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Divyesh Shah <dpshah@google.com> writes:
>
>> The following patchset implements per partition 2-d histograms for IO to block
>> devices. The 3 types of histograms added are:
>>
>> 1) request histograms - 2-d histogram of total request time in ms (queueing +
>>    service) broken down by IO size (in bytes).
>> 2) dma histograms - 2-d histogram of total service time in ms broken down by
>>    IO size (in bytes).
>> 3) seek histograms - 1-d histogram of seek distance
>>
>> All of these histograms are per-partition. The first 2 are further divided into
>> separate read and write histograms. The buckets for these histograms are
>> configurable via config options as well as at runtime (per-device).
>
> Do you also keep track of statistics for the entire device?  The I/O
> schedulers operate at the device level, not the partition level.

Yes. This patch maintains stats for part0 too which represents the
entire device.

>
>> These histograms have proven very valuable to us over the years to understand
>> the seek distribution of IOs over our production machines, detect large
>> queueing delays, find latency outliers, etc. by being used as part of an
>> always-on monitoring system.
>>
>> They can be reset by writing any value to them which makes them useful for
>> tests and debugging too.
>>
>> This was initially written by Edward Falk in 2006 and I've forward ported
>> and improved it a few times it across kernel versions.
>>
>> He had also sent a very old version of this patchset (minus some features like
>> runtime configurable buckets) back then to lkml - see
>> http://lkml.indiana.edu/hypermail/linux/kernel/0611.1/2684.html
>> Some of the reasons mentioned for not including these patches are given below.
>>
>> I'm requesting re-consideration for this patchset in light of the following
>> arguments.
>>
>> 1) This can be done with blktrace too, why add another API?
> [...]
>> This is about 1.8% average throughput loss per thread.
>> The extra cpu time spent with blktrace is in addition to this loss of
>> throughput. This overhead will only go up on faster SSDs.
>
> I don't see any analysis of the overhead of your patch set.  Would you
> mind providing those numbers?

I will try to run some tests and come back with more results (as
mentioned on the earlier response, there will be some delay).

Thanks,
Divyesh

>
> Thanks,
> Jeff
>
