Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1C0M0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 08:26:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1C0M0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 08:26:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6297"; a="82123209"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1300867420-20864-1-git-send-email-tlinder@codeaurora.org> <20110325134248.GN2609@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110325134248.GN2609@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH 2/5 v6] usb: Add usb_endpoint_descriptor to be part of the struct usb_ep
Date: Sun, 27 Mar 2011 14:26:48 +0200
Message-ID: <000301cbec7a$3ff5cdf0$bfe169d0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acvq8oLwPfpOFH3xSgKpYNI8kidm6gBhtD1g
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Wed, Mar 23, 2011 at 10:03:38AM +0200, Tatyana Brokhman wrote:
> > Change usb_ep_enable() prototype to use endpoint descriptor from
> usb_ep.
> > This optimization spares the FDs from saving the endpoint chosen
> > descriptor. This optimization is not full though. To fully exploit
> this
> > change one needs to update all the UDCs as well since in the current
> > implementation each of them saves the endpoint descriptor in it's
> > internal (and extended) endpoint structure.
> 
> I'm not sure this is such a good patch. But I don't have strong
> arguments against it either.
> 

Could you please share you concerns? Even if they are not strong arguments
:).
Our pros for this change were that it seems more accurate that the EP
descriptor will be handled by the composite layer and not the FDs. Thus we
tried to spare the FD from saving the chosen EP descriptor and passing it to
different functions.
This change is needed for our algorithm of SS implementation in the later
patches in this series. 

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

