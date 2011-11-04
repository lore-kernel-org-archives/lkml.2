Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1KDU2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:28:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60446 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1KDU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:28:45 -0400
Date: Fri, 4 Nov 2011 13:29:05 -0700
From: Olof Johansson <olof@lixom.net>
To: Rajendra Nayak <rnayak@ti.com>
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111104202905.GA3918@quad.lixom.net>
References: <1319721864-30067-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319721864-30067-1-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 06:54:24PM +0530, Rajendra Nayak wrote:
> The helper routine is meant to be used by the regulator drivers
> to extract the regulator_init_data structure from the data
> that is passed from device tree.
> 'consumer_supplies' which is part of regulator_init_data is not extracted
> as the regulator consumer mappings are passed through DT differently,
> implemented in subsequent patches.
> Similarly the regulator<-->parent/supply mapping is handled in
> subsequent patches.
> 
> Also add documentation for regulator bindings to be used to pass
> regulator_init_data struct information from device tree.
> 
> Some of the regulator properties which are linux and board specific,
> are left out since its not clear if they can
> be in someway embedded into the kernel or passed in from DT.
> They will be revisited later.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  .../devicetree/bindings/regulator/regulator.txt    |   33 ++++++++
>  drivers/regulator/Kconfig                          |    7 ++
>  drivers/regulator/Makefile                         |    1 +
>  drivers/regulator/of_regulator.c                   |   81 ++++++++++++++++++++
>  include/linux/regulator/of_regulator.h             |   20 +++++
>  5 files changed, 142 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/regulator.txt
>  create mode 100644 drivers/regulator/of_regulator.c
>  create mode 100644 include/linux/regulator/of_regulator.h
> 
> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
> new file mode 100644
> index 0000000..c488bf3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
> @@ -0,0 +1,33 @@
> +Voltage/Current Regulators
> +

There should be a mandatory compatible field here, right? I.e. a topmost
generic one, "regulator" or similar.

> +Optional properties:
> +- regulator-name: A string used as a descriptive name for regulator outputs

Ah, there it is. Ignore my previous comment then, Mark. :)

> +- regulator-min-uV: smallest voltage consumers may set
> +- regulator-max-uV: largest voltage consumers may set
> +- regulator-uV-offset: Offset applied to voltages to compensate for voltage drops
> +- regulator-min-uA: smallest current consumers may set
> +- regulator-max-uA: largest current consumers may set
> +- regulator-always-on: boolean, regulator should never be disabled
> +- regulator-boot-on: bootloader/firmware enabled regulator

Once you have a compatible field that can determine what kind of device node,
and binding, this is, you can drop the regulator- prefix and save some space in
the device tree. Properties are rarely prefixed by their subsystem. Only
exception would/could be the regulator-name property where it could make
sense to keep the prefix.

Also, lower-caps is common instead of V and A.

> +- <name>-supply: phandle to the parent supply/regulator node

Having a fixed name here instead of a free form string would probably be a good
idea?



-Olof
