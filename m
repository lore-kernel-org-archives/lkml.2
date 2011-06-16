Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab1FPVAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:00:44 -0400
Received: from claw.goop.org ([74.207.240.146]:36997 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab1FPVAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:00:44 -0400
Message-ID: <4DFA6EF7.9060702@goop.org>
Date: Thu, 16 Jun 2011 14:00:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: Re: [PATCH 09/11] xen/xenbus: use printk_ratelimited() instead of
 printk_ratelimit()
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de> <d2bc569719b3b1d8271d1f4b2c4080bbc7527e04.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
In-Reply-To: <d2bc569719b3b1d8271d1f4b2c4080bbc7527e04.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 05:14 AM, Manuel Zerpies wrote:
> Since printk_ratelimit() shouldn't be used anymore (see comment in
> include/linux/printk.h), replace it with printk_ratelimited()
>
Looks OK to me, but please fix the indentation of the rest of the
statement to match.

Thanks,
    J

> Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
> ---
>  drivers/xen/xenbus/xenbus_xs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index 5534690..4055858 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -44,6 +44,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/ratelimit.h>
>  #include <xen/xenbus.h>
>  #include "xenbus_comms.h"
>  
> @@ -270,8 +271,7 @@ static void *xs_talkv(struct xenbus_transaction t,
>  	}
>  
>  	if (msg.type != type) {
> -		if (printk_ratelimit())
> -			printk(KERN_WARNING
> +		`printk_ratelimited(KERN_WARNING
>  			       "XENBUS unexpected type [%d], expected [%d]\n",
>  			       msg.type, type);
>  		kfree(ret);

