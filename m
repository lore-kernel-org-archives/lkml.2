Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2GWUvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:51:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57065 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2GWUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:51:48 -0400
Message-ID: <500DB960.6020802@wwwdotorg.org>
Date: Mon, 23 Jul 2012 14:51:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, ccross@android.com, olof@lixom.net,
        lrg@ti.com, thierry.reding@avionic-design.de,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 2/2] regulator: tps6586x: add support for input supply
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com> <1342187432-18668-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1342187432-18668-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 07:50 AM, Laxman Dewangan wrote:
> There is multiple voltage input pins on device which
> takes the voltage input for different voltage regulator.
> Support to configure the voltage input supplied by
> different regulator for each regulators.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  .../devicetree/bindings/regulator/tps6586x.txt     |   17 +++++++
>  drivers/regulator/tps6586x-regulator.c             |   47 ++++++++++---------
>  2 files changed, 42 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
> index ab17ef6..d156e1b 100644
> --- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
> +++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
> @@ -9,6 +9,14 @@ Required properties:
>  - regulators: list of regulators provided by this controller, must have
>    property "regulator-compatible" to match their hardware counterparts:
>    sm[0-2], ldo[0-9] and ldo_rtc
> +- sm0-supply: The input supply for the SM0.
> +- sm1-supply: The input supply for the SM1.
> +- sm2-supply: The input supply for the SM2.
> +- vinldo01-supply: The input supply for the LDO1 and LDO2
> +- vinldo23-supply: The input supply for the LDO2 and LDO3
> +- vinldo4-supply: The input supply for the LDO4
> +- vinldo678-supply: The input supply for the LDO6, LDO7 and LDO8
> +- vinldo9-supply: The input supply for the LDO9

Hmm. The signal names in my data sheet are VIN_SMn and VINLDOn, so
having "vin" in just some of the property names seems a little inconsistent.

> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c

>  static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
>  {
> -	return rdev_get_dev(rdev)->parent->parent;
> +	return rdev_get_dev(rdev)->parent;
...
> @@ -351,7 +354,7 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
...
> -	config.dev = &pdev->dev;
> +	config.dev = pdev->dev.parent;

Those seem like unrelated changes, but I suppose it's fine.
