Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab0DHS4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:56:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:53598 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758728Ab0DHS4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:56:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+muRs9CQemxWWrIYuzSt5P6LNzf0uwYFchTsFZYS
	t03zhBEIVdFCwC
Message-ID: <4BBE26BF.3000404@gmx.de>
Date: Thu, 08 Apr 2010 20:55:59 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/16] viafb: Unmap the frame buffer on initialization
 error
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-4-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-4-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> This was part of Harald's "make viafb a first-class citizen using
> pci_driver" patch, but somehow got dropped when that patch went into
> mainline.

Well it was dropped because the patch introducing the goto_error_out 
logic wasn't backported that time because I planned to rewrite the 
framebuffer initialization to use a common function for multiple 
framebuffers.
As we now (due to your previous patches) have this logic it looks good 
to me.


Thanks,

Florian Tobias Schandinat

> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/video/via/viafbdev.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index 91bfe6d..4a34d4f 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c
> @@ -1991,7 +1991,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  		if (!viafbinfo1) {
>  			printk(KERN_ERR
>  			"allocate the second framebuffer struct error\n");
> -			goto out_delete_i2c;
> +			goto out_unmap_screen;
>  		}
>  		viaparinfo1 = viafbinfo1->par;
>  		memcpy(viaparinfo1, viaparinfo, viafb_par_length);
> @@ -2086,6 +2086,8 @@ out_dealloc_cmap:
>  out_fb1_release:
>  	if (viafbinfo1)
>  		framebuffer_release(viafbinfo1);
> +out_unmap_screen:
> +	iounmap(viafbinfo->screen_base);
>  out_delete_i2c:
>  	viafb_delete_i2c_buss(viaparinfo);
>  out_fb_release:

