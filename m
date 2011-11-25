Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1KYJde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 04:33:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51490 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1KYJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 04:33:32 -0500
Date: Fri, 25 Nov 2011 09:33:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: fix compile error
Message-ID: <20111125093331.GP2203@ZenIV.linux.org.uk>
References: <1322169950-21630-1-git-send-email-arnd@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322169950-21630-1-git-send-email-arnd@arndnet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 10:25:50PM +0100, Arnd Hannemann wrote:
> Commit b46413367961c2e8bd827e067a231be982aaeee2 introduced the following compile error:
> 
>   CC      drivers/staging/iio/industrialio-core.o
> linux-2.6/drivers/staging/iio/industrialio-core.c: In function 'iio_event_getfd':
> linux-2.6/drivers/staging/iio/industrialio-core.c:262:32: error: 'ev_int' undeclared (first use in this function)
> linux-2.6/drivers/staging/iio/industrialio-core.c:262:32: note: each undeclared identifier is reported only once for each function it appears in
> 
> This patch fixes that.

Arrgh...  My fault, sorry.  Might be worth using the same local variable
for setting the bit as well...

Acked-by: Al Viro <viro@zeniv.linux.org.uk>

> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 2656409..a5b4a1f 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -243,6 +243,7 @@ static const struct file_operations iio_event_chrdev_fileops = {
>  static int iio_event_getfd(struct iio_dev *indio_dev)
>  {
>  	int fd;
> +	struct iio_event_interface *ev_int = indio_dev->event_interface;
>  
>  	if (indio_dev->event_interface == NULL)
>  		return -ENODEV;
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
