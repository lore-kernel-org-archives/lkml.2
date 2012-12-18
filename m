Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2LRVkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:40:39 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36979 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab2LRVkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:40:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Youquan Song <youquan.song@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: glue: Update DBG macro to include KERN_DEBUG
Date: Tue, 18 Dec 2012 22:45:43 +0100
Message-ID: <2435631.Jtr8kfC3zi@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <95d86788536a6f095f261c051249ebd4f0e30a87.1355812070.git.joe@perches.com>
References: <1355851562-28407-1-git-send-email-youquan.song@intel.com> <95d86788536a6f095f261c051249ebd4f0e30a87.1355812070.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 17, 2012 10:31:30 PM Joe Perches wrote:
> Currently these DBG statements are emitted at KERN_DEFAULT.
> Change the macro to emit at KERN_DEBUG.
> 
> This can help avoid unexpected message interleaving.

Applied to linux-pm.git/linux-next as v3.8 material.

Thanks,
Rafael


> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Another way to fix this message interleaving...
> 
>  drivers/acpi/glue.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index 0155184..95af6f6 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -18,9 +18,14 @@
>  
>  #define ACPI_GLUE_DEBUG	0
>  #if ACPI_GLUE_DEBUG
> -#define DBG(x...) printk(PREFIX x)
> +#define DBG(fmt, ...)						\
> +	printk(KERN_DEBUG PREFIX fmt, ##__VA_ARGS__)
>  #else
> -#define DBG(x...) do { } while(0)
> +#define DBG(fmt, ...)						\
> +do {								\
> +	if (0)							\
> +		printk(KERN_DEBUG PREFIX fmt, ##__VA_ARGS__);	\
> +} while (0)
>  #endif
>  static LIST_HEAD(bus_type_list);
>  static DECLARE_RWSEM(bus_type_sem);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
