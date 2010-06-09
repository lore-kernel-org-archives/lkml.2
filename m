Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0FIXsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:48:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63597 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0FIXsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:48:11 -0400
MIME-Version: 1.0
In-Reply-To: <20100609154405.20095178.randy.dunlap@oracle.com>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au> 
	<20100609103657.66252a27.randy.dunlap@oracle.com> <20100609.110638.112605100.davem@davemloft.net> 
	<20100609154405.20095178.randy.dunlap@oracle.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 9 Jun 2010 17:47:50 -0600
X-Google-Sender-Auth: OEHFgZy9SAotfrxhfnCpx1w8u8c
Message-ID: <AANLkTimEovLvQdvrzu37L8zFxZwvUDlGwtVhO4tR2Hwd@mail.gmail.com>
Subject: Re: [PATCH 1/2 -next] of_device.h: provide struct of_device even when 
	not enabled
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
> Drivers may use struct of_device (struct platform_device), even when
> CONFIG_OF_DEVICE is not enabled, so minimally provide that struct
> for that kconfig case.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:     Grant Likely <grant.likely@secretlab.ca>
> Cc:     Dave Miller <davem@davemloft.net>
> ---
>  include/linux/of_device.h |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- linux-next-20100609.orig/include/linux/of_device.h
> +++ linux-next-20100609/include/linux/of_device.h
> @@ -47,6 +47,10 @@ extern ssize_t of_device_get_modalias(st
>
>  extern int of_device_uevent(struct device *dev, struct kobj_uevent_env *env);
>
> +#else
> +
> +#include <linux/platform_device.h>
> +#define of_device platform_device

I should probably just move these 2 lines out of the #if/else/endif
block entirely.  I'll make that change and test it out.

g.
