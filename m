Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1LILC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:02:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57341 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1LILCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:02:54 -0500
MIME-Version: 1.0
In-Reply-To: <1323383765-30742-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <74CDBE0F657A3D45AFBB94109FB122FF1750B77B9F@HQMAIL01.nvidia.com>
	<1323383765-30742-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Fri, 9 Dec 2011 12:02:54 +0100
Message-ID: <CACRpkdbAXmWkzzhBFndbivY4-FhJRpXh49XQ3--wPeO=X1Zafg@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation/pinctrl: various minor fixes
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Stephen Warren <swarren@nvidia.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:

> - add some consts
> - don't use the group index alone to determine the value to write to
>  foo's mux register. For spi and i2c the group index is always 0.
>  Additionally using the function index makes much more sense as it
>  generates a different value for each function/group pair.
> - fix a few syntax errors
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Some of these were fixed in earlier documentation patches in
my tree, so I took out the pieces that were missing and squashed
into that patch. The result now looks like this:

commit 478781254aea577029c7872bab5578e98ef0cbad
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Thu Nov 10 09:27:41 2011 +0100

    pinctrl: documentation update

    Update the docs removing an obsolete __refdata tag and document
    the mysterious return value of pin_free(). And fixes up some various
    confusions in the pinctrl documentation.

    Reported-by: Rajendra Nayak <rnayak@ti.com>
    Reported-by: Randy Dunlap <rdunlap@xenotime.net>
    Reported-by: Thomas Abraham <thomas.abraham@linaro.org>
    Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Acked-by: Stephen Warren <swarren@nvidia.com>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index b04cb7d..0a8b225 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -32,7 +32,7 @@ Definition of PIN:
   be sparse - i.e. there may be gaps in the space with numbers where no
   pin exists.

-When a PIN CONTROLLER is instatiated, it will register a descriptor to the
+When a PIN CONTROLLER is instantiated, it will register a descriptor to the
 pin control framework, and this descriptor contains an array of pin descriptors
 describing the pins handled by this specific pin controller.

@@ -61,14 +61,14 @@ this in our driver:

 #include <linux/pinctrl/pinctrl.h>

-const struct pinctrl_pin_desc __refdata foo_pins[] = {
-      PINCTRL_PIN(0, "A1"),
-      PINCTRL_PIN(1, "A2"),
-      PINCTRL_PIN(2, "A3"),
+const struct pinctrl_pin_desc foo_pins[] = {
+      PINCTRL_PIN(0, "A8"),
+      PINCTRL_PIN(1, "B8"),
+      PINCTRL_PIN(2, "C8"),
       ...
-      PINCTRL_PIN(61, "H6"),
-      PINCTRL_PIN(62, "H7"),
-      PINCTRL_PIN(63, "H8"),
+      PINCTRL_PIN(61, "F1"),
+      PINCTRL_PIN(62, "G1"),
+      PINCTRL_PIN(63, "H1"),
 };

 static struct pinctrl_desc foo_desc = {
@@ -91,8 +91,8 @@ int __init foo_probe(void)
 Pins usually have fancier names than this. You can find these in the dataheet
 for your chip. Notice that the core pinctrl.h file provides a fancy macro
 called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
-the pins from 0 in the upper left corner to 63 in the lower right corner,
-this enumeration was arbitrarily chosen, in practice you need to think
+the pins from 0 in the upper left corner to 63 in the lower right corner.
+This enumeration was arbitrarily chosen, in practice you need to think
 through your numbering system so that it matches the layout of registers
 and such things in your driver, or the code may become complicated. You must
 also consider matching of offsets to the GPIO ranges that may be handled by
@@ -133,8 +133,8 @@ struct foo_group {
        const unsigned num_pins;
 };

-static unsigned int spi0_pins[] = { 0, 8, 16, 24 };
-static unsigned int i2c0_pins[] = { 24, 25 };
+static const unsigned int spi0_pins[] = { 0, 8, 16, 24 };
+static const unsigned int i2c0_pins[] = { 24, 25 };

 static const struct foo_group foo_groups[] = {
        {
@@ -242,7 +242,7 @@ chip a: [32 .. 47]
 chip b: [48 .. 55]

 When GPIO-specific functions in the pin control subsystem are called, these
-ranges will be used to look up the apropriate pin controller by inspecting
+ranges will be used to look up the appropriate pin controller by inspecting
 and matching the pin to the pin ranges across all controllers. When a
 pin controller handling the matching range is found, GPIO-specific functions
 will be called on that specific pin controller.
@@ -438,7 +438,7 @@ you. Define enumerators only for the pins you can
control if that makes sense.

 Assumptions:

-We assume that the number possible function maps to pin groups is limited by
+We assume that the number of possible function maps to pin groups is limited by
 the hardware. I.e. we assume that there is no system where any function can be
 mapped to any pin, like in a phone exchange. So the available pins groups for
 a certain function will be limited to a few choices (say up to eight or so),
@@ -585,7 +585,7 @@ int foo_list_funcs(struct pinctrl_dev *pctldev,
unsigned selector)

 const char *foo_get_fname(struct pinctrl_dev *pctldev, unsigned selector)
 {
-       return myfuncs[selector].name;
+       return foo_functions[selector].name;
 }

 static int foo_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
@@ -600,16 +600,16 @@ static int foo_get_groups(struct pinctrl_dev
*pctldev, unsigned selector,
 int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
                unsigned group)
 {
-       u8 regbit = (1 << group);
+       u8 regbit = (1 << selector + group);

        writeb((readb(MUX)|regbit), MUX)
        return 0;
 }

-int foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
+void foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
                unsigned group)
 {
-       u8 regbit = (1 << group);
+       u8 regbit = (1 << selector + group);

        writeb((readb(MUX) & ~(regbit)), MUX)
        return 0;
@@ -683,7 +683,7 @@ spi on the second function mapping:

 #include <linux/pinctrl/machine.h>

-static struct pinmux_map pmx_mapping[] = {
+static const struct pinmux_map pmx_mapping[] = {
        {
                .ctrl_dev_name = "pinctrl.0",
                .function = "spi0",
@@ -714,7 +714,7 @@ for example if they are not yet instantiated or
cumbersome to obtain.

 You register this pinmux mapping to the pinmux subsystem by simply:

-       ret = pinmux_register_mappings(&pmx_mapping, ARRAY_SIZE(pmx_mapping));
+       ret = pinmux_register_mappings(pmx_mapping, ARRAY_SIZE(pmx_mapping));

 Since the above construct is pretty common there is a helper macro to make
 it even more compact which assumes you want to use pinctrl.0 and position
@@ -762,42 +762,42 @@ case), we define a mapping like this:
        .name "2bit"
        .ctrl_dev_name = "pinctrl.0",
        .function = "mmc0",
-       .group = "mmc0_0_grp",
+       .group = "mmc0_1_grp",
        .dev_name = "foo-mmc.0",
 },
 {
        .name "4bit"
        .ctrl_dev_name = "pinctrl.0",
        .function = "mmc0",
-       .group = "mmc0_0_grp",
+       .group = "mmc0_1_grp",
        .dev_name = "foo-mmc.0",
 },
 {
        .name "4bit"
        .ctrl_dev_name = "pinctrl.0",
        .function = "mmc0",
-       .group = "mmc0_1_grp",
+       .group = "mmc0_2_grp",
        .dev_name = "foo-mmc.0",
 },
 {
        .name "8bit"
        .ctrl_dev_name = "pinctrl.0",
        .function = "mmc0",
-       .group = "mmc0_0_grp",
+       .group = "mmc0_1_grp",
        .dev_name = "foo-mmc.0",
 },
 {
        .name "8bit"
        .ctrl_dev_name = "pinctrl.0",
        .function = "mmc0",
-       .group = "mmc0_1_grp",
+       .group = "mmc0_2_grp",
        .dev_name = "foo-mmc.0",
 },
 {
        .name "8bit"
        .ctrl_dev_name = "pinctrl.0",
        .function = "mmc0",
-       .group = "mmc0_2_grp",
+       .group = "mmc0_3_grp",
        .dev_name = "foo-mmc.0",
 },
 ...
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index c77aee5..0923824 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -174,6 +174,10 @@ out:
  * @pin: the pin to free
  * @gpio_range: the range matching the GPIO pin if this is a request for a
  *     single GPIO pin
+ *
+ * This function returns a pointer to the function name in use. This is used
+ * for callers that dynamically allocate a function name so it can be freed
+ * once the pin is free. This is done for GPIO request functions.
  */
 static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
                            struct pinctrl_gpio_range *gpio_range)


Hope this looks OK for you Uwe.

Thanks,
Linus Walleij
