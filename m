Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab2LSGnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 01:43:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27817 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2LSGm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 01:42:57 -0500
Date: Wed, 19 Dec 2012 09:42:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: cleanup ring_sw.c
Message-ID: <20121219064247.GL5032@mwanda>
References: <1355873999-32098-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355873999-32098-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 12:39:59AM +0100, Cong Ding wrote:
> clean the checkpatch warnings in ring_sw.c. mostly are 80 characters per line
> issue.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/staging/iio/ring_sw.c |   25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
> index 3a45f9a..4db1cc3 100644
> --- a/drivers/staging/iio/ring_sw.c
> +++ b/drivers/staging/iio/ring_sw.c
> @@ -77,7 +77,8 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
>  		 * as long as the read pointer is valid before this
>  		 * passes it - guaranteed as set later in this function.
>  		 */
> -		ring->half_p = ring->data - ring->buf.length*ring->buf.bytes_per_datum/2;
> +		ring->half_p = ring->data -
> +			ring->buf.length*ring->buf.bytes_per_datum/2;

Please put spaces around the '*' and '/' characters.
			ring->buf.length * ring->buf.bytes_per_datum / 2;

>  	}
>  	/* Copy data to where ever the current write pointer says */
>  	memcpy(ring->write_p, data, ring->buf.bytes_per_datum);
> @@ -112,8 +113,8 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
>  	else if (ring->write_p == ring->read_p) {
>  		change_test_ptr = ring->read_p;
>  		temp_ptr = change_test_ptr + ring->buf.bytes_per_datum;
> -		if (temp_ptr
> -		    == ring->data + ring->buf.length*ring->buf.bytes_per_datum) {
> +		if (temp_ptr == ring->data +
> +		    ring->buf.length*ring->buf.bytes_per_datum) {

This needs spaces as well.  It might look cleaner if you broke it
up like this:
		if (temp_ptr == ring->data + ring->buf.length *
				ring->buf.bytes_per_datum) {


>  			temp_ptr = ring->data;
>  		}
>  		/* We are moving pointer on one because the ring is full.  Any
> @@ -127,7 +128,8 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
>  	 * simultaneous read */
>  	/* Also need to use loop count to ensure this only happens once */
>  	ring->half_p += ring->buf.bytes_per_datum;
> -	if (ring->half_p == ring->data + ring->buf.length*ring->buf.bytes_per_datum)
> +	if (ring->half_p == ring->data +
> +			ring->buf.length*ring->buf.bytes_per_datum)

Same.

>  		ring->half_p = ring->data;
>  	if (ring->half_p == ring->read_p) {
>  		ring->buf.stufftoread = true;
> @@ -153,7 +155,8 @@ static int iio_read_first_n_sw_rb(struct iio_buffer *r,
>  	if (n % ring->buf.bytes_per_datum) {
>  		ret = -EINVAL;
>  		printk(KERN_INFO "Ring buffer read request not whole number of"
> -		       "samples: Request bytes %zd, Current bytes per datum %d\n",
> +		       "samples: Request bytes %zd, Current bytes per"
> +		       "datum %d\n",

No space between "of" and "samples" and also "per" and "datum".

The warning here is that the print should be on one line instead of
two.  But actually that is a decision for the maintainer.
Checkpatch.pl is not the king of us, we do not have to do what it
says.

>  		       n, ring->buf.bytes_per_datum);
>  		goto error_ret;
>  	}
> @@ -193,7 +196,8 @@ static int iio_read_first_n_sw_rb(struct iio_buffer *r,
>  	if (initial_write_p >= initial_read_p)
>  		data_available = initial_write_p - initial_read_p;
>  	else
> -		data_available = buffer_size - (initial_read_p - initial_write_p);
> +		data_available = buffer_size -
> +			(initial_read_p - initial_write_p);
>  
>  	if (data_available < bytes_to_rip)
>  		bytes_to_rip = data_available;
> @@ -201,7 +205,8 @@ static int iio_read_first_n_sw_rb(struct iio_buffer *r,
>  	if (initial_read_p + bytes_to_rip >= ring->data + buffer_size) {
>  		max_copied = ring->data + buffer_size - initial_read_p;
>  		memcpy(data, initial_read_p, max_copied);
> -		memcpy(data + max_copied, ring->data, bytes_to_rip - max_copied);
> +		memcpy(data + max_copied,
> +				ring->data, bytes_to_rip - max_copied);

Line it up like this:
		memcpy(data + max_copied, ring->data,
		       bytes_to_rip - max_copied);


[tab][tab][space][space][space][space][space][space][space]bytes_

regards,
dan carpenter

