Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab1FQIzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:55:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19456 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab1FQIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:55:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6379"; a="98112683"
Message-ID: <8196aa784ab3686cb19581131df0be16.squirrel@www.codeaurora.org>
In-Reply-To: <20110616182141.GC1439@kroah.com>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
    <1308231068-24038-6-git-send-email-tlinder@codeaurora.org>
    <20110616162839.GY12230@legolas.emea.dhcp.ti.com>
    <20110616182141.GC1439@kroah.com>
Date: Fri, 17 Jun 2011 01:55:40 -0700 (PDT)
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to 
     devio.c
From: ablay@codeaurora.org
To: "Greg KH" <greg@kroah.com>
Cc: "Felipe Balbi" <balbi@ti.com>, "Tatyana Brokhman" <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
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

> On Thu, Jun 16, 2011 at 07:28:40PM +0300, Felipe Balbi wrote:
>> On Thu, Jun 16, 2011 at 04:31:07PM +0300, Tatyana Brokhman wrote:
>> > Allow user space applications such as LIBUSB, to request
>> > streams alloc/dealloc from HCD that implements XHCI.
>> >
>> > Signed-off-by: Amit Blay <ablay@qualcomm.com>
>> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>>
>> other than what Alan said, this needs major splitting. This patch is too
>> big. First we need to discuss the ABI details with the guys at
>> libusb-devel, then we implement.
>
> No, we don't break the abi, but rather, create a new one for streams,
> and then we can work on adding them to libusb, which should be quite
> easy when done.
>
> thanks,
>
> greg k-h
>

My name is Amit Blay, I'm working with Tatyana Brokhman, I originally
created this patch. I want to make sure I understand the solution:

We will create a new IOCTL, i.e., USBDEVFS_SUBMITURB_SS. This IOCTL will
pass new URB structure, usbdevfs_urb_ss, which will hold the "legacy" URB
and in addition the stream_id. libusb will be able to use the new ABI
whenever SuperSpeed streams are required.

Is this correct?

Thanks,
Amit Blay,
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


