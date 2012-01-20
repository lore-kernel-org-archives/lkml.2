Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2ATP1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:27:09 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:62996 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2ATP1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:27:07 -0500
MIME-Version: 1.0
In-Reply-To: <1327072528-8479-4-git-send-email-akinobu.mita@gmail.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
	<1327072528-8479-4-git-send-email-akinobu.mita@gmail.com>
Date: Sat, 21 Jan 2012 00:27:06 +0900
Message-ID: <CAC5umygu32iS=OaioHYaYtemt7uBOiW51ef7L5UhNPezf3JBsQ@mail.gmail.com>
Subject: Re: [PATCH] xen-blkfront: use bitmap_set() and bitmap_clear()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I used Jeremy Fitzhardinge's old email address...

2012/1/21 Akinobu Mita <akinobu.mita@gmail.com>:
> Use bitmap_set and bitmap_clear rather than modifying individual bits
> in a memory region.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Cc: Jeremy Fitzhardinge <jeremy@goop.org>

> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xensource.com
> Cc: virtualization@lists.linux-foundation.org
> ---
>  drivers/block/xen-blkfront.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 2f22874..619868d 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -43,6 +43,7 @@
>  #include <linux/slab.h>
>  #include <linux/mutex.h>
>  #include <linux/scatterlist.h>
> +#include <linux/bitmap.h>
>
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -177,8 +178,7 @@ static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
>
>        spin_lock(&minor_lock);
>        if (find_next_bit(minors, end, minor) >= end) {
> -               for (; minor < end; ++minor)
> -                       __set_bit(minor, minors);
> +               bitmap_set(minors, minor, nr);
>                rc = 0;
>        } else
>                rc = -EBUSY;
> @@ -193,8 +193,7 @@ static void xlbd_release_minors(unsigned int minor, unsigned int nr)
>
>        BUG_ON(end > nr_minors);
>        spin_lock(&minor_lock);
> -       for (; minor < end; ++minor)
> -               __clear_bit(minor, minors);
> +       bitmap_clear(minors,  minor, nr);
>        spin_unlock(&minor_lock);
>  }
>
> --
> 1.7.4.4
>
