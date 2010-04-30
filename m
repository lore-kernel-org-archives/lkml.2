Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab0D3STq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:19:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41528 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284Ab0D3STL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jFbo7hrDNr4Lz2g7RaaRpUnJh42uL/3ZIYPPZHia7wa7Yyl0BDcrhab9RHZMTUUPmu
         8nY4ujd8VwKZgKHVc5OLrnwzAKZQ9zw92WXzQJ9pO8MK8IeONLfPO7G+hOsEMFQwP7WG
         WbysR9ffeNPXdLtnqa4jgbJ8GgII/2Q9ufbaU=
MIME-Version: 1.0
In-Reply-To: <20100430100712.041f6fcc.randy.dunlap@oracle.com>
References: <20100430100712.041f6fcc.randy.dunlap@oracle.com>
Date: Fri, 30 Apr 2010 14:19:07 -0400
Message-ID: <s2o4f6ba3b1004301119hd275af8r6bd4fdd98b14168a@mail.gmail.com>
Subject: Re: [PATCH -next] staging/cxt1e1: use netdev_priv to fix build
From: Bob Beers <bob.beers@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 1:07 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix cxt1e1 build error:
> drivers/staging/cxt1e1/linux.c:1195: error: 'struct net_device' has no member named 'priv'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Bob Beers <bob.beers@gmail.com>

This is correct of course. If you need it ...

Acked-by: Bob Beers <bob.beers@gmail.com>

> ---
>  drivers/staging/cxt1e1/linux.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20100430.orig/drivers/staging/cxt1e1/linux.c
> +++ linux-next-20100430/drivers/staging/cxt1e1/linux.c
> @@ -1192,7 +1192,7 @@ c4_add_dev (hdw_info_t * hi, int brdno,
>                 hi->devname, irq1);
>         unregister_netdev (ndev);
>         free_irq (irq0, ndev);
> -        OS_kfree (ndev->priv);
> +        OS_kfree (netdev_priv(ndev));
>         OS_kfree (ndev);
>         error_flag = EIO;
>         return 0;
>
