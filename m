Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1GTAHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:07:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11623 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1GTAHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:07:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 19 Jul 2011 17:07:24 -0700
From: Andrew Chew <AChew@nvidia.com>
To: "'Olof Johansson'" <olof@lixom.net>
CC: Stephen Warren <swarren@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jul 2011 17:07:25 -0700
Subject: RE: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
Thread-Topic: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
Thread-Index: AcxGbxg3/+okLWEKQOOQrD/GYnCZLwAAXNAA
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD2272@HQMAIL03.nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
	<1311115617-9697-3-git-send-email-achew@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF049EBDED2A@HQMAIL01.nvidia.com>
	<643E69AA4436674C8F39DCC2C05F76383CF0DD2271@HQMAIL03.nvidia.com>
 <CAOesGMj247ekXj1FPmb-ZXqxTV4PsmAiCme005TGKm7cnBdOPQ@mail.gmail.com>
In-Reply-To: <CAOesGMj247ekXj1FPmb-ZXqxTV4PsmAiCme005TGKm7cnBdOPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And since there are defaults specified in tegra20.dtsi, 
> does it really make sense to also have default values 
> assigned in ehci-tegra.c (for when a property is not 
> present)?  I worry that the information is now duplicated.  
> If those properties aren't present, then someone's mucked 
> with the tegra20.dtsi ehci properties.
> 
> Once all platforms are cut over to devicetree-only, that can be the
> case. Until that happens, there will be need for settings in the C
> code too. Is Nvidia switching to device trees for android/fastboot?

I'm not talking about the defaults in arch/arm/mach-tegra/usb_phy.c.  I understand that once we cut over to devicetree-only, the defaults there can go away.

The question is, if a property is not present, what should we do?  The default value for that property SHOULD be present somewhere in the dts chain.  But if it's not, should we error out, spit out a warning, or spit out a warning and assign a default?  If it's the latter case, then we now have a set of defaults in dts, as well as C code, regardless of whether we've switched over to devicetree-only or not.