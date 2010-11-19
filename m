Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0KSLTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:19:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53349 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab0KSLTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:19:45 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Date: Fri, 19 Nov 2010 16:49:18 +0530
Subject: RE: [PATCH v2 3/4] da850-evm: extract defines for SEL{A, B,	C} pins
 in UI expander
Thread-Topic: [PATCH v2 3/4] da850-evm: extract defines for SEL{A, B,	C}
 pins in UI expander
Thread-Index: AcuFxjZ0LyPbXqW5T56Bls+tgjoTuwCE43uQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59302477EA9EE@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
 <aa85c5d83111add3a2ed3495ac13bffe5e6b885d.1289935504.git.bengardiner@nanometrics.ca>
In-Reply-To: <aa85c5d83111add3a2ed3495ac13bffe5e6b885d.1289935504.git.bengardiner@nanometrics.ca>
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

Hi Ben,

On Wed, Nov 17, 2010 at 01:09:36, Ben Gardiner wrote:
> The setup and teardown methods of the UI expander reference the SEL_{A,B,C}
> pins by 'magic number' in each function. This patch extracts common #defines
> for their offsets in the expander and uses them.
>
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> Reviewed-by: Chris Cordahi <christophercordahi@nanometrics.ca>
>
> ---
>
> No changes since v1
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |   27 +++++++++++++++------------
>  1 files changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index ff71ffd..dcf21e5 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -292,6 +292,9 @@ static const char const *ui_expander_names[] = {
>       "pb7", "pb6", "pb5", "pb4", "pb3", "pb2", "pb1"
>  };
>
> +#define DA850_SEL_A_OFFSET   7
> +#define DA850_SEL_B_OFFSET   6
> +#define DA850_SEL_C_OFFSET   5
>  #define DA850_UI_PB8_OFFSET  8
>  #define DA850_N_UI_PB                8

In this case, I think in this case indexed array initialization
will help keep the offsets and names matched. Here is an untested
patch on your patch, please consider using it.

Thanks,
Sekhar

---8<----
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index dcf21e5..508e5f2 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -287,16 +287,35 @@ static inline void da850_evm_setup_emac_rmii(int rmii_sel) { }
 /* No need to poll switches anywhere near as fast */
 #define DA850_SW_POLL_MS       700

-static const char const *ui_expander_names[] = {
-       "dgnd", "dgnd", "dgnd", "dgnd", "nc", "sel_c", "sel_b", "sel_a", "pb8",
-       "pb7", "pb6", "pb5", "pb4", "pb3", "pb2", "pb1"
-};
-
-#define DA850_SEL_A_OFFSET     7
-#define DA850_SEL_B_OFFSET     6
-#define DA850_SEL_C_OFFSET     5
-#define DA850_UI_PB8_OFFSET    8
-#define DA850_N_UI_PB          8
+static enum da850_evm_ui_exp_pins {
+       DA850_EVM_UI_EXP_SEL_C = 5,
+       DA850_EVM_UI_EXP_SEL_B,
+       DA850_EVM_UI_EXP_SEL_A,
+       DA850_EVM_UI_EXP_PB8,
+       DA850_EVM_UI_EXP_PB7,
+       DA850_EVM_UI_EXP_PB6,
+       DA850_EVM_UI_EXP_PB5,
+       DA850_EVM_UI_EXP_PB4,
+       DA850_EVM_UI_EXP_PB3,
+       DA850_EVM_UI_EXP_PB2,
+       DA850_EVM_UI_EXP_PB1,
+};
+
+static const char const *da850_evm_ui_exp[] = {
+       [DA850_EVM_UI_EXP_SEL_C]        = "sel_c",
+       [DA850_EVM_UI_EXP_SEL_B]        = "sel_b",
+       [DA850_EVM_UI_EXP_SEL_A]        = "sel_a",
+       [DA850_EVM_UI_EXP_PB8]          = "pb8",
+       [DA850_EVM_UI_EXP_PB7]          = "pb7",
+       [DA850_EVM_UI_EXP_PB6]          = "pb6",
+       [DA850_EVM_UI_EXP_PB5]          = "pb5",
+       [DA850_EVM_UI_EXP_PB4]          = "pb4",
+       [DA850_EVM_UI_EXP_PB3]          = "pb3",
+       [DA850_EVM_UI_EXP_PB2]          = "pb2",
+       [DA850_EVM_UI_EXP_PB1]          = "pb1",
+};
+
+#define DA850_N_UI_PB  8

 static struct gpio_keys_button user_ui_pbs_gpio_keys[DA850_N_UI_PB];

@@ -329,8 +348,8 @@ static void da850_ui_pushbuttons_init(unsigned gpio)
                button->wakeup = 0;
                button->debounce_interval = DA850_PB_DEBOUNCE_MS;
                button->desc = (char *)
-                               ui_expander_names[DA850_UI_PB8_OFFSET + i];
-               button->gpio = gpio + DA850_UI_PB8_OFFSET + i;
+                       da850_evm_ui_exp[DA850_EVM_UI_EXP_PB8 + i];
+               button->gpio = gpio + DA850_EVM_UI_EXP_PB8 + i;
        }
 }

@@ -339,23 +358,23 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 {
        int sel_a, sel_b, sel_c, ret;

-       sel_a = gpio + DA850_SEL_A_OFFSET;
-       sel_b = gpio + DA850_SEL_B_OFFSET;
-       sel_c = gpio + DA850_SEL_C_OFFSET;
+       sel_a = gpio + DA850_EVM_UI_EXP_SEL_A;
+       sel_b = gpio + DA850_EVM_UI_EXP_SEL_B;
+       sel_c = gpio + DA850_EVM_UI_EXP_SEL_C;

-       ret = gpio_request(sel_a, ui_expander_names[DA850_SEL_A_OFFSET]);
+       ret = gpio_request(sel_a, da850_evm_ui_exp[DA850_EVM_UI_EXP_SEL_A]);
        if (ret) {
                pr_warning("Cannot open UI expander pin %d\n", sel_a);
                goto exp_setup_sela_fail;
        }

-       ret = gpio_request(sel_b, ui_expander_names[DA850_SEL_B_OFFSET]);
+       ret = gpio_request(sel_b, da850_evm_ui_exp[DA850_EVM_UI_EXP_SEL_B]);
        if (ret) {
                pr_warning("Cannot open UI expander pin %d\n", sel_b);
                goto exp_setup_selb_fail;
        }

-       ret = gpio_request(sel_c, ui_expander_names[DA850_SEL_C_OFFSET]);
+       ret = gpio_request(sel_c, da850_evm_ui_exp[DA850_EVM_UI_EXP_SEL_B]);
        if (ret) {
                pr_warning("Cannot open UI expander pin %d\n", sel_c);
                goto exp_setup_selc_fail;
@@ -399,13 +418,13 @@ static int da850_evm_ui_expander_teardown(struct i2c_client *client,
        platform_device_unregister(&user_ui_pb_gpio_key_device);

        /* deselect all functionalities */
-       gpio_set_value(gpio + DA850_SEL_C_OFFSET, 1);
-       gpio_set_value(gpio + DA850_SEL_B_OFFSET, 1);
-       gpio_set_value(gpio + DA850_SEL_A_OFFSET, 1);
+       gpio_set_value(gpio + DA850_EVM_UI_EXP_SEL_C, 1);
+       gpio_set_value(gpio + DA850_EVM_UI_EXP_SEL_B, 1);
+       gpio_set_value(gpio + DA850_EVM_UI_EXP_SEL_A, 1);

-       gpio_free(gpio + DA850_SEL_C_OFFSET);
-       gpio_free(gpio + DA850_SEL_B_OFFSET);
-       gpio_free(gpio + DA850_SEL_A_OFFSET);
+       gpio_free(gpio + DA850_EVM_UI_EXP_SEL_C);
+       gpio_free(gpio + DA850_EVM_UI_EXP_SEL_B);
+       gpio_free(gpio + DA850_EVM_UI_EXP_SEL_A);

        return 0;
 }
@@ -414,7 +433,7 @@ static struct pca953x_platform_data da850_evm_ui_expander_info = {
        .gpio_base      = DAVINCI_N_GPIO,
        .setup          = da850_evm_ui_expander_setup,
        .teardown       = da850_evm_ui_expander_teardown,
-       .names          = ui_expander_names,
+       .names          = da850_evm_ui_exp,
 };

 static struct i2c_board_info __initdata da850_evm_i2c_devices[] = {
