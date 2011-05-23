Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1EWOVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:21:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32951 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754107Ab1EWOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:21:17 -0400
Date: Mon, 23 May 2011 10:20:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Tanya Brokhman <tlinder@codeaurora.org>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <20110523072142.GK3095@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1105231018560.2020-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Felipe Balbi wrote:

> > > > +module_param_named(is_super_speed, mod_data.is_super_speed, bool,
> > > > +S_IRUGO); MODULE_PARM_DESC(is_super_speed, "true to simulate
> > > > +SuperSpeed connection");
> > > 
> > > you shouldn't need this. You should always enable SuperSpeed for this
> > > driver.
> > 
> > You mean I don't need the module parameter? IMO it's the best way to enable
> > HS connection. If driver->speed=USB_SPEED_SUPER than dummy_hcd will try to
> > enumerate the device on the SS root hub and if the gadget didn't provide SS
> > descriptors - it will fail. Just as it happened before. Finding out from
> 
> then it should hand the device over to the hs_hcd ;-) Meaning it would
> disconnect the device, switch to hs_hcd and reconnect :-)

No.  That doesn't happen with real devices, so there's no reason 
dummy-hcd should do it.

> > dummy_hcd that the enumeration failed is very complicated (if even possible)
> > and I'm not sure that is the right thing to do... If you connect a real
> > device over SS port to xHCI and the device doesn't provide SS descriptors -
> > the enumeration fails and it's ok. But if you connect the same device to a
> > HS port - it should work properly. This is what I tried to simulate with
> > this parameter.
> 
> it doesn't just fails, it gives the device over to the shared_hcd :-)

It does not.  xhci-hcd does not keep track of whether or not 
enumeration succeeds, and it doesn't do anything special when 
enumeration fails.

Alan Stern

