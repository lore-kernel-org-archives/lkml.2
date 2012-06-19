Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2FSRjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:39:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41586 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2FSRjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:39:09 -0400
Message-ID: <4FE0B939.9080702@wwwdotorg.org>
Date: Tue, 19 Jun 2012 11:39:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, linus.walleij@linaro.org,
        lrg@ti.com, lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/3] regulator: dt: regulator match by regulator-compatible
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <1340116099-17629-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340116099-17629-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 08:28 AM, Laxman Dewangan wrote:
> Match the device's regulators with the property of
> "regulator-compatible" of each regulator node.

> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c

>  /**
> - * of_regulator_match - extract regulator init data
> + * of_regulator_match - extract regulator init data when node
> + * property "regulator-compatible" matches with the regulator name.
>   * @dev: device requesting the data
>   * @node: parent device node of the regulators
>   * @matches: match table for the regulators
>   * @num_matches: number of entries in match table
>   *
>   * This function uses a match table specified by the regulator driver and
> - * looks up the corresponding init data in the device tree. Note that the
> - * match table is modified in place.
> + * looks up the corresponding init data in the device tree  if
> + * regulator-compatible matches. Note that the match table is modified
> + * in place.
>   *
>   * Returns the number of matches found or a negative error code on failure.
>   */

I don't think you actually need to modify any of the documentation; the
function is still doing the exact same thing and it's an implementation
detail really that it's doing it based on the regulator-compatible
property rather than the node name now.

Still, that's just a nit-pick, so I'm OK either way.

> @@ -110,27 +112,39 @@ int of_regulator_match(struct device *dev, struct device_node *node,
...
> +	for_each_child_of_node(node, child) {
...
> +		for (i = 0; i < num_matches; i++) {
...
> +			match->of_node = child;
> +			count++;

You may as well "break;" here to avoid checking all the other match
table entries, which hopefully don't have duplicate names...

But, that's also pretty minor, so:
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
