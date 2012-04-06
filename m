Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2DFD0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 23:26:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7415 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2DFD0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 23:26:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Apr 2012 20:26:37 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Apr 2012 08:56:33 +0530
Subject: RE: [PATCH] usb: host: tegra: re-arranging ehci functions
Thread-Topic: [PATCH] usb: host: tegra: re-arranging ehci functions
Thread-Index: Ac0TNU6M8oZlHXi/ScycPQa1bWSiOwAb35uw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3E26DB5@BGMAIL02.nvidia.com>
References: <1333605536-5792-1-git-send-email-vbyravarasu@nvidia.com>
 <Pine.LNX.4.44L0.1204051004350.1361-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1204051004350.1361-100000@iolanthe.rowland.org>
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

> >  	.flags			= HCD_USB2 | HCD_MEMORY,
> >
> > -	.reset			= tegra_ehci_setup,
> > -	.irq			= ehci_irq,

> > -
> > +
> > +	/* modified ehci functions for tegra */
> > +	.reset			= tegra_ehci_setup,
> > +	.irq			= tegra_ehci_irq,
> 
> What happened here?  This patch is supposed to rearrange the entries,
> not change them.
Thanks Alan, for catching my mistake.
Will fix it and push a new patch.

> > +	.hub_control		= tegra_ehci_hub_control,
> > +	.urb_enqueue		= tegra_ehci_urb_enqueue,
> 
> Same here.
Will fix and push the patch.

> >  #ifdef CONFIG_PM
> >  	.bus_suspend		= tegra_ehci_bus_suspend,
> >  	.bus_resume		= tegra_ehci_bus_resume,
> >  #endif
> > -	.relinquish_port	= ehci_relinquish_port,
> > -	.port_handed_over	= ehci_port_handed_over,
> >  };
> 
> Alan Stern
Thanks,
Venu
