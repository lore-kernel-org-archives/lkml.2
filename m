Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1JCPtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:49:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:14955 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab1JCPtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="58497783"
Date: Mon, 3 Oct 2011 17:52:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 09/23] mfd/db8500-prcmu: tweak for modem wakeup
Message-ID: <20111003155207.GP4118@sortiz-mobl>
References: <1313137723-30881-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313137723-30881-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 12, 2011 at 10:28:43AM +0200, Linus Walleij wrote:
> @@ -1754,11 +1755,34 @@ void prcmu_ac_wake_req(void)
>  
>  	atomic_set(&ac_wake_req_state, 1);
>  
> +retry:
>  	writel((val | PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ), PRCM_HOSTACCESS_REQ);
>  
>  	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
> -			msecs_to_jiffies(20000))) {
> -		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
> +			msecs_to_jiffies(5000))) {
> +		panic("prcmu: %s timed out (5 s) waiting for a reply.\n",
> +			__func__);
panic(), really ?


> @@ -1783,8 +1807,8 @@ void prcmu_ac_sleep_req()
>  		PRCM_HOSTACCESS_REQ);
>  
>  	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
> -			msecs_to_jiffies(20000))) {
> -		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
> +			msecs_to_jiffies(5000))) {
> +		panic("prcmu: %s timed out (5 s) waiting for a reply.\n",
Ditto.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
