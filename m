Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2IVIiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 04:38:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1121 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2IVIiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 04:38:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 22 Sep 2012 01:38:16 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Sat, 22 Sep 2012 14:08:11 +0530
Subject: RE: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2YFEVU4+FaZIcITGuH/Mao2aKRGwAiQy6A
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF6014CF@BGMAIL02.nvidia.com>
References: <1348230054-7402-1-git-send-email-vbyravarasu@nvidia.com>
 <CAAe_U6K2hANpRqzyoiiP2mR97=M2Mb35+FVor11DaaZi7W9Pnw@mail.gmail.com>
 <505C9282.3050001@wwwdotorg.org>
In-Reply-To: <505C9282.3050001@wwwdotorg.org>
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
> Sent: Friday, September 21, 2012 9:45 PM
> To: ABRAHAM, KISHON VIJAY
> Cc: Venu Byravarasu; balbi@ti.com; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
> 
> On 09/21/2012 07:09 AM, ABRAHAM, KISHON VIJAY wrote:
> > Hi,
> >
> > On Fri, Sep 21, 2012 at 5:50 PM, Venu Byravarasu
> <vbyravarasu@nvidia.com> wrote:
> >> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> >> In order to support USB PHY drivers on these SoCs, existing
> >> PHY driver is split into SoC agnostic common USB PHY driver
> >> and Tegra20-specific USB phy driver. This will facilitate
> >> easy addition and deletion of phy drivers for Tegra SoCs.
> 
> >> @@ -618,6 +618,9 @@ static int tegra_ehci_probe(struct platform_device
> *pdev)
> ...
> >>         pdata = pdev->dev.platform_data;
> >>         if (!pdata) {
> 
> Some missing lines of context are:
> 
>                 dev_err(&pdev->dev, "Platform data missing\n");
>                 return -EINVAL;
>         }
> 
> ...
> >> +       params.mode = TEGRA_USB_PHY_MODE_HOST;
> >> +       params.config = pdata->phy_config;
> >
> > I fail to understand how pdata is not NULL in dt boot. I know i've
> > already given this comment and you replied that you dint see any
> > crash. But I'd like to know where and how pdata gets populated.
> 
> In practice, the platform uses AUXDATA to provide platform data to the
> driver even when it's instantiated using device tree; see
> arch/arm/mach-tegra/board-dt-tegra20.c variables tegra_ehci*_pdata and
> tegra20_auxdata_lookup[].
> 
> In the slightly (very very slightly, hopefully) longer term, I would
> like to completely remove the AUXDATA setup from board-dt-tegra20.c;
> tegra_ehci_probe() should do something like:
> 
> pdata = pdev->dev.platform_data
> if (!pdata)
>     pdata = parse_pdata_from_dt();
> /* user didn't specify any in DT either */
> if (!pdata)
>     pdata = default_pdata_for_port();
> 
> ... where perhaps the use of defaults could be folded into
> parse_pdata_from_dt().
 

Thanks Stephen for the detailed explanation.

Kishon / Felipe,
Do you have any more questions in this related, before patch can be applied?
