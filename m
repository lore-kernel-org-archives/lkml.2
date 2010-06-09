Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0FIXqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:46:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40324 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0FIXqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100609154409.bf024c0c.randy.dunlap@oracle.com>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au> 
	<20100609103657.66252a27.randy.dunlap@oracle.com> <20100609.110638.112605100.davem@davemloft.net> 
	<20100609154409.bf024c0c.randy.dunlap@oracle.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 9 Jun 2010 17:45:54 -0600
X-Google-Sender-Auth: doWRCf8TLwERktsnDFgA--5xfv8
Message-ID: <AANLkTikuIgeSMC5_IzAQGEQRso4udBvBGPcioAiArWb5@mail.gmail.com>
Subject: Re: [PATCH 2/2 -next] niu: always include of_device.h
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
       netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 4:44 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> The niu driver uses struct of_device when built on any arch, not
> only SPARC64, so always #include <linux/of_device.h>.
>
> drivers/net/niu.c:9700: warning: 'struct of_device' declared inside parameter list
> drivers/net/niu.c:9700: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/net/niu.c:9716: warning: assignment from incompatible pointer type
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:     Grant Likely <grant.likely@secretlab.ca>
> Cc:     Dave Miller <davem@davemloft.net>
> ---
>  drivers/net/niu.c |    3 ---

Looks okay to me (but I haven't build tested it yet).  The bulk of
of_device.h is compiled out when CONFIG_OF_DEVICE is not selected.

David, are you okay with me taking this via my tree as it depends on
Randy's other patch?

Thanks,
g.


>  1 file changed, 3 deletions(-)
>
> --- linux-next-20100609.orig/drivers/net/niu.c
> +++ linux-next-20100609/drivers/net/niu.c
> @@ -28,10 +28,7 @@
>  #include <linux/slab.h>
>
>  #include <linux/io.h>
> -
> -#ifdef CONFIG_SPARC64
>  #include <linux/of_device.h>
> -#endif
>
>  #include "niu.h"
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
