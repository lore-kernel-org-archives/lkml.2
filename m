Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0E0NPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:15:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:56262 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab0E0NPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dhOj/JV+++HwhYnU/OcvLJDefJ/kAMcpU3k1eMZs8sfq+GLylx+BjIF5mmmDURT1Xl
         Lrhfr5LSS2DKeFJMIzuvwo/1vE96J4ruYz5uFdR8ayLKaDT8YWd1WqXnxKi2tvl5oYJW
         tPFR3KlNn6Bxhp9aShAVnjcZivgewW8jjeHu8=
Date: Thu, 27 May 2010 15:15:39 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/11] drivers/usb/serial: Eliminate a NULL pointer
 dereference
Message-ID: <20100527131539.GA26198@localhost>
References: <Pine.LNX.4.64.1005271437200.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005271437200.5422@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia, 

On Thu, May 27, 2010 at 02:37:39PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The assignment seems completely unnecessary if mos7840_port is NULL.
> 
[...]
> ---
>  drivers/usb/serial/mos7840.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
> index f8424d1..585b7e6 100644
> --- a/drivers/usb/serial/mos7840.c
> +++ b/drivers/usb/serial/mos7840.c
> @@ -730,7 +730,6 @@ static void mos7840_bulk_in_callback(struct urb *urb)
>  	mos7840_port = urb->context;
>  	if (!mos7840_port) {
>  		dbg("%s", "NULL mos7840_port pointer");
> -		mos7840_port->read_urb_busy = false;
>  		return;
>  	}

I stumbled over this one a couple of weeks ago. There a patch sitting in
Greg's queue already:

	http://thread.gmane.org/gmane.linux.usb.general/31668

Thanks,
Johan
