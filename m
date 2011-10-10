Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1JJWNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:13:43 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:39069 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1JJWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:13:42 -0400
Date: Mon, 10 Oct 2011 16:13:41 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <alpine.DEB.2.00.1110101509580.5205@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1110101604320.5205@utopia.booyaka.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com> <CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com> <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
 <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com> <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com> <20111010090330.GE6685@legolas.emea.dhcp.ti.com> <alpine.DEB.2.00.1110101509580.5205@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, 10 Oct 2011, Paul Walmsley wrote:

> So then you'd just create a TLL driver with something like these two 
> symbols exported:
> 
> omap_usbhost_tll_enable_port();
> omap_usbhost_tll_disable_port(); 

N.B., since I don't think Linux has any formal support to map USB ports to 
TLL ports, you'll probably need to create a couple of functions in your 
drivers/mfd/omap-usb-host.c that your EHCI/OHCI drivers could call during 
init/exit to get and put the TLL struct device, to pass to those above 
functions.  Since the MFD driver is what creates the TLL struct devices, 
the MFD driver will have the TLL struct device pointers.  Something like 
omap_usbhost_get_tll_device() and omap_usbhost_put_tll_device().

One other thing.  Not sure what the correct generic name prefix for these 
functions should be, since I don't know the provenance of the USBHOST IP 
block; but maybe the function prefix should be something like 'ti_usbhost' 
instead, to indicate that it isn't OMAP-specific?  You would know better 
than I.


- Paul
