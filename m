Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2IMRoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:44:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20900 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2IMRoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:44:17 -0400
Date: Thu, 13 Sep 2012 20:43:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 07/24] Staging: ipack/devices/ipoctal: Store isr masks in
 ipoctal_channel
Message-ID: <20120913174312.GB4587@mwanda>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
 <1347454546-23236-7-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347454546-23236-7-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:55:29PM +0200, Samuel Iglesias Gonsalvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> This way interrupt handling becomes independent of the channel number.
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
> @@ -213,7 +206,7 @@ static int ipoctal_irq_handler(void *arg)
>  		}
>  
>  		/* RX data */
> -		if (isr_rx_rdy && (sr & SR_RX_READY)) {
> +		if ((isr && channel->isr_rx_rdy_mask) && (sr & SR_RX_READY)) {
                         ^^
Bitwise AND intended here I think.

>  			value = ioread8(&channel->regs->r.rhr);
>  			flag = TTY_NORMAL;
>  
> @@ -244,7 +237,7 @@ static int ipoctal_irq_handler(void *arg)
>  		}
>  
>  		/* TX of each character */
> -		if (isr_tx_rdy && (sr & SR_TX_READY)) {
> +		if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY)) {


regards,
dan carpenter

