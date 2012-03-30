Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab2CaAfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:35:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40225 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab2CaAeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:34:24 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/2] regulator: add device tree support for max8997
To: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org
Cc: k.lewandowsk@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        Rajendra Nayak <rnayak@ti.com>
In-Reply-To: <1332582590-16382-3-git-send-email-thomas.abraham@linaro.org>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org> <1332582590-16382-3-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 30 Mar 2012 16:09:29 -0600
Message-Id: <20120330220929.6F0B93E0602@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2012 15:19:50 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Add device tree based discovery support for max8997.
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  .../devicetree/bindings/regulator/max8997-pmic.txt |  133 ++++++++++++++++++
>  drivers/mfd/max8997.c                              |   73 ++++++++++-
>  drivers/regulator/max8997.c                        |  143 +++++++++++++++++++-
>  include/linux/mfd/max8997-private.h                |    1 +
>  include/linux/mfd/max8997.h                        |    1 +
>  5 files changed, 347 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/max8997-pmic.txt b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> new file mode 100644
> index 0000000..90a730b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> @@ -0,0 +1,133 @@
> +* Maxim MAX8997 Voltage and Current Regulator
> +
> +The Maxim MAX8997 is a multi-function device which includes volatage and
> +current regulators, rtc, charger controller and other sub-blocks. It is
> +interfaced to the host controller using a i2c interface. Each sub-block is
> +addressed by the host system using different i2c slave address. This document
> +describes the bindings for 'pmic' sub-block of max8997.
> +
> +Required properties:
> +- compatible: Should be "maxim,max8997-pmic".
> +- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
> +
> +- max8997,pmic-buck1-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
> +  units for buck1 when changing voltage using gpio dvs. Refer to [1] below
> +  for additional information.
> +
> +- max8997,pmic-buck2-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
> +  units for buck2 when changing voltage using gpio dvs. Refer to [1] below
> +  for additional information.
> +
> +- max8997,pmic-buck5-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
> +  units for buck5 when changing voltage using gpio dvs. Refer to [1] below
> +  for additional information.

These are *really long* property names.  Anything over 32 characters
seems excessive to me.

Other than that the binding looks good.

g.

