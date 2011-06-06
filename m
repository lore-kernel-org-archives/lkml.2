Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1FFLdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:33:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53756 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1FFLdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:33:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6368"; a="95816355"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org> <1306847914-19876-5-git-send-email-tlinder@codeaurora.org> <20110606111755.GV18731@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110606111755.GV18731@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v14 4/9] usb: Add max_speed to usb_composite_driver structure
Date: Mon, 6 Jun 2011 14:33:32 +0300
Message-ID: <00ef01cc243d$92c6d150$b85473f0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcwkO2czFsqHczilTTSMRxwAEtjSdgAANxgA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

> On Tue, May 31, 2011 at 04:18:24PM +0300, Tatyana Brokhman wrote:
> > This field is used by the Gadget drivers to specify the maximum speed
> > they support, meaning: the maximum speed they can provide descriptors
> for.
> >
> > The driver speed will be set in consideration of this value.
> >
> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> personally, I don't think this is good enough. The gadget speed is
> actually the min() of the f_* speeds. So, IMHO this should be coming
> from f_* and during bind you would:
> 
> gadget->speed = min(f->speed, gadget->speed);
> 
> for all functions. Also, both this patch and what I described above,
> only works considering nobody touches that enum, so we might want to be
> careful and add some comments to the enum to avoid anyone from touching
> that :-)

You're right, the full and best solution would be to set driver speed as the
minimum of all the speeds its functions support. (Please note that it's the
usb_composite_driver speed we're talking about and not the speed of the
gadget).
Unfortunately, we need to determine the driver speed before any of the
functions binded to it so the above solution isn't possible.
In any case, gadget->speed is determined upon real connection to the host
that can occur long after the f-> bind() and it depends on whether for
example SS HW negotiation protocol succeeded or failed.

Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.



 


