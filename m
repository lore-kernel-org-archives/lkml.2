Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824Ab2HAGu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 02:50:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54449 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab2HAGu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 02:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120731200855.GC10335@n2100.arm.linux.org.uk>
References: <20120730202401.GA4947@gobelin>
	<20120731064557.GA4676@gobelin>
	<20120731090931.GP6802@n2100.arm.linux.org.uk>
	<CACYmx9MnEn_XOosBn2-YJ=ny9FiLPADMNa6okwG08xrSpCUSpA@mail.gmail.com>
	<20120731200855.GC10335@n2100.arm.linux.org.uk>
Date: Wed, 1 Aug 2012 08:50:24 +0200
Message-ID: <CACYmx9OBhp+8XF3AxVeW2cnVKkTtRsMwf5U-oiFxnJV2Vbzoug@mail.gmail.com>
Subject: Re: About dma_sync_single_for_{cpu,device}
From: Karl Beldan <karl.beldan@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/12, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Tue, Jul 31, 2012 at 09:31:13PM +0200, Karl Beldan wrote:
>> On 7/31/12, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> > On Tue, Jul 31, 2012 at 08:45:57AM +0200, Karl Beldan wrote:
>> >> I was expecting the following to work:
>> >> 	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);
>> >> 	dma_sync_single_for_device(dev, buffer, pattern_size,
>> >> DMA_FROM_DEVICE);
>> >> 	dev_send(buffer);
>> >> 	// wait for irq (don't peek in the buffer) ... got irq
>> >> 	dma_sync_single_for_cpu(dev, buffer, pattern_size, DMA_FROM_DEVICE);
>> >> 	if (!xfer_done(buffer)) // not RAM value
>> >> 		dma_sync_single_for_device(dev, buffer, pattern_size,
>> >> DMA_FROM_DEVICE);
>> >> 	[...]
>> >
>>
>> Hi Russell,
>>
>>
>> > First point is that you clearly do not understand the DMA API at all.
>> > The
>> > DMA API has the idea of buffer ownership.  Only the owner may access
>> > the
>> > buffer:
>> >
>> Are you saying that this scenario does not work ?
>> We are taking some liberties with the DMA API, we're more using some
>> of its funcs rather than _using_ it ;).
>> The question was not whether this was a proper usage of the API, but
>> why that scenario would not lead to the expected results .. and now
>> I've found the culprit peek I am happy.
>
> If you abuse the API don't expect your stuff to work in future kernel
> versions.
>
Of course.

> It seems that the overall tone of your reply is "what we have now works,
> we don't care if it's correct, sod you."
>
Not at all : {
On 7/31/12, Karl Beldan <karl.beldan@gmail.com> wrote:
> I might use something different in a not so distant future, yet, for
> the time being, this way of doing as its advantages.
} and during this time I might stick to the API.
I am not at ease telling people how they should take things,
especially if I asked for their help, all the more when they put
efforts within the exchange while being expert on the matter, yet
please, do not assume I did not care for your advices, which I deem of
the most valuable, as, needless to say, do the community.

> Fine, I won't spend any more time on this.  Just don't ever think about
> merging it into mainline, thanks.
>
Merge submission while taking such liberties .. that I would not dare
;) this really was a down to the ground technical question not the
start of a disguised start of a merging request.

I am sure that taking such liberties and feeling its limits before
sticking to a super safe API is not a bad thing, e.g it might trigger
easierly nasty hidden bugs, it is often beneficial to me at least.

Thanks for your feedback,

Karl
