Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2F1MwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:52:24 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18658 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2F1MwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:52:23 -0400
Date: Thu, 28 Jun 2012 14:51:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Clear only status bits in HST_STS after
 waiting for INTR
Message-ID: <20120628145159.3725395b@endymion.delvare>
In-Reply-To: <1340873970-19226-1-git-send-email-djkurtz@chromium.org>
References: <1340873970-19226-1-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 16:59:30 +0800, Daniel Kurtz wrote:
> Writing back the whole status register could clear unwanted bits.
> In particular, it could clear the "INUSE_STS" bit, which is a
> 'hardware semaphore', that might be useful to use some day.
> To prepare for this, let's ban writing back the whole status to register
> HST_STS, of which this is the only instance.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Reported-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index ae2945a..7443990 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -301,7 +301,7 @@ static void i801_wait_hwpec(struct i801_priv *priv)
>  	if (timeout > MAX_RETRIES)
>  		dev_dbg(&priv->pci_dev->dev, "PEC Timeout!\n");
>  
> -	outb_p(status, SMBHSTSTS(priv));
> +	outb_p(status & STATUS_FLAGS, SMBHSTSTS(priv));
>  }
>  
>  static int i801_block_transaction_by_block(struct i801_priv *priv,

Applied, thanks.

-- 
Jean Delvare
