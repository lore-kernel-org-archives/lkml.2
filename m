Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab1INPzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:55:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32827 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828Ab1INPzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:55:23 -0400
Date: Wed, 14 Sep 2011 09:55:18 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2 v3] power: bq20z75: Add Device Tree Binding
Message-ID: <20110914155518.GE3134@ponder.secretlab.ca>
References: <1315948899-21536-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315948899-21536-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 02:21:39PM -0700, Rhyland Klein wrote:
> Adding the binding for the TI bq20z75 fuel gadge and the
> bq20z75 driver.

Squash this patch into the first patch.  There is no reason to keep
them separate.

> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
> 	v2: Fixed typo in binding description
> 	v3: Changed unique properties to be use "ti,"
> 	    Changed to use single gpio entry for gpio info
> 
>  .../bindings/power_supply/ti_bq20z75.txt           |   23 ++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> new file mode 100644
> index 0000000..7571294
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> @@ -0,0 +1,23 @@
> +TI bq20z75
> +~~~~~~~~~~
> +
> +Required properties :
> + - compatible : "ti,bq20z75"
> +
> +Optional properties :
> + - ti,i2c-retry-count : The number of times to retry i2c transactions on i2c
> +   IO failure.
> + - ti,poll-retry-count : The number of times to try looking for new status
> +   after an external change notification.
> + - ti,battery-detect-gpios : The gpio which signals battery detection and
> +   a flag specifying its polarity.
> +
> +Example:
> +
> +	bq20z75@b {
> +		compatible = "ti,bq20z75";
> +		reg = < 0xb >;
> +		ti,i2c-retry-count = <2>;
> +		ti,poll-retry-count = <10>;
> +		ti,battery-detect-gpios = <&gpio-controller 122 1>;
> +	}
> -- 
> 1.7.6
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
