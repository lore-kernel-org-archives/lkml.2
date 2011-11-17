Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1KQKUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:20:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36640 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab1KQKUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:20:24 -0500
MIME-Version: 1.0
In-Reply-To: <1321519821-25022-1-git-send-email-linus.walleij@stericsson.com>
References: <1321519821-25022-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 17 Nov 2011 15:50:23 +0530
Message-ID: <CAJuYYwSHoMFWkuL4+aEzOBt0XUaQwTUzob+cowvigPvYTRXS5Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: misc documentation fixups
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 17 November 2011 14:20, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This fixes up some various confusions in the pinctrl
> documentation.

There are few other minor fixes in the documentation, if possible can
these also be included in this patch.

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index be5cab3..80e531e 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -32,7 +32,7 @@ Definition of PIN:
   be sparse - i.e. there may be gaps in the space with numbers where no
   pin exists.

-When a PIN CONTROLLER is instatiated, it will register a descriptor to the
+When a PIN CONTROLLER is instantiated, it will register a descriptor to the
 pin control framework, and this descriptor contains an array of pin descriptors
 describing the pins handled by this specific pin controller.

@@ -254,7 +254,7 @@ chip b:
  - pin range  : [64 .. 71]

 When GPIO-specific functions in the pin control subsystem are called, these
-ranges will be used to look up the apropriate pin controller by inspecting
+ranges will be used to look up the appropriate pin controller by inspecting
 and matching the pin to the pin ranges across all controllers. When a
 pin controller handling the matching range is found, GPIO-specific functions
 will be called on that specific pin controller.
@@ -434,7 +434,7 @@ you. Define enumerators only for the pins you can
control if that makes sense.

 Assumptions:

-We assume that the number possible function maps to pin groups is limited by
+We assume that the number of possible function maps to pin groups is limited by
 the hardware. I.e. we assume that there is no system where any function can be
 mapped to any pin, like in a phone exchange. So the available pins groups for
 a certain function will be limited to a few choices (say up to eight or so),
@@ -581,7 +581,7 @@ int foo_list_funcs(struct pinctrl_dev *pctldev,
unsigned selector)

 const char *foo_get_fname(struct pinctrl_dev *pctldev, unsigned selector)
 {
-	return myfuncs[selector].name;
+	return foo_functions[selector].name;
 }

 static int foo_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
@@ -602,13 +602,12 @@ int foo_enable(struct pinctrl_dev *pctldev,
unsigned selector,
 	return 0;
 }

-int foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
+void foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
 		unsigned group)
 {
 	u8 regbit = (1 << group);

 	writeb((readb(MUX) & ~(regbit)), MUX)
-	return 0;
 }

 struct pinmux_ops foo_pmxops = {
---

>
> Reported-by: Rajendra Nayak <rnayak@ti.com>
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt |   30 +++++++++++++++---------------
>  1 files changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index ea50804..348a59d 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -59,13 +59,13 @@ this in our driver:
>  #include <linux/pinctrl/pinctrl.h>
>
>  const struct pinctrl_pin_desc foo_pins[] = {
> -      PINCTRL_PIN(0, "A1"),
> -      PINCTRL_PIN(1, "A2"),
> -      PINCTRL_PIN(2, "A3"),
> +      PINCTRL_PIN(0, "A8"),
> +      PINCTRL_PIN(1, "B8"),
> +      PINCTRL_PIN(2, "C8"),
>       ...
> -      PINCTRL_PIN(61, "H6"),
> -      PINCTRL_PIN(62, "H7"),
> -      PINCTRL_PIN(63, "H8"),
> +      PINCTRL_PIN(61, "F1"),
> +      PINCTRL_PIN(62, "G1"),
> +      PINCTRL_PIN(63, "H1"),
>  };
>
>  static struct pinctrl_desc foo_desc = {
> @@ -90,11 +90,11 @@ selected drivers, you need to select them from your machine's Kconfig entry,
>  since these are so tightly integrated with the machines they are used on.
>  See for example arch/arm/mach-u300/Kconfig for an example.
>
> -Pins usually have fancier names than this. You can find these in the dataheet
> +Pins usually have fancier names than this. You can find these in the datasheet
>  for your chip. Notice that the core pinctrl.h file provides a fancy macro
>  called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
> -the pins from 0 in the upper left corner to 63 in the lower right corner,
> -this enumeration was arbitrarily chosen, in practice you need to think
> +the pins from 0 in the upper left corner to 63 in the lower right corner.
> +This enumeration was arbitrarily chosen, in practice you need to think
>  through your numbering system so that it matches the layout of registers
>  and such things in your driver, or the code may become complicated. You must
>  also consider matching of offsets to the GPIO ranges that may be handled by
> @@ -842,42 +842,42 @@ case), we define a mapping like this:
>        .name "2bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_0_grp",
> +       .group = "mmc0_1_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "4bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_0_grp",
> +       .group = "mmc0_1_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "4bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_1_grp",
> +       .group = "mmc0_2_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "8bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_0_grp",
> +       .group = "mmc0_1_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "8bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_1_grp",
> +       .group = "mmc0_2_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "8bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_2_grp",
> +       .group = "mmc0_3_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  ...
> --
> 1.7.3.2
>
>
