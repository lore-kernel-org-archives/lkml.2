Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936955Ab0COWNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:13:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936904Ab0COWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:13:32 -0400
Date: Mon, 15 Mar 2010 15:13:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: linux-kernel@vger.kernel.org, giometti@linux.it, vegard.nossum@gmail.com
Subject: Re: [PATCH] c2port: fix device_create() return value check
Message-Id: <20100315151318.641af1db.akpm@linux-foundation.org>
In-Reply-To: <1268324452-30589-1-git-send-email-ext-jani.1.nikula@nokia.com>
References: <1268324452-30589-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 18:20:52 +0200
Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> From: Jani Nikula <ext-jani.1.nikula@nokia.com>
> 
> Use IS_ERR() instead of comparing to NULL.
> 
> Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
> 
> ---
> 
> NOTE: I'm afraid I'm unable to test this; please consider this more a
> bug report than a complete patch.
> ---
>  drivers/misc/c2port/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
> index b5346b4..3276216 100644
> --- a/drivers/misc/c2port/core.c
> +++ b/drivers/misc/c2port/core.c
> @@ -912,7 +912,7 @@ struct c2port_device *c2port_device_register(char *name,
>  
>  	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
>  					"c2port%d", id);
> -	if (unlikely(!c2dev->dev)) {
> +	if (unlikely(IS_ERR(c2dev->dev))) {
>  		ret = -ENOMEM;
>  		goto error_device_create;
>  	}

It looks right to me.  Let's finish the job:

--- a/drivers/misc/c2port/core.c~c2port-fix-device_create-return-value-check-fix
+++ a/drivers/misc/c2port/core.c
@@ -913,7 +913,7 @@ struct c2port_device *c2port_device_regi
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 					"c2port%d", id);
 	if (unlikely(IS_ERR(c2dev->dev))) {
-		ret = -ENOMEM;
+		ret = PTR_ERR(c2dev->dev);
 		goto error_device_create;
 	}
 	dev_set_drvdata(c2dev->dev, c2dev);
_

