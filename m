Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1GKIUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:20:33 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:39533 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab1GKIUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:20:32 -0400
Date: Mon, 11 Jul 2011 10:20:29 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 10/10] Staging: comedi: fix brace printk() issue in
	pcl818.c
Message-ID: <20110711082029.GL8334@distanz.ch>
References: <1310370712-28864-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310370712-28864-1-git-send-email-ravishankarkm32@gmail.com>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-11 at 09:51:52 +0200, Ravishankar <ravishankarkm32@gmail.com> wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the pcl818.c file that fixes up a printk() warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl818.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index 2fdb8c9..4069fee 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -1777,7 +1777,7 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  					     irq);
>  					irq = 0;	/* Can't use IRQ */
>  				} else {
> -					printk(", irq=%u", irq);
> +					printk(KERN_INFO ", irq=%u", irq);

This should be KERN_CONT.

>  				}
>  			}
>  		}
> @@ -1883,7 +1883,7 @@ no_dma:
>  		if (check_single_ended(dev->iobase)) {
>  			s->n_chan = this_board->n_aichan_se;
>  			s->subdev_flags |= SDF_COMMON | SDF_GROUND;
> -			printk(", %dchans S.E. DAC", s->n_chan);
> +			printk(KERN_INFO ", %dchans S.E. DAC", s->n_chan);

Ditto.

>  		} else {
>  			s->n_chan = this_board->n_aichan_diff;
>  			s->subdev_flags |= SDF_DIFF;
> -- 
> 1.6.5.2
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
> 
