Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2LMPyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:54:41 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:49552 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab2LMPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:54:35 -0500
Date: Thu, 13 Dec 2012 16:27:33 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] pinctrl/nomadik: Add Device Tree support
Message-ID: <20121213152733.GE23971@game.jcrosoft.org>
References: <1355405825-19400-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355405825-19400-1-git-send-email-linus.walleij@stericsson.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 17603163570299710236
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehjedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:37 Thu 13 Dec     , Linus Walleij wrote:
> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> 
> This implements pin multiplexing and pin configuration for the
> Nomadik pin controller using the device tree.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  .../devicetree/bindings/pinctrl/ste,nomadik.txt    | 111 +++++++++
>  drivers/pinctrl/pinctrl-nomadik.c                  | 250 +++++++++++++++++++++
>  2 files changed, 361 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> new file mode 100644
> index 0000000..02ff731
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> @@ -0,0 +1,111 @@
> +ST Ericsson Nomadik pinmux controller
> +
> +Required properties:
> +- compatible: "stericsson,nmk_pinctrl"
> +- reg: Should contain the register physical address and length of the PRCMU.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +ST Ericsson's pin configuration nodes act as a container for an abitrary number of
> +subnodes. Each of these subnodes represents some desired configuration for a
> +pin, a group, or a list of pins or groups. This configuration can include the
> +mux function to select on those pin(s)/group(s), and various pin configuration
> +parameters, such as inputn output, pull up, pull down...
> +
> +The name of each subnode is not important; all subnodes should be enumerated
> +and processed purely based on their content.
> +
> +Required subnode-properties:
> +- ste,pins : An array of strings. Each string contains the name of a pin or
> +    group.
> +
> +Optional subnode-properties:
> +- ste,function: A string containing the name of the function to mux to the
> +  pin or group.
> +
> +- ste,input:			no parameter, set pin in input with no pull mode.
> +- ste,input_pull_up:		no parameter, set pin in input with pull up mode.
> +- ste,input_pull_down:		no parameter, set pin in input with pull down mode.
> +
> +- ste,output:			integer, 0: output low, 1: output high, 2: output (value is not specified).
> +- ste,sleep_mode:		integer, 0: sleep mode disable, 1: sleep mode enable.
> +
> +- ste,sleep_input:		no parameter, set pin in sleep input with no pull mode.
> +- ste,sleep_input_pull_up:	no parameter, set pin in sleep input with pull up mode.
> +- ste,sleep_input_pull_down:	no parameter, set pin in sleep input with pull down mode.
> +
> +- ste,sleep_output:		integer, 0: sleep output low, 1: sleep output high, 2: sleep output (value is not specified).
> +
> +- ste,sleep_wakeup:		interger, 0: disable sleep wakeup mode, 1: enable sleep wake up mode.
> +- ste,sleep_gpio:		interger, 0: disable sleep gpio mode, 1: enable sleep gpio mode.
> +
> +- ste,sleep_pdis_mode:		integer, 0: pdis disabled, 1: pdis enable.
> +
> +
> +Valid values for pin and group name are in Drivers/pinctrl/pinctrl-nomadik-db8500.c
> +
> +Example board file extract:
> +
> +	pinctrl {
> +		compatible = "stericsson,nmk_pinctrl";
> +		reg = <0x80157000 0x2000>;
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&uart0_default_mode>;
???

those 2 are wired


> +
> +		uart0 {
> +			uart0_default_mux: uart0_mux {
> +				u0_default_mux {
> +					ste,function = "u0";
> +					ste,pins = "u0_a_1";
> +					};
> +			};
> +			uart0_default_mode: uart0_default {
> +				uart0_default_cfg1 {
> +					ste,pins = "GPIO0", "GPIO2";
> +					ste,input_pull_up;
> +				};
> +
> +				uart0_default_cfg2 {
> +					ste,pins = "GPIO1", "GPIO3";
> +					ste,output = <1>;
> +				};
> +			};
> +			uart0_sleep_mode: uart0_sleep {
> +				uart0_sleep_cfg1 {
> +					ste,pins = "GPIO0", "GPIO2";
> +					ste,sleep_mode = <0>;
> +					ste,sleep_input;
> +					ste,sleep_wakeup_mode = <1>;
> +					ste,sleep_pdis_mode = <0>;
> +				};
> +				uart0_sleep_cfg2 {
> +					ste,pins = "GPIO1";
> +					ste,sleep_mode = <0>;
> +					ste,sleep_output = <1>;
> +					ste,sleep_wakeup_mode = <1>;
> +					ste,sleep_pdis_mode = <0>;
> +				};
> +				uart0_sleep_cfg3 {
> +					ste,pins = "GPIO3";
> +					ste,sleep_mode = <0>;
> +					ste,sleep_output = <2>;
> +					ste,sleep_wakeup_mode = <1>;
> +					ste,sleep_pdis_mode = <0>;
> +				};

with such bindings you will endup with 1000s of node

take a loook on at91 how we did to avoid this
> +			};
> +		};
> +	};
> +
> +	uart@80120000 {
> +		compatible = "arm,pl011", "arm,primecell";
> +		reg = <0x80120000 0x1000>;
> +		interrupts = <0 11 0x4>;
> +
> +		pinctrl-names = "default","sleep";
> +		pinctrl-0 = <&uart0_default_mux>, <&uart0_default_mode>;
> +		pinctrl-1 = <&uart0_sleep_mode>;
> +	};
> +
> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
> index 1068faa..90b25ee 100644
> --- a/drivers/pinctrl/pinctrl-nomadik.c
> +++ b/drivers/pinctrl/pinctrl-nomadik.c
> @@ -25,6 +25,7 @@
>  #include <linux/irqdomain.h>
>  #include <linux/slab.h>
>  #include <linux/of_device.h>
> +#include <linux/pinctrl/machine.h>
>  #include <linux/pinctrl/pinctrl.h>
>  #include <linux/pinctrl/pinmux.h>
>  #include <linux/pinctrl/pinconf.h>
> @@ -1503,11 +1504,260 @@ static void nmk_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
>  	nmk_gpio_dbg_show_one(s, pctldev, chip, offset - chip->base, offset);
>  }
>  
> +static void nmk_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
> +		struct pinctrl_map *map, unsigned num_maps)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_maps; i++)
> +		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
> +			kfree(map[i].data.configs.configs);
> +	kfree(map);
> +}
> +
> +static int nmk_dt_reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
> +		unsigned *num_maps, unsigned reserve)
> +{
> +	unsigned old_num = *reserved_maps;
> +	unsigned new_num = *num_maps + reserve;
> +	struct pinctrl_map *new_map;
> +
> +	if (old_num >= new_num)
> +		return 0;
> +
> +	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
> +	if (!new_map)
> +		return -ENOMEM;
devm_
> +
> +	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
> +
> +	*map = new_map;
> +	*reserved_maps = new_num;
> +
> +	return 0;
> +}
> +

Best Regards,
J.
