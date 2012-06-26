Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2FZKlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:41:40 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:41020 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508Ab2FZKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:41:38 -0400
Message-ID: <4FE991DA.5070301@ti.com>
Date: Tue, 26 Jun 2012 16:11:30 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de
Subject: Re: [PATCH v2 05/17] i2c: omap: split out [XR]DR and [XR]RDY
References: <1339691067-919-1-git-send-email-balbi@ti.com> <1339691067-919-6-git-send-email-balbi@ti.com>
In-Reply-To: <1339691067-919-6-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
On Thursday 14 June 2012 09:54 PM, Felipe Balbi wrote:
>  			return IRQ_HANDLED;
>  		}
>  
> -		if (stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR)) {
> +		if (stat & OMAP_I2C_STAT_RDR) {
>  			u8 num_bytes = 1;
>  
> +			if (dev->fifo_size)
> +				num_bytes = dev->fifo_size;
In case of a draining interrupt. The byte count may not be the fifo size.
Do you agree?
> +
> +			while (num_bytes--) {
> +				if (!dev->buf_len) {

