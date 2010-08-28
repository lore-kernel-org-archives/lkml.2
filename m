Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0H1QiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:38:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38545 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0H1QiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Wg3HSFhBYbYpZkGAZ391LDa5RsdzaChp+/b+POALTXefyMT8iX8jxHq2PtMXRKq89Y
         awoi3QhEl7aQDvZmllpsgYq8stupsbRvXNXTK7TN0pwhoXxWveZwVYWfctZYPhs41JVS
         jrPemozxPd0jtO4rtfWkb0b7lhN4mbAplFAZI=
Date: Sat, 28 Aug 2010 18:37:25 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
Message-ID: <20100828163725.GI9832@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	Thomas Dahlmann <dahlmann.thomas@arcor.de>,
	kernel-janitors@vger.kernel.org,
	David Brownell <dbrownell@users.sourceforge.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1283010066-20935-1-git-send-email-julia@diku.dk> <1283010066-20935-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283010066-20935-3-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 05:41:01PM +0200, Julia Lawall wrote:
> This is a guess as to what the code should be.  Perhaps something else
> should have been tested instead.
> 
>  drivers/usb/gadget/amd5536udc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> index 731150d..6c40c99 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -203,7 +203,7 @@ static void print_regs(struct udc *dev)
>  		DBG(dev, "DMA mode       = PPBNDU (packet per buffer "
>  			"WITHOUT desc. update)\n");
>  		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBNDU");
> -	} else if (use_dma && use_dma_ppb_du && use_dma_ppb_du) {
> +	} else if (use_dma && use_dma_ppb_du) {


My guess is that "use_dma_ppb" was intended.

regards,
dan carpenter

