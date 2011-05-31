Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1EaSlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:41:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44022 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1EaSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:41:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94504342"
Message-ID: <f9d67e63898f6f307e602f856fa5c001.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1105311014160.30678-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1105311014160.30678-100000@netrider.rowland.org>
Date: Tue, 31 May 2011 11:40:44 -0700 (PDT)
Subject: Re: [PATCH v14 9/9] usb: Adding SuperSpeed support to dummy_hcd
From: "Brokhman Tatyana" <tlinder@codeaurora.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, "open list" <linux-kernel@vger.kernel.org>
Reply-To: tlinder@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> If is_super_speed is false, shouldn't you avoid registering the
> SuperSpeed hub?  Or would that add too many complications?

It woun't add too many complications but I would prefere not to do that.
My goal was to simulate as much as posible "real" USB connection so the
is_super_speed flag simulates the USB port you connect to, HS/SS. When
working with a real host if you connect a HS device to a SS port it
connects to a HS root hub but the SS root hub is functional and
registered. So I don't see any reason not to register it for dummy_hcd as
well.

>> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
>> index 5927541..d5f0af7 100644
>> --- a/drivers/usb/gadget/Kconfig
>> +++ b/drivers/usb/gadget/Kconfig
>> @@ -626,6 +626,7 @@ config USB_DUMMY_HCD
>>  	depends on USB_GADGET_DUMMY_HCD
>>  	default USB_GADGET
>>  	select USB_GADGET_SELECTED
>> +	select USB_GADGET_SUPERSPEED
>
> This belongs under USB_GADGET_DUMMY_HCD, next to the "select
> USB_GADGET_DUALSPEED" line.

ok, thanks. Will update.

Thanks,
Tanya Brokhman
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


