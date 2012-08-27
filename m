Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2H0OjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:39:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43252 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752513Ab2H0Oi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:38:57 -0400
Date: Mon, 27 Aug 2012 10:38:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers/usb/host/ohci-nxp.c: adjust inconsistent
 IS_ERR and PTR_ERR
In-Reply-To: <1345924629-16584-5-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <Pine.LNX.4.44L0.1208271038370.1817-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Change the call to PTR_ERR to access the value just tested by IS_ERR.

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/usb/host/ohci-nxp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
> index a446386..c60066a 100644
> --- a/drivers/usb/host/ohci-nxp.c
> +++ b/drivers/usb/host/ohci-nxp.c
> @@ -355,7 +355,7 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
>  	usb_otg_clk = clk_get(&pdev->dev, "ck_usb_otg");
>  	if (IS_ERR(usb_otg_clk)) {
>  		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
> -		ret = PTR_ERR(usb_dev_clk);
> +		ret = PTR_ERR(usb_otg_clk);
>  		goto out6;
>  	}

Acked-by: Alan Stern <stern@rowland.harvard.edu>

