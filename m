Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2GJId0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:33:26 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:52011 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753652Ab2GJIdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:33:22 -0400
Message-ID: <4FFBE8C8.9090908@ti.com>
Date: Tue, 10 Jul 2012 14:03:12 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Subject: Re: [PATCH v1 11/11] arm: omap: phy: remove unused functions from
 omap-phy-internal.c
References: <1340884267-28908-1-git-send-email-kishon@ti.com>	<1340884267-28908-12-git-send-email-kishon@ti.com>	<4FFBCBC0.5020603@ti.com> <CAAe_U6Ly3J90VMz5dP=p4wDauOf1v_K1JRB0Qp8nBYaQhcx==w@mail.gmail.com>
In-Reply-To: <CAAe_U6Ly3J90VMz5dP=p4wDauOf1v_K1JRB0Qp8nBYaQhcx==w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012 01:46 PM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>
> On Tue, Jul 10, 2012 at 11:59 AM, Rajendra Nayak<rnayak@ti.com>  wrote:
>> On Thursday 28 June 2012 05:21 PM, Kishon Vijay Abraham I wrote:
>>>
>>> All the unnessary functions in omap-phy-internal is removed.
>>> These functionality are now handled by omap-usb2 phy driver.
>>>
>>> Cc: Felipe Balbi<balbi@ti.com>
>>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>>> Acked-by: Tony Lindgren<tony@atomide.com>
>>> ---
>>>    arch/arm/mach-omap2/omap_phy_internal.c |  138
>>> -------------------------------
>>>    arch/arm/mach-omap2/twl-common.c        |    5 -
>>>    arch/arm/mach-omap2/usb-musb.c          |    3 -
>>>    3 files changed, 0 insertions(+), 146 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/omap_phy_internal.c
>>> b/arch/arm/mach-omap2/omap_phy_internal.c
>>> index 4c90477..0c610b4 100644
>>> --- a/arch/arm/mach-omap2/omap_phy_internal.c
>>> +++ b/arch/arm/mach-omap2/omap_phy_internal.c
>>> @@ -31,144 +31,6 @@
>>>    #include<plat/usb.h>
>>>    #include "control.h"
>>>
>>> -/* OMAP control module register for UTMI PHY */
>>> -#define CONTROL_DEV_CONF               0x300
>>> -#define PHY_PD                         0x1
>>> -
>>> -#define USBOTGHS_CONTROL               0x33c
>>> -#define        AVALID                          BIT(0)
>>> -#define        BVALID                          BIT(1)
>>> -#define        VBUSVALID                       BIT(2)
>>> -#define        SESSEND                         BIT(3)
>>> -#define        IDDIG                           BIT(4)
>>> -
>>> -static struct clk *phyclk, *clk48m, *clk32k;
>>> -static void __iomem *ctrl_base;
>>> -static int usbotghs_control;
>>> -
>>> -int omap4430_phy_init(struct device *dev)
>>> -{
>>> -       ctrl_base = ioremap(OMAP443X_SCM_BASE, SZ_1K);
>>> -       if (!ctrl_base) {
>>> -               pr_err("control module ioremap failed\n");
>>> -               return -ENOMEM;
>>> -       }
>>> -       /* Power down the phy */
>>> -       __raw_writel(PHY_PD, ctrl_base + CONTROL_DEV_CONF);
>>
>>
>> Just checking, but I hope your new driver handles this too.
>> You might not see any issues with it now, but not doing this could
>> gate OMAP hitting low power in idle.
>
> I power down the phy during probe in omap-usb2 phy driver.

ok, thanks, good to know.

>
> Thanks
> Kishon

