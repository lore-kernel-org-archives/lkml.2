Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2LTItG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:49:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10370 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2LTIs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:48:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 20 Dec 2012 00:48:56 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Thu, 20 Dec 2012 14:18:49 +0530
Subject: RE: [PATCH] usb: phy: tegra: Using devm API for memory allocation
Thread-Topic: [PATCH] usb: phy: tegra: Using devm API for memory allocation
Thread-Index: Ac3eD50980kXLRJnRKWjoEfKgpWRIQAfqcUQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1A40D1C8@BGMAIL02.nvidia.com>
References: <1355811683-29981-1-git-send-email-vbyravarasu@nvidia.com>
 <50D09AC7.9050503@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6E19E0BFC4@BGMAIL02.nvidia.com>
 <50D1FB7B.4090002@wwwdotorg.org>
In-Reply-To: <50D1FB7B.4090002@wwwdotorg.org>
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
> Sent: Wednesday, December 19, 2012 11:08 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH] usb: phy: tegra: Using devm API for memory allocation
> 
> On 12/18/2012 10:38 PM, Venu Byravarasu wrote:
> >> -----Original Message-----
> >> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> >> Sent: Tuesday, December 18, 2012 10:03 PM
> >> To: Venu Byravarasu
> >> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-
> >> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> >> Subject: Re: [PATCH] usb: phy: tegra: Using devm API for memory
> allocation
> >>
> >
> > Stephen,
> > As you mentioned I can replace kmalloc with kzalloc in the original code
> > and push an updated patch.
> > However, I just wanted to understand if there exists any issue
> > in using devm_kzalloc instead of kzalloc?
> 
> devm_* are intended for objects allocated during probe(), and free()d
> during remove(). The object you're allocating here isn't that case.
> 
> Now, once you convert the Tegra PHY driver to be a true device, perhaps
> this object will be allocated/freed during probe/remove, so the devm_
> functions will be useful then?
> 
> The problem this may cause is a memory leak. Consider the Tegra EHCI and
> PHY drivers being built as modules, the PHY driver module being inserted
> and never removed, yet the EHCI driver being continually inserted and
> removed. Since the PHY is never removed, the memory allocated by its
> devm_kzalloc() call is never freed, but it's continually re-allocated
> since tegra_usb_phy_open() is called whenever the EHCI driver module is
> inserted. You need the explicit kfree() to avoid that, and since you're
> kfree()ing somewhere other than remove(), using devm_* to make the
> allocation isn't appropriate.
 
Thanks Stephen for the detailed explanation.
Sent updated patch for review: http://marc.info/?l=linux-usb&m=135599303216132&w=2 .

