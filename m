Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1ILUnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 16:43:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58191 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1ILUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 16:43:41 -0400
Date: Mon, 12 Sep 2011 14:43:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2 v2] power: bq20z75: Add Device Tree Binding
Message-ID: <20110912204339.GH23345@ponder.secretlab.ca>
References: <1315615669-8701-1-git-send-email-rklein@nvidia.com>
 <1315615669-8701-2-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315615669-8701-2-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 05:47:49PM -0700, Rhyland Klein wrote:
> Adding the binding for the TI bq20z75 fuel gadge and the
> bq20z75 driver.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  .../bindings/power_supply/ti_bq20z75.txt           |   25 ++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> new file mode 100644
> index 0000000..3deccfe
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
> @@ -0,0 +1,25 @@
> +TI bq20z75
> +~~~~~~~~~~
> +
> +Required properties :
> + - compatible : "ti,bq20z75"
> +
> +Optional properties :
> + - i2c-retry-count : The number of times to retry i2c transactions on i2c
> +   IO failure.
> + - poll-retry-count : The number of times to try looking for new status
> +   after an external change notification.

Prefix custom properties with a vendor string.  ie. "ti,"

> + - battery-detect : The GPIO which is used to detect battery presence.
> + - battery-detect-present : The state of the GPIO when the battery is
> +   present ( 0 or 1).

Use the gpios binding here.  Should be encoded as a single property
that uses the flags field for the polarity.  Something like:

	battery-detect-gpios = <&gpio-controller 10 0>;

g.

