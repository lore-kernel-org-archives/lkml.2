Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1DDJgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:36:23 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:54217 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753949Ab1DDJgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:36:22 -0400
Date: Mon, 4 Apr 2011 11:36:20 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: wanlong.gao@gmail.com
Cc: davem@davemloft.net, padovan@profusion.mobi, joe@perches.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86:NET:Replaced a deprecated function .
Message-ID: <20110404093620.GA4896@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	wanlong.gao@gmail.com, davem@davemloft.net, padovan@profusion.mobi,
	joe@perches.com, marcel@holtmann.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1301909548-20031-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301909548-20031-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Apr 04, 2011 at 05:32:28PM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> kernel_warning: pcmcia_request_exclusive_irq is deprecated .

NACK. This papers over the issue, instead of fixing it. To properly fix it,
one needs to verify that the IRQ handler used in this driver is capable of
handling a shared IRQ line.

Best,
	Dominik

> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  drivers/net/pcmcia/nmclan_cs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
> index 76683d9..bf97231
> --- a/drivers/net/pcmcia/nmclan_cs.c
> +++ b/drivers/net/pcmcia/nmclan_cs.c
> @@ -625,7 +625,7 @@ static int nmclan_config(struct pcmcia_device *link)
>    ret = pcmcia_request_io(link);
>    if (ret)
>  	  goto failed;
> -  ret = pcmcia_request_exclusive_irq(link, mace_interrupt);
> +  ret = __pcmcia_request_exclusive_irq(link, mace_interrupt);
>    if (ret)
>  	  goto failed;
>    ret = pcmcia_enable_device(link);
> -- 
> 1.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
