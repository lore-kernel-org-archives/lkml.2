Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1BJNBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:01:25 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12087 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1BJNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:01:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6252"; a="73699554"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1296133918-31099-1-git-send-email-tlinder@codeaurora.org> <Pine.LNX.4.44L0.1101271116470.2090-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101271116470.2090-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v7 1/5] usb: Adding SuperSpeed support to dummy_hcd
Date: Thu, 10 Feb 2011 15:01:20 +0200
Message-ID: <001601cbc922$a0abb630$e2032290$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acu+PxveVr2G6Bd6RqGvhJZZNRHUigK4j03A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (dum->gadget.speed < USB_SPEED_SUPER)
> > +		max &= 0x3ff;
> 
> Strictly speaking, both the old and the new code are wrong.  For all
> devices, regardless of speed, we should say:
> 
> 	max = le16_to_cpu(desc->wMaxPacketSize) & 0x7ff;
> 
> In other words, the speed is contained in bits 0..10 (not 0..9).
> 

You're right about HS/FS/LS devices but I see something different in the
USB30 spec for SS devices. Could you please refer me to what errata this was
mentioned in? I looked through them and according to errata from 01/15/09
the definition of wMaxPacketSize field in the SS endpoint descriptor is:

"Maximum packet size this endpoint is capable of sending or receiving when
this configuration is selected. For control endpoints this field shall be
set to 512. For bulk endpoint types this field shall be set to 1024."

So according to the above, for SS devices, the whole 2 bytes contain the
maxpacketsize and not only bits 0..10. 
Am I missing something?

I'll fix this for all devised but SS.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




