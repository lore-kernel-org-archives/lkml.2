Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0KITR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:17:57 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52045 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0KITRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:17:55 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Nishanth Menon <nm@ti.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] PM: Hide OPP configuration when SoCs do not provide an implementation
Organization: Deep Root Systems, LLC
References: <1289327056-27950-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 09 Nov 2010 11:17:50 -0800
In-Reply-To: <1289327056-27950-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	(Mark Brown's message of "Tue, 9 Nov 2010 18:24:16 +0000")
Message-ID: <87fwvaqpb5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> Since the OPP API is only useful with an appropraite SoC-specific
> implementation there is no point in offering the ability to enable
> the API on general systems. Provide an ARCH_HAS OPP Kconfig symbol
> which masks out the option unless selected by an implementation.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

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
