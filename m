Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab1GSXvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:51:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14545 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1GSXvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:51:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 19 Jul 2011 16:50:54 -0700
From: Andrew Chew <AChew@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jul 2011 16:50:53 -0700
Subject: RE: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
Thread-Topic: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
Thread-Index: AcxGZjkx5ggFPfwHSci0NC6oKmMXGAAAYWJQAAGgtVA=
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD2271@HQMAIL03.nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
 <1311115617-9697-3-git-send-email-achew@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDED2A@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDED2A@HQMAIL01.nvidia.com>
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

> Although that said, since many of the USB properties are 
> board-specific
> and determined by system characterization, they aren't generally
> applicable to all Tegra devices. As such, should those values be moved
> into tegra-seaboard.dts instead? Perhaps tegra20.dtsi should specify
> the default values that the driver currently uses if not supplied with
> platform data though... I think the Seaboard values are the defaults,
> which still would make this patch obsolete.

Turns out the ones I put in tegra20.dtsi are NOT the defaults.  The defaults are in arch/arm/mach-tegra/usb_phy.c, contained in "utmip_defaults[]".

I think I'm going to put those utmip_defaults[] stuff into tegra20.dtsi, and override them in tegra-seaboard.dts.  How's that sound?

And since there are defaults specified in tegra20.dtsi, does it really make sense to also have default values assigned in ehci-tegra.c (for when a property is not present)?  I worry that the information is now duplicated.  If those properties aren't present, then someone's mucked with the tegra20.dtsi ehci properties.