Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1BPNi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:38:59 -0500
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:46458 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751067Ab1BPNi5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:38:57 -0500
Subject: Re: [PATCH v2 1/2] USB: ffs-test: fix header path
From: Davidlohr Bueso <dave@gnu.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
In-Reply-To: <1297012413.2039.8.camel@offworld>
References: <1297012413.2039.8.camel@offworld>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 10:38:36 -0300
Message-ID: <1297863516.2184.1.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, just following up on this (ping) with the requested changes.

Thanks.

On Sun, 2011-02-06 at 14:13 -0300, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> When compiling this program the functionfs.h header cannot be found, producing:
> ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory
> 
> This patch also fixes the following warning:
> ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  tools/usb/ffs-test.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
> index bbe2e3a..f2c6524 100644
> --- a/tools/usb/ffs-test.c
> +++ b/tools/usb/ffs-test.c
> @@ -37,7 +37,7 @@
>  #include <sys/types.h>
>  #include <unistd.h>
>  
> -#include <linux/usb/functionfs.h>
> +#include "../../include/linux/usb/functionfs.h"
>  
> 
>  /******************** Little Endian Handling ********************************/
> @@ -450,7 +450,7 @@ invalid:
>  		    len, expected, *p);
>  		for (p = buf, len = 0; len < nbytes; ++p, ++len) {
>  			if (0 == (len % 32))
> -				fprintf(stderr, "%4d:", len);
> +				fprintf(stderr, "%4zd", len);
>  			fprintf(stderr, " %02x", *p);
>  			if (31 == (len % 32))
>  				fprintf(stderr, "\n");


