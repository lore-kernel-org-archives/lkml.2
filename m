Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2IZRmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:42:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58543 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2IZRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:42:13 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, akpm@linux-foundation.org,
        davem@davemloft.net, santosh.shilimkar@ti.com,
        grant.likely@secretlab.ca, balbi@ti.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        robherring2@gmail.com, richard.zhao@freescale.com,
        B29397@freescale.com, alexander.shishkin@linux.intel.com,
        mkl@pengutronix.de, marex@denx.de, p.paneri@samsung.com,
        devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] drivers: phy: add generic PHY framework
Date: Wed, 26 Sep 2012 10:41:58 -0700
Message-ID: <2573688.gCRJ0R3vnc@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.1 (Linux/3.5.4-1.fc17.x86_64; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1348678677.15175.18.camel@joe-AO722>
References: <1348671675-20830-1-git-send-email-kishon@ti.com> <1348678677.15175.18.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 26, 2012 09:57:57 AM Joe Perches wrote:
> On Wed, 2012-09-26 at 20:31 +0530, Kishon Vijay Abraham I wrote:
> > The PHY framework provides a set of API's for the PHY drivers to
> > create/destroy a PHY and API's
> 
> Just some trivial notes.
> 
> > diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> 
> []
> 
> > @@ -0,0 +1,445 @@
> 
> []
> 
> > +static void devm_phy_release(struct device *dev, void *res)
> > +{
> > +	struct phy *phy = *(struct phy **)res;
> 
> That's a bit twisted isn't it?
> Perhaps
> 	struct phy *phy = res;

No, because you really need to dereference ptr, not simply cast.

...

> > +
> > +	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
> 
> Is this the right size?
> 
> Because ptr is **, perhaps sizeof(struct phy) is clearer.

But incorrect.

Thanks.

-- 
Dmitry
