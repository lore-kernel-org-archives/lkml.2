Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199Ab2KNLw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:52:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52240 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139Ab2KNLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:52:26 -0500
Date: Wed, 14 Nov 2012 11:57:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: gregkh@linuxfoundation.org, wfp5p@virginia.edu, geert@linux-m68k.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: dgrp: dgrp_tty.c: return an -EFAULT if
 put_user fails
Message-ID: <20121114115735.19883baf@pyramind.ukuu.org.uk>
In-Reply-To: <1352874741-18526-1-git-send-email-gmate.amit@gmail.com>
References: <1352874741-18526-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 12:02:21 +0530
Kumar Amit Mehta <gmate.amit@gmail.com> wrote:

> This fix adds checks for inspecting the return value of put_user() and return
> -EFAULT on error.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  drivers/staging/dgrp/dgrp_tty.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
> index e125b03..b294197 100644
> --- a/drivers/staging/dgrp/dgrp_tty.c
> +++ b/drivers/staging/dgrp/dgrp_tty.c
> @@ -2265,7 +2265,8 @@ static int get_modem_info(struct ch_struct *ch, unsigned int *value)
>  		| ((mlast & DM_RI)  ? TIOCM_RNG : 0)
>  		| ((mlast & DM_DSR) ? TIOCM_DSR : 0)
>  		| ((mlast & DM_CTS) ? TIOCM_CTS : 0);
> -	put_user(mlast, (unsigned int __user *) value);
> +	if (put_user(mlast, (unsigned int __user *) value))
> +		return -EFAULT;


	return put_user(mlast, ....)

is shorter and neater and does the same thing.

Alan
