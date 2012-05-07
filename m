Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2EGI7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:59:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab2EGI7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:59:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Date: Mon, 7 May 2012 08:59:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com> <20120507074228.GK26481@n2100.arm.linux.org.uk> <20120507.105254.1899925115243585929.hdoyu@nvidia.com>
In-Reply-To: <20120507.105254.1899925115243585929.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205070859.29174.arnd@arndb.de>
X-Provags-ID: V02:K0:FEX+JqKctCeChmi0Jti4w4Sl/a36KbEjs0bo+w9ZibX
 m+zf7H7FXgNVrr2oYJLQtBhhkwms9PGVMfVRcrVEJzjuas+LzJ
 6YnVtL9+Hy3R6KuqUF6aYKwjXgqGQWbt+afj33qRiOQaNo1/VG
 iEB602HY5CZnfe7RFyFHkUhj5521lZ0vJBpomXfP35ABAxX9Iq
 Raw5+IFZHrd3jXksMJe1fCQYhN/r/Sgfmaowm/9t3IcR0Rl2Wj
 eJmu88/U62JrNNbLQ6p/DdZFDo0FOQcbhqEkuxU9vGT0wLiBva
 sRzx1VFe84Ai93lO9TiW1VDTSS9PqhwUe9vbP1QwLYuNJtMOdp
 +ApxnPF1dPtvsfKz6tsQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012, Hiroshi Doyu wrote:
> > On Mon, May 07, 2012 at 09:43:45AM +0300, Hiroshi DOYU wrote:
> > > diff --git a/drivers/Makefile b/drivers/Makefile
> > > index 5870322..d97e2e2 100644
> > > --- a/drivers/Makefile
> > > +++ b/drivers/Makefile
> > > @@ -18,7 +18,7 @@ obj-$(CONFIG_SFI)         += sfi/
> > >  # PnP must come after ACPI since it will eventually need to check if acpi
> > >  # was used and do nothing if so
> > >  obj-$(CONFIG_PNP)          += pnp/
> > > -obj-$(CONFIG_ARM_AMBA)             += amba/
> > > +obj-$(CONFIG_ARM)          += amba/
> > 
> > NAK.  This makes amba only buildable for ARM which is not the intention.
> > Other architectures do have Primecells.
> 
> What about the following?
> 
>  +obj-y         += amba/

Looks ok to me, but which problem are you trying to solve anyway? Tegra
always enables ARM_AMBA, so AFAICT there is no difference between this
and the original code.

	Arnd
