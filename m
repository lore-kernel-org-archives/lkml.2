Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab1JCPs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:48:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:17800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab1JCPsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,479,1312182000"; 
   d="scan'208";a="22820964"
Date: Mon, 3 Oct 2011 17:51:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 06/23] mfd/db8500-prcmu: add accessors for PLL and SGA
 clock
Message-ID: <20111003155140.GO4118@sortiz-mobl>
References: <1313137698-30782-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313137698-30782-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 12, 2011 at 10:28:18AM +0200, Linus Walleij wrote:
>  int db8500_prcmu_request_clock(u8 clock, bool enable)
>  {
> -	if (clock < PRCMU_NUM_REG_CLOCKS)
> +	if (clock == PRCMU_SGACLK)
> +		return request_sga_clock(clock, enable);
> +	else if (clock < PRCMU_NUM_REG_CLOCKS)
>  		return request_reg_clock(clock, enable);
>  	else if (clock == PRCMU_TIMCLK)
>  		return request_timclk(enable);
>  	else if (clock == PRCMU_SYSCLK)
>  		return request_sysclk(enable);
> +	else if (clock == PRCMU_PLLSOC1)
> +		return request_pll(clock, enable);
>  	else
>  		return -EINVAL;
This looks like you're willing to use a switch case here (and default to
request_reg_clock() who would return -EINVAL if clock >=
PRCMU_NUM_REG_CLOCKS).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
