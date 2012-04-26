Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2DZOfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:35:14 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:12517
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184Ab2DZOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:35:12 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz1102I154dM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 26 Apr 2012 22:44:52 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <b20223@freescale.com>,
        <linus.walleij@stericsson.com>, <devicetree-discuss@lists.ozlabs.org>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@pengutronix.de>, <cjb@laptop.org>, <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120426144451.GC26070@shlinux2.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1335451227-27709-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:40:25PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The driver has mux and config support while the gpio is still
> not supported.
> For select input setting, the driver will handle it internally
> and do not need user to take care of it.
> 
> The pinctrl-imx core driver will parse the dts file and dynamically
> create the pinmux functions and groups.
> 
> Each IMX SoC pinctrl driver should register pins with a pin register map
> including mux register and config register and select input map to core
> for proper operations.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> ---
> ChangeLog: v2->v3:
> * add missed SION bit set from device tree
>   Thanks for Richard Zhao's reminder.
> ChangeLog: v1->v2:
> * Change the binding a bit.
>   For fsl,pins property, change it from pin name strings to pin function id
>   which represents a pin working on a specific function. Then we can remove
>   fsl,mux property since the pin function id already contains the mux setting.
>   Also remove other pin config property in the first patch.
>   Because in the future, we will switch to use dtc macro, then using a lot of
>   propertys to represent the each pin config like pull, speed and etc seems
>   needless.
>   Then each pin entry in dts file becomes a pair of PIN_FUNC_ID and CONFIG:
>   fsl,pins = <PIN_FUNC_ID CONFIG ..>
>   See binding doc for details.
> * Sascha raised a question that pins in the same group may have different
>   pad setting for example I2C_CLK needs pull up while I2C_DAT not.
>   The v1 driver can aslo handle this issue but needs split the different
>   pad setting pins into different groups which loses a bit flexibility.
>   Also suggested by Richard Zhao and Jason Liu, we may still want the iomux
>   v3 simililar using way that allows each pin has the abiblity to configure
>   its pad which seems reasonable because from HW point of view, FSL IMX are
>   indeed pin based SoC which should be able to set per pin.
>   So the main changes in this v2 patch are change to support per pin config.
>   Then the using of iomux is almost the same as the existing iomux v3 for
>   non dt imx platforms. See binding doc for example.
> 
>   After introduce the new way, there're mainly two known issues:
>   1) Since many pins in the same group may have the same pad config setting,
>      thus there may be some data redundance, however, since it's one word
>      and it's purely describe hw i would think it's not a big issue.
>   2) Need a magic number to indicate no pad config need. In current iomux v3,
>      It's 1<<16 which is not used by IMX5, i used 1<<31 for both MX5 and MX6.
>      However, it's definitely possibile that in the future, the bit 31 may also
>      be used, that means we may need change the binding doc or just handle it in
>      driver for different SoCs.
>   3) Due to core limitation, the current pinconf_group_set/get only support
>      get/set the same config(a u32 value)for all the pins in the same group,
>      so i removed the imx_group_set/get functions support, instead, using
>      imx_pin_get/set.
>      About this limitation, we may need some futher discussion on if we may
>      need to enhance it to be more flexible to support configure different
>      pins in the same group.
> * Refactor probe handling based on Stephen's suggestion.
> * Enhanced the binding doc and split it into two part, pinctrl-imx common part
>   and pinctrl-soc driver part.
> * Change functions name from imx_pmx_* to imx_pinctrl_*.
> * Other fixes based on Sascha, Stephen, Linus, Shawn's comments.
> ---
Hi Shawn & Sascha,

Please help review if this can meet your requirement.

Regards
Dong Aisheg

