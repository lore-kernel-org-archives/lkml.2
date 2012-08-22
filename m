Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab2HVQMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:12:34 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:27577 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab2HVQMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:12:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1345651939!8264530!28
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Grant Likely <grant.likely@secretlab.ca>
CC: "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 22 Aug 2012 11:12:26 -0500
Subject: RE: [PATCH 10/14] drivers/spi/spi-ep93xx.c: fix error return code
Thread-Topic: [PATCH 10/14] drivers/spi/spi-ep93xx.c: fix error return code
Thread-Index: Ac195ugB3gIXjaA5Sm+5zpfn8pJdhQCmdUGg
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B1B19DD6@AUSP01VMBX24.collaborationhost.net>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
 <1345365870-29831-12-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1345365870-29831-12-git-send-email-Julia.Lawall@lip6.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 19, 2012 1:44 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Initialize return variable before exiting on an error path.

<snip>

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/spi/spi-ep93xx.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index f97f1d2..9e7fdfd 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -1105,6 +1105,7 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
>  	espi->wq = create_singlethread_workqueue("ep93xx_spid");
>  	if (!espi->wq) {
>  		dev_err(&pdev->dev, "unable to create workqueue\n");
> +		error = -ENOMEM;
>  		goto fail_free_dma;
>  	}
>  	INIT_WORK(&espi->msg_work, ep93xx_spi_work);

Looks ok to me... Thanks!

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
