Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1EYSOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:14:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53020 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1EYSOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:14:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6357"; a="93435917"
Message-ID: <8ce4e30b4a406fadf08af2daff163984.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1105251316170.1987-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1105251316170.1987-100000@iolanthe.rowland.org>
Date: Wed, 25 May 2011 11:13:51 -0700 (PDT)
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
From: "Brokhman Tatyana" <tlinder@codeaurora.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Brokhman Tatyana" <tlinder@codeaurora.org>, balbi@ti.com,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
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


 composite_driver.speed to USB_SPEED_SUPER.
>>
>> Not sure how to verify this. I need to know whether the driver that is
>> registered with the UDC is SS or not. This is before the function
>> drivers
>> are binded to it. So how can I verify at that point that the function
>> drivers that will bind to this driver will provide SS descriptors?
>> (I'm sorry, I don't have the ability to view the code at the moment and
>> due to the time differences between us I don't want to leave this
>> question
>> for tomorrow and loose another day...)
>
> I'm not sure about this either.  I have never used the composite
> framework so I'm not familiar with its details.  This has to be decided
> before the composite gadget driver registers with the UDC driver ...
Right, but at this point there is no way of knowing what function drivers
will bind to it and what descriptors they will provide. Most of the
function drivers allocate their descriptors at bind() that occurs after
the UDC already registers.

> and surely that can't happen until all the function drivers have
> registered with the composite driver?  After all, the gadget can't be
> enumerated until all the function drivers are registered.
Right, but it doesn't mean that the composite driver can't register with
the UDC until all the function drivers are registered. Actually, the
composite driver binds when no function driver has yet registered with it.

> Maybe this logic can be put in usb_add_function()?  That routine
> already deals with issues involving device speed and available
> descriptors.
That's too late. The composite driver is registered by the time
usb_add_function() is called.

Tanya Brokhman
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


