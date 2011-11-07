Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1KGNQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:16:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42050 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1KGNQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:16:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111101082653.4fa844e4@bike.lwn.net>
References: <CANudz+unARaENw50p2iL_Ur1YQj0f=9Ndev0OyZ=790xDjbTCw@mail.gmail.com>
	<20111101082653.4fa844e4@bike.lwn.net>
Date: Mon, 7 Nov 2011 21:16:39 +0800
Message-ID: <CANudz+soE9ax7668gh2TRxfnvPoAapKunwsXCc-T3ff0GAL6zg@mail.gmail.com>
Subject: Re: some questions about block and scatterlist
From: loody <miloody@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jonathan:
2011/11/1 Jonathan Corbet <corbet@lwn.net>:
> On Tue, 1 Nov 2011 19:32:38 +0900
> loody <miloody@gmail.com> wrote:
>
>> My questions are below:
>
> As are some answers :)
That will be great appreciated :)
>
>> 1. Are all struct page 32-bit aligned?
>
> Certainly, I would expect any structures found in the system memory map to
> be so aligned, yes.  If you've created an arbitrary one elsewhere I'm only
> 99% sure it would be.
>
>> If so, where is this part of code for handleing struct page be 32-bits aligned?
>
> Note that the size of struct page is carefully considered, and that they
> are packed as densely as possible, both externally and internally.  No
> lesser alignment would make sense.
I found kernel stealing LSB of page_link to put additional
information, such as sg_is_chain and sg_is_last.

That means the address of all pages have to be at least 4byte alignment.
But I didn't see any additional attribute added at the end of struct
or any precaution to take care this.

>
>> 2. if the page of scatterlist is located at high mem, how does
>> dma_map_sg mapping the virtual address?
>
> That depends on a vast array of things.  What are the addressing
> capabilities of the target device?  Is there an IOMMU involved?
No, my device has no iommu. and I found where kernel handle this part.
>
>> 3. in blk_rq_map_sg, it seems we only copy bvec->bv_page to sg->page_link
>>    why don't we add dma_address in bvec and send the bio directly to
>> the lower level driver?
>
> That would be a bit of a mixing of the layers, if nothing else.
>
>> 4. if I plug a USB HD with 3 partitions, will there be 3 request_queues?
>
> No, there is one request queue for the underlying device.
I study some block devices and it seems we use blk_init_queue for
getting a request_queue, if we want block layer handle requests and
coalesces adjacent requests.
what happen and lower driver need to do if we don't use blk_init_queue
to register a request_queue?

>
> That's an interesting mix of questions.  If you have more in the future,
> you'll likely get more (and more clueful) responses if they're accompanied
> by the code you're working on.
>
> Thanks,
>
> jon

-- 
Regards,
