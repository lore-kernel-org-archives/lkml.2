Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1GGWMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:12:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57182 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751601Ab1GGWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:12:41 -0400
Date: Thu, 7 Jul 2011 23:15:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: gma500: Mask out bits not part of the page table base address
Message-ID: <20110707231516.66cb90be@lxorguk.ukuu.org.uk>
In-Reply-To: <20110707220621.GA6922@patrik-macbook>
References: <20110707220621.GA6922@patrik-macbook>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011 00:06:21 +0200
Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:

> Otherwise we can't ioremap the gtt and the screen gets garbled.
> 
> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> ---
> 
> diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
> index 28f2261..78dd01b 100644
> --- a/drivers/staging/gma500/gtt.c
> +++ b/drivers/staging/gma500/gtt.c
> @@ -397,7 +397,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
>  	/* The root resource we allocate address space from */
>  	dev_priv->gtt_initialized = 1;
>  
> -	pg->gtt_phys_start = dev_priv->pge_ctl;
> +	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;

Umm yes I suppose if its already been enabled that'll be slightly
important

Acked-by: Alan Cox <alan@linux.intel.com>
