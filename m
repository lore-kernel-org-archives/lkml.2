Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0H1SY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 14:24:27 -0400
Received: from n10.bullet.mail.ac4.yahoo.com ([76.13.13.238]:26254 "HELO
	n10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753335Ab0H1SYZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 14:24:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 739676.74022.bm@omp130.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=tkCBqLlprzWVVI4uIKbSTc+PDsvdjpfT74R1Bcqo3dPHHeMDof34uE2PSjOBukKznCaZ8DA17o7djZfDxKV/sB48TfysnazIbJWXSfZ14SNs7IaDRqWdG1nLnjmziKWT58gSy7jVT3A4eARsck9xcIN6krLYmLyY5f5cCO8RmQs=;
Message-ID: <634098.18332.qm@web180309.mail.gq1.yahoo.com>
X-YMail-OSG: skSmxLoVM1lPT.QQ8zi5BGdvipddzJfV5k.CyFFwlKaD9n.
 nfE5fAZMqMxbtm7DtRkQblxt5A43ynMRNUF5MT61_bYvjKO6YxXMST2kmSGp
 a2xhPLcUuBoF7BygnvozE3Tps473OAx4XvLz8MzDJo1gXV_tyFAifPUdQf3X
 EiOJiwYri.igC9UzrxWSe3DNIYuPylH3ep.KSMgvtrBg7vJmw2ccYdzsiS.3
 LDJ74grl37yd0EBhf.QnvfpNQUgtLyfNgFS8K53PZ0vz0QVn95Bh.SUxZC2t
 tW.txHdo6vGmKJhh95OKk2M.9VBsC4XDM_fErje0chzgy9X2qYe9vAG5o935
 glVqsom.IYS0-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 28 Aug 2010 11:24:24 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 2/7] drivers/usb/gadget/amd5536udc.c: Remove double test
To: Dan Carpenter <error27@gmail.com>, Julia Lawall <julia@diku.dk>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1008281846170.13508@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 8/28/10, Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> Subject: Re: [PATCH 2/7] drivers/usb/gadget/amd5536udc.c: Remove double test
> To: "Dan Carpenter" <error27@gmail.com>
> Cc: "Thomas Dahlmann" <dahlmann.thomas@arcor.de>, kernel-janitors@vger.kernel.org, "David Brownell" <dbrownell@users.sourceforge.net>, "Greg Kroah-Hartman" <gregkh@suse.de>, linux-geode@lists.infradead.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Saturday, August 28, 2010, 9:48 AM
> The same expression is tested twice
> and the result is the same each time.
> Instead test for use_dma_ppb as in the test above.
> 
> The sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @expression@
> expression E;
> @@
> 
> (
> * E
>   || ... || E
> |
> * E
>   && ... && E
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>


OK by me unless the maintainer/author objects.

Thank you!

- Dave



> 
> ---
>  drivers/usb/gadget/amd5536udc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/amd5536udc.c
> b/drivers/usb/gadget/amd5536udc.c
> index 731150d..6c40c99 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -203,7 +203,7 @@ static void print_regs(struct udc
> *dev)
>          DBG(dev, "DMA
> mode       = PPBNDU (packet per
> buffer "
>             
> "WITHOUT desc. update)\n");
>         
> dev_info(&dev->pdev->dev, "DMA mode (%s)\n",
> "PPBNDU");
> -    } else if (use_dma &&
> use_dma_ppb_du && use_dma_ppb_du) {
> +    } else if (use_dma &&
> use_dma_ppb && use_dma_ppb_du) {
>          DBG(dev, "DMA
> mode       = PPBDU (packet per
> buffer "
>             
> "WITH desc. update)\n");
>         
> dev_info(&dev->pdev->dev, "DMA mode (%s)\n",
> "PPBDU");
> 
> 

