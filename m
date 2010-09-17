Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0IQFcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:32:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58788 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0IQFcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XGgAjj6te5fs7rOtBzZsbt+xljUCZjTuJMG5QeVM1GoS5xYWMSgDUD2GfbDp8F/F7q
         VuDLSjrffohoD4r8pZicaJ6kGIWMxy4g/daxTnwgRrNdP++d20f7EC1EVt04935kP9q7
         Gwzeoow5H+Fqhd9rbLOloS/5KFaV5FX8ujUbw=
Subject: Re: [PATCH v3] drivers/net/tulip/de4x5.c: fix union member name in
 DE4X5_GET_REG ioctl
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: David Miller <davem@davemloft.net>, grundler@parisc-linux.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kyle@mcmartin.ca,
        jeffm@suse.com, security@kernel.org
In-Reply-To: <1284699944.2565.4.camel@dan>
References: <1284586998.6275.94.camel@dan>
	 <20100916.215313.180410528.davem@davemloft.net>
	 <1284699944.2565.4.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 07:31:55 +0200
Message-ID: <1284701515.4784.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 17 septembre 2010 à 01:05 -0400, Dan Rosenberg a écrit :
> Now with descriptive title, as requested.
> 
> This was previously reported as a security issue due to leakage of
> uninitialized stack memory.  Jeff Mahoney pointed out that this is
> incorrect since the copied data is from a union (rather than a struct).
> Therefore, this patch is only under consideration for the sake of
> correctness, and is not security relevant. 
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> Acked-by: Grant Grundler <grundler@parisc-linux.org>
> 
> --- linux-2.6.35.4.orig/drivers/net/tulip/de4x5.c       2010-08-26 19:47:12.000000000 -0400
> +++ linux-2.6.35.4/drivers/net/tulip/de4x5.c    2010-09-14 21:26:52.499474207 -0400
> @@ -5474,7 +5474,7 @@ de4x5_ioctl(struct net_device *dev, stru
>         tmp.lval[6] = inl(DE4X5_STRR); j+=4;
>         tmp.lval[7] = inl(DE4X5_SIGR); j+=4;
>         ioc->len = j;
> -       if (copy_to_user(ioc->data, tmp.addr, ioc->len)) return -EFAULT;
> +       if (copy_to_user(ioc->data, tmp.lval, ioc->len)) return -EFAULT;
>         break;
>  
>  #define DE4X5_DUMP              0x0f /* Dump the DE4X5 Status */
> 


While you are at it

	if (copy_to_user(ioc->data, tmp.lval, ioc->len))
		return -EFAULT;

Thanks


