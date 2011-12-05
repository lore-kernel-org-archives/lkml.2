Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1LETZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:25:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40026 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab1LETZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:25:42 -0500
Date: Mon, 5 Dec 2011 14:27:03 -0500
From: Jeff Layton <jlayton@samba.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Use kcalloc instead of kzalloc to allocate array
Message-ID: <20111205142703.697a52c6@corrin.poochiereds.net>
In-Reply-To: <1322600880.1534.344.camel@localhost.localdomain>
References: <1322600880.1534.344.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 22:08:00 +0100
Thomas Meyer <thomas@m3y3r.de> wrote:

> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> --- a/fs/cifs/cifssmb.c 2011-11-13 11:07:56.343959560 +0100
> +++ b/fs/cifs/cifssmb.c 2011-11-28 19:47:15.006997976 +0100
> @@ -2140,7 +2140,7 @@ cifs_async_writev(struct cifs_writedata
>  		goto async_writev_out;
>  
>  	/* 1 iov per page + 1 for header */
> -	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
> +	iov = kcalloc(wdata->nr_pages + 1, sizeof(*iov), GFP_NOFS);
>  	if (iov == NULL) {
>  		rc = -ENOMEM;
>  		goto async_writev_out;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks correct.

Reviewed-by: Jeff Layton <jlayton@samba.org>
