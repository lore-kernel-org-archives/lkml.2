Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0KITLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:11:43 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50214 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab0KITLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:11:42 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 14:11:42 EST
Message-ID: <4CD99B31.7020505@ti.com>
Date: Tue, 09 Nov 2010 13:04:17 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] PM: Hide OPP configuration when SoCs do not provide an
 implementation
References: <1289327056-27950-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1289327056-27950-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown had written, on 11/09/2010 12:24 PM, the following:
> Since the OPP API is only useful with an appropraite SoC-specific
> implementation there is no point in offering the ability to enable
> the API on general systems. Provide an ARCH_HAS OPP Kconfig symbol
> which masks out the option unless selected by an implementation.
Thanks. yep, this is a good change to have.

> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Nishanth Menon <nm@ti.com>

> ---
>  Documentation/power/opp.txt |    3 +++
>  kernel/power/Kconfig        |    4 ++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
> index 44d87ad..cd44558 100644
> --- a/Documentation/power/opp.txt
> +++ b/Documentation/power/opp.txt
> @@ -37,6 +37,9 @@ Typical usage of the OPP library is as follows:
>  SoC framework	-> modifies on required cases certain OPPs	-> OPP layer
>  		-> queries to search/retrieve information	->
>  
> +Architectures that provide a SoC framework for OPP should select ARCH_HAS_OPP
> +to make the OPP layer available.
> +
>  OPP layer expects each domain to be represented by a unique device pointer. SoC
>  framework registers a set of initial OPPs per device with the OPP layer. This
>  list is expected to be an optimally small number typically around 5 per device.
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 29bff61..a5aff3e 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -246,9 +246,13 @@ config PM_OPS
>  	depends on PM_SLEEP || PM_RUNTIME
>  	default y
>  
> +config ARCH_HAS_OPP
> +	bool
> +
>  config PM_OPP
>  	bool "Operating Performance Point (OPP) Layer library"
>  	depends on PM
> +	depends on ARCH_HAS_OPP
>  	---help---
>  	  SOCs have a standard set of tuples consisting of frequency and
>  	  voltage pairs that the device will support per voltage domain. This


-- 
Regards,
Nishanth Menon
