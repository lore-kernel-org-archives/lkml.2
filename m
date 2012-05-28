Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2E1Pb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:31:57 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41803 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333Ab2E1Pbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:31:55 -0400
Message-ID: <1338219259.3521.1.camel@debian>
Subject: Re: [PATCH] video: bfin_adv7393fb: Fix cleanup code
From: Emil Goode <emilgoode@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Mon, 28 May 2012 17:34:19 +0200
In-Reply-To: <20120528152601.GE4637@mwanda>
References: <1338216019-1288-1-git-send-email-emilgoode@gmail.com>
	 <20120528152601.GE4637@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dan, I'll resend with these modifications.

Best regards, 
Emil Goode
On Mon, 2012-05-28 at 18:26 +0300, Dan Carpenter wrote:
> On Mon, May 28, 2012 at 04:40:19PM +0200, Emil Goode wrote:
> > This patch fixes the cleanup code of the bfin_adv7393_fb_probe
> > function by changing the order in which cleanup is performed
> > and by adding one label.
> > 
> 
> Could you list the actual bugs which were fixed:
> 
> 1) The resources were not freed in the order that we allocated them
>    so we call dma_free_coherent() before it was allocated.
> 2) The labels weren't in the right place which also meant that we
>    freed resources that weren't allocated.
> 3) We should free gpio_free(P_IDENT(P_PPI0_FS3)) before returning.
> 
> The new gpio_free() is more important than the added label.
> 
> Since you're changing all these, you may as well fix the label names
> as well.  The out_9 style labels suck.  The right way is to give
> them meaningful labels instead of GW-BASIC style labels.
> 
> Labels should be named after what happens when you arrive.  Some
> people name them after the start of the journey but that's a
> mistake.  It's just like the town of Chicago is still called Chicago
> even though you might goto Chicago starting from Boston.  Like this:
> 
> err_ppi:
> 	free_dma(CH_PPI);
> 	fb_dealloc_cmap(&fbdev->info.cmap);
> err_palette:
> 	kfree(fbdev->info.pseudo_palette);
> 
> regards,
> dan carpenter


