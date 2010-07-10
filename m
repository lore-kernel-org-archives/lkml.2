Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0GJQty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 12:49:54 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51002 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab0GJQtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 12:49:53 -0400
Date: Sat, 10 Jul 2010 18:49:46 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Martin Enderleit <menderleit@gmail.com>
Cc: mdharm-usb@one-eyed-alien.net, gregkh@suse.de, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: storage: freecom: Fixed several coding style
 issues.
Message-ID: <20100710164946.GI17833@buzzloop.caiaq.de>
References: <1278773412-21989-1-git-send-email-menderleit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278773412-21989-1-git-send-email-menderleit@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 04:50:12PM +0200, Martin Enderleit wrote:
> Fixed several coding style issues in freecom.c.
> 
> Signed-off-by: Martin Enderleit <menderleit@gmail.com>
> ---
>  drivers/usb/storage/freecom.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
> index 54cc942..6542ca4 100644
> --- a/drivers/usb/storage/freecom.c
> +++ b/drivers/usb/storage/freecom.c
> @@ -269,7 +269,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
>  	/* The firmware will time-out commands after 20 seconds. Some commands
>  	 * can legitimately take longer than this, so we use a different
>  	 * command that only waits for the interrupt and then sends status,
> -	 * without having to send a new ATAPI command to the device. 
> +	 * without having to send a new ATAPI command to the device.
>  	 *
>  	 * NOTE: There is some indication that a data transfer after a timeout
>  	 * may not work, but that is a condition that should never happen.
> @@ -324,14 +324,14 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
>  
>  	/* Find the length we desire to read. */
>  	switch (srb->cmnd[0]) {
> -		case INQUIRY:
> -		case REQUEST_SENSE:		/* 16 or 18 bytes? spec says 18, lots of devices only have 16 */
> -		case MODE_SENSE:
> -		case MODE_SENSE_10:
> -			length = le16_to_cpu(fst->Count);
> -			break;
> -		default:
> -			length = scsi_bufflen(srb);
> +	case INQUIRY:
> +	case REQUEST_SENSE:	/* 16 or 18 bytes? spec says 18, lots of devices only have 16 */
> +	case MODE_SENSE:
> +	case MODE_SENSE_10:
> +		length = le16_to_cpu(fst->Count);
> +		break;
> +	default:
> +		length = scsi_bufflen(srb);
>  	}
>  
>  	/* verify that this amount is legal */
> @@ -414,7 +414,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
>  		/* should never hit here -- filtered in usb.c */
>  		US_DEBUGP ("freecom unimplemented direction: %d\n",
>  				us->srb->sc_data_direction);
> -		// Return fail, SCSI seems to handle this better.
> +		/* Return fail, SCSI seems to handle this better. */
>  		return USB_STOR_TRANSPORT_FAILED;
>  		break;

While at it, you can also remove this useless break;

Daniel
