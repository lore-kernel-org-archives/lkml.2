Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab2KMVhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:37:16 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:24908 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2KMVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:37:15 -0500
Message-ID: <50A2BD87.3060202@tilera.com>
Date: Tue, 13 Nov 2012 16:37:11 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tilegx: request_irq with a non-null device name
References: <1352840300-27814-1-git-send-email-simon.marchi@polymtl.ca>
In-Reply-To: <1352840300-27814-1-git-send-email-simon.marchi@polymtl.ca>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 3:58 PM, Simon Marchi wrote:
> This patch simply makes the tilegx net driver call request_irq with a
> non-null name. It makes the output in /proc/interrupts more obvious, but
> also helps tools that don't expect to find null there.
>
> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
> ---
>  drivers/net/ethernet/tile/tilegx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
> index 4e98100..66e025a 100644
> --- a/drivers/net/ethernet/tile/tilegx.c
> +++ b/drivers/net/ethernet/tile/tilegx.c
> @@ -917,7 +917,7 @@ static int tile_net_setup_interrupts(struct net_device *dev)
>  	ingress_irq = rc;
>  	tile_irq_activate(ingress_irq, TILE_IRQ_PERCPU);
>  	rc = request_irq(ingress_irq, tile_net_handle_ingress_irq,
> -			 0, NULL, NULL);
> +			 0, "tile_net", NULL);

Good catch.  If you can change it to dev->name instead of "tile_net", feel
free to add my:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

