Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1GTTvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:51:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1347 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1GTTvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:51:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Jul 2011 12:51:09 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Andrew Chew <AChew@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Chew <AChew@nvidia.com>
Date: Wed, 20 Jul 2011 12:51:08 -0700
Subject: RE: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Index: AcxHFQhXD+pPdG2NRAaHk0KHbUzMLQAAM9gQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF4E@HQMAIL01.nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1311190690-18334-1-git-send-email-achew@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

achew@nvidia.com wrote at Wednesday, July 20, 2011 1:38 PM:
> From: Andrew Chew <achew@nvidia.com>
> 
> Add code to try to get platform data information (register base, irq,
> modes, various tuning parameters) from device tree, if not present in board
> files.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>

> +++ b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
...
> +Required properties for type = "ulpi":
> + - reset_gpio: The GPIO used to drive reset
> + - clk

We should probably document what this is. I know you're finding out more
about this internally.

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> +	retval = of_property_read_u32(dn, "power_down_on_bus_suspend",
> +				      &pdata->power_down_on_bus_suspend);

Sorry I missed this before, but perhaps we should skip reading that
property unless mode=="host"?

Otherwise,
Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

