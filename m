Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0KXNQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:16:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45094 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0KXNQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:16:19 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Date: Wed, 24 Nov 2010 18:46:01 +0530
Subject: RE: [PATCH v4 2/5] da850-evm: add UI Expander pushbuttons
Thread-Topic: [PATCH v4 2/5] da850-evm: add UI Expander pushbuttons
Thread-Index: AcuLRmicZj/Rs3oATd++x+vWzxE2FgAkT9iA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024793194E@dbde02.ent.ti.com>
References: <cover.1290201713.git.bengardiner@nanometrics.ca>
 <cover.1290540916.git.bengardiner@nanometrics.ca>
 <9e73184bfb5c0a0d47377dd9b0627405dd87ce8a.1290540916.git.bengardiner@nanometrics.ca>
In-Reply-To: <9e73184bfb5c0a0d47377dd9b0627405dd87ce8a.1290540916.git.bengardiner@nanometrics.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

I have some minor comments on this patch. You could
wait for other pending items to get resolved before
posting a re-spin.

On Wed, Nov 24, 2010 at 01:10:57, Ben Gardiner wrote:

>  arch/arm/mach-davinci/board-da850-evm.c |   98 ++++++++++++++++++++++++++++++-
>  1 files changed, 97 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c

> +static struct gpio_keys_button da850_evm_ui_keys[] = {
> +     [0 ... DA850_N_UI_PB - 1] = {
> +             .type                   = EV_KEY,
> +             .active_low             = 1,
> +             .wakeup                 = 0,
> +             .debounce_interval      = DA850_KEYS_DEBOUNCE_MS,
> +             .code                   = -1, /* assigned at runtime */
> +             .gpio                   = -1, /* assigned at runtime */
> +             .desc                   = NULL, /* assigned at runtime */
> +     },
> +};
> +
> +static struct gpio_keys_platform_data da850_evm_ui_keys_pdata = {
> +     .buttons = da850_evm_ui_keys,
> +     .nbuttons = ARRAY_SIZE(da850_evm_ui_keys),
> +     .rep = 0, /* disable auto-repeat */
> +     .poll_interval = DA850_GPIO_KEYS_POLL_MS,
> +};
> +
> +static struct platform_device da850_evm_ui_keys_device = {
> +     .name = "gpio-keys",
> +     .id = 0,
> +     .dev = {
> +             .platform_data = &da850_evm_ui_keys_pdata
> +     },
> +};

No need of zero/NULL initialization in structures above
since they are static.

> @@ -304,15 +388,24 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
>       gpio_direction_output(sel_b, 1);
>       gpio_direction_output(sel_c, 1);
>
> +     da850_evm_ui_keys_init(gpio);
> +     ret = platform_device_register(&da850_evm_ui_keys_device);
> +     if (ret) {
> +             pr_warning("Could not register UI GPIO expander push-buttons"
> +                             " device\n");

Line-breaking an error message is not preferred since it becomes
difficult to grep in code. Looking at this message, you could drop
" device" altogether.

> +             goto exp_setup_keys_fail;
> +     }
> +
>       ui_card_detected = 1;
>       pr_info("DA850/OMAP-L138 EVM UI card detected\n");
>
>       da850_evm_setup_nor_nand();
> -

Random white space change?

Thanks,
Sekhar

