Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317Ab2D0T3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:29:06 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48722 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022Ab2D0T3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:29:04 -0400
Date: Fri, 27 Apr 2012 12:29:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk
Subject: Re: [PATCH] staging: comedi: introduce 'comedi_get_board' helper
 function
Message-ID: <20120427192900.GA14158@kroah.com>
References: <201204271149.49035.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204271149.49035.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:49:48AM -0700, H Hartley Sweeten wrote:
> This helper function is used to fetch the comedi_device board_ptr
> which is used during the attach to pass board specific information
> to the comedi drivers.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Mori Hess <fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> 
> With this helper removing all the 'this_board' defines in the drivers
> will be easier (and cleaner).
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 300fd84..53a05dd 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -235,6 +235,11 @@ struct comedi_device {
>  	void (*close) (struct comedi_device *dev);
>  };
>  
> +static inline const void *comedi_get_board(struct comedi_device *dev)
> +{
> +	return dev->board_ptr;
> +}

"traditionally" the *get* functions increment a reference count of the
pointer it returns, which isn't happening here.

How about renaming this to just be comedi_board() instead?

thanks,

greg k-h
