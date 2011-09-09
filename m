Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab1IIUqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:46:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42240 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759693Ab1IIUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:46:07 -0400
X-Sasl-enc: /pfGkHzxk5ME4DdR5p8fsqreouklZshdmhKxKmb7619X 1315601166
Date: Fri, 9 Sep 2011 13:25:06 -0700
From: Greg KH <greg@kroah.com>
To: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: fix printk issue in cb_pcidda.c
Message-ID: <20110909202506.GA3018@kroah.com>
References: <1314791612-2724-1-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314791612-2724-1-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 05:23:32PM +0530, Ravishankar K Mallikarjunayya wrote:
> This is a patch to the cb_pcidda.c file that fixes up a printk warning found by the checkpatch.pl tool

Please wrap your changelog comment at 72 columns, like sane people do.

> 
> Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/cb_pcidda.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
> index 49102b3..661e945 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidda.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidda.c
> @@ -282,7 +282,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
>  	struct pci_dev *pcidev = NULL;
>  	int index;
>  
> -	printk("comedi%d: cb_pcidda: ", dev->minor);
> +	pr_info("comedi%d: cb_pcidda: ", dev->minor);

If you have a device pointer, then use dev_info() here.

Same goes for the other changes in this series.  Use the proper dev_*
macros.

And what is up with your patch numbering scheme?  Please send me all of
the patches, not a bunch of [1/1] and the like, in one set, all linked
together properly like git-send-email will do.

greg k-h
