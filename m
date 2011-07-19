Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab1GSXxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:53:43 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:54739 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1GSXxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:53:41 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76383CF0DD2271@HQMAIL03.nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
	<1311115617-9697-3-git-send-email-achew@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF049EBDED2A@HQMAIL01.nvidia.com>
	<643E69AA4436674C8F39DCC2C05F76383CF0DD2271@HQMAIL03.nvidia.com>
Date: Tue, 19 Jul 2011 16:53:40 -0700
Message-ID: <CAOesGMj247ekXj1FPmb-ZXqxTV4PsmAiCme005TGKm7cnBdOPQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
From: Olof Johansson <olof@lixom.net>
To: Andrew Chew <AChew@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 4:50 PM, Andrew Chew <AChew@nvidia.com> wrote:
>> Although that said, since many of the USB properties are
>> board-specific
>> and determined by system characterization, they aren't generally
>> applicable to all Tegra devices. As such, should those values be moved
>> into tegra-seaboard.dts instead? Perhaps tegra20.dtsi should specify
>> the default values that the driver currently uses if not supplied with
>> platform data though... I think the Seaboard values are the defaults,
>> which still would make this patch obsolete.
>
> Turns out the ones I put in tegra20.dtsi are NOT the defaults.  The defaults are in arch/arm/mach-tegra/usb_phy.c, contained in "utmip_defaults[]".
>
> I think I'm going to put those utmip_defaults[] stuff into tegra20.dtsi, and override them in tegra-seaboard.dts.  How's that sound?

Sounds good to me, or if they for sure will need tuning on all boards
and there are no "safe" settings, leave them out from the generic
config alltogether.

> And since there are defaults specified in tegra20.dtsi, does it really make sense to also have default values assigned in ehci-tegra.c (for when a property is not present)?  I worry that the information is now duplicated.  If those properties aren't present, then someone's mucked with the tegra20.dtsi ehci properties.

Once all platforms are cut over to devicetree-only, that can be the
case. Until that happens, there will be need for settings in the C
code too. Is Nvidia switching to device trees for android/fastboot?


-Olof
