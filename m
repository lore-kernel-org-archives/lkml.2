Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1IUH4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:56:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5115 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1IUH4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:56:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6475"; a="120139400"
Message-ID: <4E7998AD.9070305@codeaurora.org>
Date: Wed, 21 Sep 2011 00:56:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
 choice
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org> <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/2011 6:23 PM, Stephen Boyd wrote:
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 6dbcb00..31896f4 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -81,6 +81,17 @@ choice
>  	prompt "Kernel low-level debugging port"
>  	depends on DEBUG_LL
>  
> +	config DEBUG_ICEDCC
> +		bool "Kernel low-level debugging via EmbeddedICE DCC channel"
> +		depends on DEBUG_LL

Oops. This depends isn't necessary. Will fix before submitting to patch
tracker.

> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to the EmbeddedICE macrocell's DCC channel using
> +		  co-processor 14. This is known to work on the ARM9 style ICE
> +		  channel and on the XScale with the PEEDI.
> +
> +		  It does include a timeout to ensure that the system does not
> +		  totally freeze when there is nothing connected to read.
>  
>  	config DEBUG_FOOTBRIDGE_COM1
>  		bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"
>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

