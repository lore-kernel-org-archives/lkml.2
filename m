Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1EYRH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:07:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1EYRHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:07:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6357"; a="93609383"
Message-ID: <fa2182365beee6fa243f8d3957e2da2b.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1105251010580.1987-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1105251010580.1987-100000@iolanthe.rowland.org>
Date: Wed, 25 May 2011 10:07:25 -0700 (PDT)
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
From: "Brokhman Tatyana" <tlinder@codeaurora.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Tanya Brokhman" <tlinder@codeaurora.org>, balbi@ti.com,
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

Hi Alan,

> I have looked this over more carefully.  It turns out that both of you
> have misunderstood the purpose of CONFIG_USB_GADGET_DUALSPEED (and by
> extension, CONFIG_USB_GADGET_SUPERSPEED).  In fact, the existing
> Kconfig file is also wrong.
>
> The _only_ reason for CONFIG_USB_GADGET_DUALSPEED is so that gadget
> drivers can use conditional compilation to avoid including the
> high-speed descriptors when the UDC doesn't support high-speed
> operation.  That's all.  This means that the
> CONFIG_USB_GAGDET_DUALSPEED option does not need to be
> user-controllable in Kconfig.  It should default to N, and UDC drivers
> that support high speed should select it.
>
> The same should be true of CONFIG_USB_GADGET_HIGHSPEED.  It should not
> be user-controllable.  It should default to N, and UDC drivers that
> support SuperSpeed operation (after these patches, only dummy-hcd)
> should select it.

Ok, agreed. Thanks for the clarification. I saw your patch, I'll update
mine in the same way.

> There remains the other question, about whether composite_driver.speed
> should be set to USB_SPEED_SUPER.  I think the matter can be settled at
> runtime.  Iterate through all the function drivers; if all of them
> support SuperSpeed and CONFIG_USB_GADGET_SUPERSPEED is enabled then set
> composite_driver.speed to USB_SPEED_SUPER.

Not sure how to verify this. I need to know whether the driver that is
registered with the UDC is SS or not. This is before the function drivers
are binded to it. So how can I verify at that point that the function
drivers that will bind to this driver will provide SS descriptors?
(I'm sorry, I don't have the ability to view the code at the moment and
due to the time differences between us I don't want to leave this question
for tomorrow and loose another day...)

>Otherwise, if all of them
> support high speed and CONFIG_USB_GADGET_DUALSPEED is enabled then set
> composite_driver.speed to USB_SPEED_HIGH.  Otherwise set it to
> USB_SPEED_FULL.
>
> Alan Stern
>

Thanks,
Tanya Brokhman
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


