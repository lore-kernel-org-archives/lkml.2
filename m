Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2JVKRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:17:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2235 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2JVKRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:17:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 22 Oct 2012 03:17:07 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Oct 2012 15:47:02 +0530
Subject: RE: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2wPS2Xj/5i4e5ySBuXEwM24+gwbQAAJGvw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDFB0CE1E@BGMAIL02.nvidia.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
 <20121019153555.GC440@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CDCA@BGMAIL02.nvidia.com>
 <20121022100240.GK14033@arwen.pp.htv.fi>
In-Reply-To: <20121022100240.GK14033@arwen.pp.htv.fi>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Monday, October 22, 2012 3:33 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; stern@rowland.harvard.edu;
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
> 
> * PGP Signed by an unknown key
> 
> Hi,
> 
> On Mon, Oct 22, 2012 at 02:00:00PM +0530, Venu Byravarasu wrote:
> > > -----Original Message-----
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Friday, October 19, 2012 9:06 PM
> > > To: Venu Byravarasu
> > > Cc: stern@rowland.harvard.edu; gregkh@linuxfoundation.org;
> > > balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY
> driver
> > >
> > > > Old Signed by an unknown key
> > >
> > > Hi,
> > >
> > > On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
> > > > NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> > >
> > > I was reading this "driver" more closely and I have a bunch of questions
> > > about it, but the most important of all of them is: "why isn't that a
> > > real PHY driver ?". It doesn't have a probe() function, it doesn't use
> > > struct usb_phy to represent the PHY, it has a bunch of tegra-specific
> > > APIs and we can't let those continue.
> > >
> > > Please, take a look at drivers/usb/phy/omap_usb2.c (misnamed actually,
> > > should be phy-omap-usb2.c so we have a common prefix) to see how
> your
> > > PHY driver should look like and which sort of functionality if should
> > > expose to the rest of the kernel.
> >
> > Hi Felipe,
> >
> > I'll go through omap phy driver and prepare similar patches for tegra
> > phy driver and push them with upcoming patches.
> > As current patch is mostly re-organizing the existing phy driver, can
> > you plz merge This as is?
> 
> I would have to convince me about the need for that (and I'm open to be
> convinced ;-), because if a later series of patches will come getting
> rid of the current driver and turning it into a real PHY driver, I don't
> see the benefit of taking $SUBJECT.
> 

Hi Felipe,

The current patch splits out the existing tegra USB phy driver into two parts, as
you would have already noticed from the code.
The probe and etc changes that you asked to add, will be applicable to common
Phy driver and should not have any implications on SOC dependent phy driver.
Hence once this patch gets merged, it will be easier for me to modify SOC
agnostic common phy driver in the way you suggested.

Thanks,
Venu

> --
> balbi
> 
> * Unknown Key
> * 0x35CAA444
