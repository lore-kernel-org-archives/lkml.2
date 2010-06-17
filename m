Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab0FQUg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:36:59 -0400
Received: from kroah.org ([198.145.64.141]:57500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289Ab0FQUgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:36:50 -0400
Date: Thu, 17 Jun 2010 13:36:22 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, stewart_r@aliencamel.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix over 80 character coding style
 issues in ni_labpc.c
Message-ID: <20100617203622.GB32523@kroah.com>
References: <1275123944-1886-1-git-send-email-mauricedawson2699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275123944-1886-1-git-send-email-mauricedawson2699@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 10:05:44AM +0100, Maurice Dawson wrote:
> This is a patch to the ni_labpc.c file that fixes most over 80 character warnings found by the checkpatch.pl tool. Two lines, 4 and 1035 have not been changed because readability is better and no information is hidden
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_labpc.c |   81 ++++++++++++++++++++---------
>  1 files changed, 57 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
> index 67c8a53..bf063ad 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> @@ -738,7 +738,8 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  		break;
>  	case pcmcia_bustype:
>  		printk
> -		    (" this driver does not support pcmcia cards, use ni_labpc_cs.o\n");
> +		    ("this driver does not support pcmcia cards, "
> +							"use ni_labpc_cs.o\n");

Ick, no, don't break these types of strings.  Newer versions of
checkpatch will not complain about this.

>  	if (mode == MODE_SINGLE_CHAN_INTERVAL) {
>  		if (cmd->chanlist_len > 0xff) {
> -			comedi_error(dev,
> -				     "ni_labpc: chanlist too long for single channel interval mode\n");
> +			comedi_error(dev, "ni_labpc: chanlist too long "
> +							"for single channel "
> +							"interval mode\n");

Same here, don't do this.

>  			return 1;
>  		}
>  	}
> @@ -881,23 +883,29 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
>  		switch (mode) {
>  		case MODE_SINGLE_CHAN_INTERVAL:
>  			if (CR_CHAN(cmd->chanlist[i]) != channel) {
> -				comedi_error(dev,
> -					     "channel scanning order specified in chanlist is not supported by hardware.\n");
> +				comedi_error(dev, "channel scanning order "
> +							"specified in chanlist "
> +							"is not supported "
> +							"by hardware.\n");

Nor here.

>  				return 1;
>  			}
>  			break;
>  		case MODE_MULT_CHAN_UP:
>  			if (CR_CHAN(cmd->chanlist[i]) != i) {
> -				comedi_error(dev,
> -					     "channel scanning order specified in chanlist is not supported by hardware.\n");
> +				comedi_error(dev, "channel scanning order "
> +							"specified in chanlist "
> +							"is not supported "
> +							"by hardware.\n");

Or here.

>  				return 1;
>  			}
>  			break;
>  		case MODE_MULT_CHAN_DOWN:
>  			if (CR_CHAN(cmd->chanlist[i]) !=
>  			    cmd->chanlist_len - i - 1) {
> -				comedi_error(dev,
> -					     "channel scanning order specified in chanlist is not supported by hardware.\n");
> +				comedi_error(dev, "channel scanning order "
> +							"specified in chanlist "
> +							"is not supported "
> +							"by hardware.\n");

Or here, or the rest of the printk() lines.

Care to resend this without those types of changes?

thanks,

greg k-h
