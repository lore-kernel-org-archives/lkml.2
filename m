Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2HMRnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:43:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46645 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2HMRnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:43:02 -0400
Message-ID: <50293CA1.80900@wwwdotorg.org>
Date: Mon, 13 Aug 2012 11:42:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com
CC: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V3] regulator: tps6586x: add support for SYS rail
References: <1344152518-29378-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344152518-29378-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 01:41 AM, Laxman Dewangan wrote:
> Device have SYS rail which is always ON. It is system
> power bus. LDO5 and LDO_RTC get powered through this rail
> internally. Add support for this rail and make the
> LDO5/LDO_RTC input supply to "sys".
> Update document accordingly.

Mark,

This patch appears to have been applied correctly as b93fffb in your
tree, but your for-next branch merge commit f110340 appears to have
dropped the following two hunks:

> diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
> index d156e1b..ec527d9 100644
> --- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
> +++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
> @@ -8,7 +8,8 @@ Required properties:
>  - gpio-controller: mark the device as a GPIO controller
>  - regulators: list of regulators provided by this controller, must have
>    property "regulator-compatible" to match their hardware counterparts:
> -  sm[0-2], ldo[0-9] and ldo_rtc
> +  sys, sm[0-2], ldo[0-9] and ldo_rtc
> +- sys-supply: The input supply for SYS.
>  - sm0-supply: The input supply for the SM0.
>  - sm1-supply: The input supply for the SM1.
>  - sm2-supply: The input supply for the SM2.
> @@ -30,6 +34,7 @@ Example:
>  		#gpio-cells = <2>;
>  		gpio-controller;
>  
> +		sys-supply = <&some_reg>;
>  		sm0-supply = <&some_reg>;
>  		sm1-supply = <&some_reg>;
>  		sm2-supply = <&some_reg>;

