Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2LXEcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 23:32:15 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9190 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LXEcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 23:32:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 23 Dec 2012 20:32:10 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Dec 2012 10:02:05 +0530
Subject: RE: [PATCH] usb: tegra: Removing dependency on PHY instance number
Thread-Topic: [PATCH] usb: tegra: Removing dependency on PHY instance number
Thread-Index: Ac3fvmSPSk2eSbGmRNSGhiP6zcsstgB0LzaQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1A40D477@BGMAIL02.nvidia.com>
References: <1356073105-13043-1-git-send-email-vbyravarasu@nvidia.com>
 <50D4CE2F.1090303@wwwdotorg.org>
In-Reply-To: <50D4CE2F.1090303@wwwdotorg.org>
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
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Saturday, December 22, 2012 2:32 AM
> To: Venu Byravarasu
> Cc: stern@rowland.harvard.edu; gregkh@linuxfoundation.org;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: tegra: Removing dependency on PHY instance
> number
> 
> On 12/20/2012 11:58 PM, Venu Byravarasu wrote:
> > Tegra2 has two varieties of USB PHYs:
> > Instance 0 - legacy PHY interface and
> > Instace 1 & 2 - non-legacy standard PHY interfaces.
> >
> > PHY driver is using instance numbers to identify the
> > interface type.
> >
> > With this patch Modified PHY driver to make use of
> > DT property for handling this.
> >
> > ULPI PHY is used on USB PHY instance 1 & UTMI is
> > used on other two instances. Hence modified PHY type
> > detection also from instance number to the parameter
> > passed from host driver.
> 
> Mostly seems fine to me; just a couple more things I noticed inline
> below. For the record, I'd like to take this through the Tegra tree with
> all the other Tegra-related USB patches in order to manage any
> dependencies, with the USB maintainers' Acks. Thanks.
> 
> > diff --git a/drivers/usb/phy/tegra_usb_phy.c
> b/drivers/usb/phy/tegra_usb_phy.c
> 
> > +struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev,
> > +	bool is_legacy_mode, void __iomem *regs, void *config,
> > +	enum tegra_usb_phy_mode phy_mode)
> 
> > +	u8 index = is_legacy_mode ? 0 : 2;
> 
> I know this looks slightly icky, but I discussed earlier with Venu that
> this will be replaced by reading all the parameters out of device tree,
> as soon as this code becomes a true driver. I think the patch for that
> is up next, or at most after a few more cleanup patches.

Thanks Stephen.
As we discussed already, I'll use DT params in upcoming patches.

> 
> > +	phy->is_ulpi_phy = config ? true : false;
> >
> >  	if (!phy->config) {
> > -		if (phy_is_ulpi(phy)) {
> > +		if (phy->is_ulpi_phy) {
> >  			pr_err("%s: ulpi phy configuration missing",
> __func__);
> >  			err = -EINVAL;
> >  			goto err0;
> 
> That check will never fire now, since phy->is_ulpi_phy is calculated
> based on whether phy->config is set. I think it's fine for now to rely
> on the EHCI driver correctly passing config or NULL, and hence you could
> simply delete some of this error-checking code. I imagine that when the
> PHY driver is reworked to be an actual device rather than a utility
> module, phy->is_ulpi_phy will be determined by the compatible value of
> the PHY node in device tree.
 
Correct, Stephen.
Will use DT param for determining the PHY type.
