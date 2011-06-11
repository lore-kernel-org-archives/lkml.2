Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1FKFsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 01:48:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58510 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1FKFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 01:48:49 -0400
Date: Fri, 10 Jun 2011 23:48:47 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-vr41xx: Convert use of struct resource to
 resource_size(ptr)
Message-ID: <20110611054847.GC16924@ponder.secretlab.ca>
References: <fb9fae86e3bc9f2d532cca7e513ac24229a67ceb.1307754917.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb9fae86e3bc9f2d532cca7e513ac24229a67ceb.1307754917.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 06:16:15PM -0700, Joe Perches wrote:
> Remove miscellaneous use of direct calculation by using resource_size().
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Merged, thanks.
g.

> ---
>  drivers/gpio/gpio-vr41xx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
> index a365be0..98723cb 100644
> --- a/drivers/gpio/gpio-vr41xx.c
> +++ b/drivers/gpio/gpio-vr41xx.c
> @@ -518,7 +518,7 @@ static int __devinit giu_probe(struct platform_device *pdev)
>  	if (!res)
>  		return -EBUSY;
>  
> -	giu_base = ioremap(res->start, res->end - res->start + 1);
> +	giu_base = ioremap(res->start, resource_size(res));
>  	if (!giu_base)
>  		return -ENOMEM;
>  
> -- 
> 1.7.6.rc1
> 
