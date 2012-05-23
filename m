Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2EWFpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:45:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38307 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab2EWFpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:45:05 -0400
Date: Wed, 23 May 2012 08:48:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Message-ID: <20120523054849.GK4637@mwanda>
References: <201205221820.10770.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205221820.10770.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 06:20:10PM -0700, H Hartley Sweeten wrote:
> The 'thisboard' macro depends on having a local variable with
> a magic name. The CodingStyle document suggests not doing this
> to avoid confusion. Remove the macro and use the comedi_board()
> inline helper to get the dev->board_ptr information.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Mori Hess <fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> @@ -769,13 +765,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	}
>  	***/
>  
> -/*
> - * Initialize dev->board_name.  Note that we can use the "thisboard"
> - * macro now, since we just initialized it in the last line.
> - */
> -	dev->board_ptr = &s526_boards[0];

Was this intended?  Most of the boards have auto probing so the
->board_ptr gets set automatically.  We already called
comedi_board() so I wonder if the autoprobed board is the same as
the &s526_boards[0];?  NULL pointer perhaps?  I don't know.

> -
> -	dev->board_name = thisboard->name;
> +	dev->board_name = board->name;
>  
>  /*
>   * Allocate the private structure area.  alloc_private() is a

regards,
dan carpenter
