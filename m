Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0KDTaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:30:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab0KDTaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:30:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6157"; a="60669706"
Subject: Re: [PATCHv2 2/3] ARM: Allow machines to override __delay()
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nico@fluxnic.net>
In-Reply-To: <1288300770-18350-3-git-send-email-sboyd@codeaurora.org>
References: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>
	 <1288300770-18350-3-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 12:30:02 -0700
Message-ID: <1288899002.21823.3.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 14:19 -0700, Stephen Boyd wrote:
> +
> +static void (*delay_fn)(unsigned long) = delay_loop;
> +
> +void set_delay_fn(void (*fn)(unsigned long))
> +{
> +       delay_fn = fn;
> +}

This needs to be a static inline in the header file.

> +/*
> + * loops = usecs * HZ * loops_per_jiffy / 1000000
> + */
> +void __delay(unsigned long loops)
> +{
> +       delay_fn(loops);
> +}
>  EXPORT_SYMBOL(__delay);

Can we make this static inline also? I'm sure about the module issues..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

