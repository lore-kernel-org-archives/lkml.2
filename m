Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1HYXuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:50:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1HYXuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:50:10 -0400
Date: Thu, 25 Aug 2011 16:50:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Neaten warn_alloc_failed
Message-Id: <20110825165006.af771ef7.akpm@linux-foundation.org>
In-Reply-To: <5a0bef0143ed2b3176917fdc0ddd6a47f4c79391.1314303846.git.joe@perches.com>
References: <5a0bef0143ed2b3176917fdc0ddd6a47f4c79391.1314303846.git.joe@perches.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 13:26:19 -0700
Joe Perches <joe@perches.com> wrote:

> Add __attribute__((format (printf...) to the function
> to validate format and arguments.  Use vsprintf extension
> %pV to avoid any possible message interleaving. Coalesce
> format string.  Convert printks/pr_warning to pr_warn.
> 
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1334,7 +1334,8 @@ extern void si_meminfo(struct sysinfo * val);
>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>  extern int after_bootmem;
>  
> -extern void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
> +extern __attribute__((format (printf, 3, 4)))
> +void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
>  
>  extern void setup_per_cpu_pageset(void);
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c

looky:

--- a/include/linux/mm.h~mm-neaten-warn_alloc_failed-fix
+++ a/include/linux/mm.h
@@ -1335,7 +1335,7 @@ extern void si_meminfo(struct sysinfo * 
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
 
-extern __attribute__((format (printf, 3, 4)))
+extern __printf(3, 4)
 void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
_

