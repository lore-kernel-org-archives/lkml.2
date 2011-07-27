Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1G0GVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:21:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11079 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1G0GVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:21:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6419"; a="105950878"
Message-ID: <a9d8b0f164cdb51e88125d8432644213.squirrel@www.codeaurora.org>
In-Reply-To: <8bcfda19cbc633e011e6b28a6183e68b.squirrel@www.codeaurora.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
    <1308231068-24038-6-git-send-email-tlinder@codeaurora.org>
    <20110630174538.GA7979@xanatos>
    <8bcfda19cbc633e011e6b28a6183e68b.squirrel@www.codeaurora.org>
Date: Tue, 26 Jul 2011 23:21:35 -0700 (PDT)
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to  
         devio.c
From: "Amit Blay" <ablay@codeaurora.org>
To: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Cc: "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, "Amit Blay" <ablay@qualcomm.com>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

A gentle reminder, can you please take a look at the proposed solution
below for stream alloc/dealloc in devio.c? I responded to your comments
about the original patch.

On Tue, July 19, 2011 2:12 am, Amit Blay wrote:
> Hi Sarah,
>
> I apologize for the delay responding to the thread. Thanks for your
> comments. I would like to continue and fix the previous patch according to
> the comments.
> Also, I would like to split this patch, and implement the actual usage of
> streams for bulk EP transfers (passing the stream ID with the URB) to a
> different patch.
>
>>
>> It looks like userspace doesn't have a way to specify the number of
>> streams USBFS needs to allocate.  Not all userspace applications are
>
>> You probably also need a way to communicate back to userspace how many
>> streams were actually allocated.  The program could choose to free
>
>> So you're just taking the max_streams from the first endpoint that has
>> streams?  What if other endpoints have varying numbers of max streams?
>
>> What if you have endpoints on an interface that don't support streams?
>
>> So it seems like you also need a way for userspace to specify which
>> endpoints get streams, and which endpoints have streams freed.  I will
>
> What I have in mind is user space passing a structure holding:
>
> 1. Interface number [IN]
> 2. Bitmap indicating which EP to allocate streams for [IN]
> 3. Number of streams to allocate, one number [IN}
> 4. Number of streams actually allocated, one number  [OUT]
>
> The devio alloc function will double check if all EPs belong to the
> interface passed by the user space.
> Then it will call the HCI alloc function with the required number of
> streams. It will return the number of streams actually allocated by the
> HCD. Items 3 & 4 can be merged to one IN/OUT parameter.
>
> No error checking will be done in devio for number of required streams
> (i.e, comparing it with the reported max streams). This kind of error
> checking is already done by the xHCI driver.
>
> Please let me know if the solution is acceptable.
>
> Thanks,
> Amit.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

