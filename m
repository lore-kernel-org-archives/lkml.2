Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1EWHTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:19:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17855 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1EWHTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:19:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6354"; a="92934234"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org> <1306132882-9668-8-git-send-email-tlinder@codeaurora.org> <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Mon, 23 May 2011 10:20:45 +0300
Message-ID: <00a301cc1919$f0e1fa00$d2a5ee00$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZF9jZnAR9FtD2S4muAs3skPlj/QAARe9A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> >
> > diff --git a/drivers/usb/gadget/dummy_hcd.c
> > b/drivers/usb/gadget/dummy_hcd.c index bf7981d..c2731d3 100644
> > --- a/drivers/usb/gadget/dummy_hcd.c
> > +++ b/drivers/usb/gadget/dummy_hcd.c
> > @@ -70,6 +70,15 @@ MODULE_DESCRIPTION (DRIVER_DESC);  MODULE_AUTHOR
> > ("David Brownell");  MODULE_LICENSE ("GPL");
> >
> > +struct dummy_hcd_module_parameters {
> > +	bool is_super_speed;
> > +};
> > +
> > +static struct dummy_hcd_module_parameters mod_data = {
> > +	.is_super_speed = false
> > +};
> > +module_param_named(is_super_speed, mod_data.is_super_speed, bool,
> > +S_IRUGO); MODULE_PARM_DESC(is_super_speed, "true to simulate
> > +SuperSpeed connection");
> 
> you shouldn't need this. You should always enable SuperSpeed for this
> driver.

You mean I don't need the module parameter? IMO it's the best way to enable
HS connection. If driver->speed=USB_SPEED_SUPER than dummy_hcd will try to
enumerate the device on the SS root hub and if the gadget didn't provide SS
descriptors - it will fail. Just as it happened before. Finding out from
dummy_hcd that the enumeration failed is very complicated (if even possible)
and I'm not sure that is the right thing to do... If you connect a real
device over SS port to xHCI and the device doesn't provide SS descriptors -
the enumeration fails and it's ok. But if you connect the same device to a
HS port - it should work properly. This is what I tried to simulate with
this parameter.

Regarding the default value set to false, this of course can be changed. I
just thought that at the moment most of the existing gadget drivers don't
have SS descriptors so their default operation mode is HS.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




