Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1JXT5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:57:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42830 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1JXT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:57:30 -0400
Date: Mon, 24 Oct 2011 20:56:06 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Mark Einon <mark.einon@gmail.com>, Greg KH <greg@kroah.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging 6/6] et131x: uncloak PCIe capabilities.
Message-ID: <20111024195602.GA3473@msilap.einon>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
 <20111023093651.GA22285@kroah.com>
 <20111023094231.GA3409@msilap.einon>
 <20111023171214.GF28657@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023171214.GF28657@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 07:12:14PM +0200, Francois Romieu wrote:
> FIXME: it should be possible to get rid of ET1310_PCI_L0L1LATENCY as well.
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> ---
>  drivers/staging/et131x/et131x.c |   53 ++++++++++++++++++++++----------------
>  1 files changed, 31 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index 79ca1d3..2a0b794 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
[...]
> -	if (et131x_init_eeprom(adapter) < 0)
> -		return -EIO;
> +	rc = et131x_init_eeprom(adapter);
> +	if (rc < 0)
> +		goto out;
>  
[...]
>  	}
>  	memcpy(adapter->addr, adapter->rom_addr, ETH_ALEN);
> -	return 0;
> +out:
> +	return rc;
> +err_out:
> +	rc = -EIO;
> +	goto out;
>  }

Hi Francois,

The PCIe changes are good, however I think using gotos here doesn't add anything as there's no difficult locking to navigate and makes the code harder to read.
both out: and err_out: are used to return an error, and the backwards jumping goto makes me a bit uncomfortable. Could you respin with just the PCIe changes?

Cheers,

Mark
