Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1L0JWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 04:22:13 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:57716 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab1L0JWL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 04:22:11 -0500
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Eric Miao <eric.y.miao@gmail.com>, Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>
Date: Tue, 27 Dec 2011 01:18:59 -0800
Subject: RE: [PATCH RESEND] ARM: pxa: fix error handling in
 pxa2xx_drv_pcmcia_probe
Thread-Topic: [PATCH RESEND] ARM: pxa: fix error handling in
 pxa2xx_drv_pcmcia_probe
Thread-Index: AczEd4LKeeqf3NxBT42xD0ee6XDxfQAAQ6Ro
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05EC64DBD3@SC-VEXCH1.marvell.com>
References: <1324974344.2351.5.camel@phoenix>,<CAMPhdO_QL3ahf4+F70Bg7FHKq5mrbbofN_BTz8dpcBLea9BNAw@mail.gmail.com>
In-Reply-To: <CAMPhdO_QL3ahf4+F70Bg7FHKq5mrbbofN_BTz8dpcBLea9BNAw@mail.gmail.com>
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


________________________________________
From: Eric Miao [eric.y.miao@gmail.com]
Sent: Tuesday, December 27, 2011 5:11 PM
To: Axel Lin
Cc: linux-kernel@vger.kernel.org; Haojian Zhuang; Russell King; linux-arm-kernel@lists.infradead.org; linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH RESEND] ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe

On Tue, Dec 27, 2011 at 4:25 PM, Axel Lin <axel.lin@gmail.com> wrote:
> If pxa2xx_drv_pcmcia_add_one fails, it will go to err1 error path.
> Add a missing clk_put in the error path.
>
> Checking the ret value after the for loop is redundant, it is always false.
> Thus remove the redundant checking.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/pcmcia/pxa2xx_base.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
> index a87e272..64d433e 100644
> --- a/drivers/pcmcia/pxa2xx_base.c
> +++ b/drivers/pcmcia/pxa2xx_base.c
> @@ -328,21 +328,15 @@ static int pxa2xx_drv_pcmcia_probe(struct platform_device *dev)
>                        goto err1;
>        }
>
> -       if (ret) {
> -               while (--i >= 0)
> -                       soc_pcmcia_remove_one(&sinfo->skt[i]);
> -               kfree(sinfo);
> -               clk_put(clk);
> -       } else {
> -               pxa2xx_configure_sockets(&dev->dev);
> -               dev_set_drvdata(&dev->dev, sinfo);
> -       }
> +       pxa2xx_configure_sockets(&dev->dev);
> +       dev_set_drvdata(&dev->dev, sinfo);
>
>        return 0;
>
>  err1:
>        while (--i >= 0)
>                soc_pcmcia_remove_one(&sinfo->skt[i]);
> +       clk_put(clk);
>        kfree(sinfo);
>  err0:
>        return ret;
> --
> 1.7.5.4
>
>
>
Wait a minute.

The original code will check whether pxa2xx_drv_pcmcia_add_one() successful. If it fails, we'll remove all devices that we registered.

But Axel removed these code. Why?

Thanks
Haojian
