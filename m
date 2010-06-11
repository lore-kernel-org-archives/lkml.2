Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0FKGlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:41:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1051 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab0FKGlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:41:45 -0400
Subject: Re: [PATCH] staging/wlags49_hs: Fix build error when CONFIG_SYSFS
 is not set
From: Joe Perches <joe@perches.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors <kernel-janitors@vger.kernel.org>
In-Reply-To: <1276238148.22216.30.camel@lenovo>
References: <1276238148.22216.30.camel@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 23:41:42 -0700
Message-ID: <1276238502.1556.512.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 02:35 -0400, Javier Martinez Canillas wrote:
> With current linux-next I got a build error with wlags49_h2 driver when CONFIG_SYSFS is not set.
> diff --git a/drivers/staging/wlags49_h2/wl_sysfs.h b/drivers/staging/wlags49_h2/wl_sysfs.h
> index 6d96d03..7d5895d 100644
> --- a/drivers/staging/wlags49_h2/wl_sysfs.h
> +++ b/drivers/staging/wlags49_h2/wl_sysfs.h
> @@ -2,6 +2,6 @@
>  extern void register_wlags_sysfs(struct net_device *);
>  extern void unregister_wlags_sysfs(struct net_device *);
>  #else
> -static void register_wlags_sysfs(struct net_device *) { return; };
> -static void unregister_wlags_sysfs(struct net_device *) { return; };
> +#define register_wlags_sysfs(net_device) { }
> +#define unregister_wlags_sysfs(net_device) { }
>  #endif

Yes, that works, but a better fix would be to remove the
semicolons after the function close braces.
---
diff --git a/drivers/staging/wlags49_h2/wl_sysfs.h
b/drivers/staging/wlags49_h2/wl_sysfs.h
index 6d96d03..7d5895d 100644
--- a/drivers/staging/wlags49_h2/wl_sysfs.h
+++ b/drivers/staging/wlags49_h2/wl_sysfs.h
@@ -2,6 +2,6 @@
 extern void register_wlags_sysfs(struct net_device *);
 extern void unregister_wlags_sysfs(struct net_device *);
 #else
-static void register_wlags_sysfs(struct net_device *) { return; };
-static void unregister_wlags_sysfs(struct net_device *) { return; };
+static void register_wlags_sysfs(struct net_device *) { return; }
+static void unregister_wlags_sysfs(struct net_device *) { return; }
 #endif


