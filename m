Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1EWIRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:17:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56343 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1EWIRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:17:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6354"; a="92946212"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org> <1306132882-9668-8-git-send-email-tlinder@codeaurora.org> <20110523070556.GJ3095@legolas.emea.dhcp.ti.com> <00a301cc1919$f0e1fa00$d2a5ee00$@org> <20110523072142.GK3095@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110523072142.GK3095@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Mon, 23 May 2011 11:18:53 +0300
Message-ID: <00cc01cc1922$0fb4ee80$2f1ecb80$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZGgrswJMNSeObSamukAU4wW7JwwABtTNg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +
> > > > +static struct dummy_hcd_module_parameters mod_data = {
> > > > +	.is_super_speed = false
> > > > +};
> > > > +module_param_named(is_super_speed, mod_data.is_super_speed,
> bool,
> > > > +S_IRUGO); MODULE_PARM_DESC(is_super_speed, "true to simulate
> > > > +SuperSpeed connection");
> > >
> > > you shouldn't need this. You should always enable SuperSpeed for
> > > this driver.
> >
> > You mean I don't need the module parameter? IMO it's the best way to
> > enable HS connection. If driver->speed=USB_SPEED_SUPER than dummy_hcd
> > will try to enumerate the device on the SS root hub and if the gadget
> > didn't provide SS descriptors - it will fail. Just as it happened
> > before. Finding out from
> 
> then it should hand the device over to the hs_hcd ;-) Meaning it would
> disconnect the device, switch to hs_hcd and reconnect :-)

Yes this will be the best solution :) But as I said, the enumeration occurs
not in dummy_hcd thus I'm not sure how dummy_hcd can find out that it failed
in order to reconnect the device to hs_hcd. And I'm not sure that dummy_hcd
should care whether the enumeration succeeds or fails. It seems to me that
this should be handled by upper levels. Shouldn't it?
But we're discussing a more general issue; do you remember what the usb30
spec sais about this? I mean when connecting a HS device to a SS port (over
SS cable), should it still enumerate as a HS device? It seems to me that the
answer is no but I'm not sure...

> 
> > dummy_hcd that the enumeration failed is very complicated (if even
> > possible) and I'm not sure that is the right thing to do... If you
> > connect a real device over SS port to xHCI and the device doesn't
> > provide SS descriptors - the enumeration fails and it's ok. But if
> you
> > connect the same device to a HS port - it should work properly. This
> > is what I tried to simulate with this parameter.
> 
> it doesn't just fails, it gives the device over to the shared_hcd :-)
> 

Hmmm.... I have v2.6.38 installed on my Linux-host at the moment and I just
verified that when connecting a Gadget driver without SS descriptors over SS
connection - the enumeration fails. Was this fixed in v2.6.39? It will take
me some time to upgrade to v2.6.39  and verify but I have to do it any way
so I'll give it a shot...


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




