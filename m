Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab1K2XAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:00:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34640 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab1K2XAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:00:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: Re: [PATCH] pm/next: Fix Build pm by ERR_PTR
Date: Wed, 30 Nov 2011 00:03:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1322542614-15856-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
In-Reply-To: <1322542614-15856-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111300003.20488.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 29, 2011, Nobuhiro Iwamatsu wrote:
> ERR_PTR needs linux/err.h.
> This add linux/err.h to linux/pm_domain.h.
> 
> -----
> In file included from drivers/sh/pm_runtime.c:15:
> include/linux/pm_domain.h: In function 'dev_to_genpd':
> include/linux/pm_domain.h:145: error: implicit declaration of function 'ERR_PTR'
> include/linux/pm_domain.h:145: warning: return makes pointer from integer without a cast
> In file included from include/linux/sh_clk.h:10,
> from drivers/sh/pm_runtime.c:19:
> include/linux/err.h: At top level:
> include/linux/err.h:22: error: conflicting types for 'ERR_PTR'
> include/linux/pm_domain.h:145: note: previous implicit declaration of 'ERR_PTR' was here
> make[2]: *** [drivers/sh/pm_runtime.o] Error 1
> make[1]: *** [drivers/sh] Error 2
> -----
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

I've just added an analogous patch from Guennadi to linux-pm/linux-next.

Thanks,
Rafael


> ---
>  include/linux/pm_domain.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
> index cc1a245..919bee1 100644
> --- a/include/linux/pm_domain.h
> +++ b/include/linux/pm_domain.h
> @@ -9,6 +9,7 @@
>  #ifndef _LINUX_PM_DOMAIN_H
>  #define _LINUX_PM_DOMAIN_H
>  
> +#include <linux/err.h>
>  #include <linux/device.h>
>  
>  enum gpd_status {
> 

