Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1I2EVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 00:21:36 -0400
Received: from relais.videotron.ca ([24.201.245.36]:61051 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1I2EVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 00:21:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 29 Sep 2011 00:21:29 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] msm: Support DEBUG_LL on MSM8660 and MSM8960
In-reply-to: <1317243959-26383-3-git-send-email-sboyd@codeaurora.org>
Message-id: <alpine.LFD.2.02.1109290012400.9106@xanadu.home>
References: <1317243959-26383-1-git-send-email-sboyd@codeaurora.org>
 <1317243959-26383-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011, Stephen Boyd wrote:

> Add support for DEBUG_LL on the 8660 and 8960 development boards.
> While we're here, cleanup the uncompress.h code a bit.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

[...]

>  	.macro	senduart,rd,rx
> +#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
> +	@ Clear TX_READY by writing to the UARTDM_CR register
> +	mov	r12, #0x300
> +	str	r12, [\rx, #0x10]
> +	@ Write 0x1 to NCF register
> +	mov 	r12, #0x1
> +	str	r12, [\rx, #0x40]
> +	@ UARTDM reg. Read to induce delay
> +	ldr	r12, [\rx, #0x08]
> +	@ Write the 1 character to UARTDM_TF
> +	str	\rd, [\rx, #0x70]

This is a really bad idea to pick a register (r12) when the calling code 
is completely unaware of that.  This _will_ break on you someday.

Except for the last line, why didn't you simply fold this code into the 
waituart macro instead?


Nicolas
