Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1GSKgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 06:36:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54046 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1GSKgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 06:36:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6411"; a="104581558"
Message-ID: <73f3a41d26b2e3462c93c3c3b85706ca.squirrel@www.codeaurora.org>
In-Reply-To: <201107191226.58593.oneukum@suse.de>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
    <201107191118.48536.oneukum@suse.de>
    <072dac57b14fc739033c65fe289234c3.squirrel@www.codeaurora.org>
    <201107191226.58593.oneukum@suse.de>
Date: Tue, 19 Jul 2011 03:36:05 -0700 (PDT)
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to 
     devio.c
From: "Amit Blay" <ablay@codeaurora.org>
To: "Oliver Neukum" <oneukum@suse.de>
Cc: "Amit Blay" <ablay@codeaurora.org>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        "Amit Blay" <ablay@qualcomm.com>,
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

Hi Oliver,

>> >> 1. Interface number [IN]
>> >> 2. Bitmap indicating which EP to allocate streams for [IN]
>> >
>> > If this is a bitmap,
>> >
>> >> 3. Number of streams to allocate, one number [IN}
>> >> 4. Number of streams actually allocated, one number  [OUT]
>> >
>> > how can those be scalars?
>> >
>>
>> The bitmap only indicates which EP the user space requests to allocate
>> streams for. The actual number is taken from #3.
>
> Exactly. If you specify EP with a bitmap, what do you do if multiple bits
> are set in the map?
>

The user space can pass multiple EPs to allocate streams for. This is
aligned with the HCD API which expects an array of EPs and number of
streams to allocate. Please have a look in xhci.c.

I suggest to pass a bitmap from user space to represent the list of EPs.
An alternative is to pass an array, but I didn't find any real advantage
for this.

Thanks,
Amit.

 --
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

