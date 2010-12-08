Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0LHTW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:22:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58733 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab0LHTW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:22:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6190"; a="65806066"
Subject: Re: [PATCHv3 2/4] ARM: Allow machines to override __delay()
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Arve Hj?nnev?g <arve@android.com>
In-Reply-To: <1291783128-27520-3-git-send-email-sboyd@codeaurora.org>
References: <1291783128-27520-1-git-send-email-sboyd@codeaurora.org>
	 <1291783128-27520-3-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 11:22:42 -0800
Message-ID: <1291836162.12568.17.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 20:38 -0800, Stephen Boyd wrote:
> +
> +static void (*delay_fn)(unsigned long) = delay_loop;
> +
> +void set_delay_fn(void (*fn)(unsigned long))
> +{
> +       delay_fn = fn;
> +}
> +
> +/*
> + * loops = usecs * HZ * loops_per_jiffy / 1000000
> + */
> +void __delay(unsigned long loops)
> +{
> +       delay_fn(loops);
> +}
>  EXPORT_SYMBOL(__delay);

Didn't we already go over this part ? Why are aren't you putting these
in a header file ?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

