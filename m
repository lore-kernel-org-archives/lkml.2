Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0HQFvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:51:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44032 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0HQFvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ak0h6cbk5aXAxSbJHNdwcXpQDSkQGX81m+ys7Ce3ewMQStKXqe8ji6NTYGe4lnEAuf
         5F9urMJz6RMDrYn3LPPXDrW8CtF6OLRGHMckGV368+atrlsfoXPtbNHmSKEpxLbn7hDP
         F+srsOQ6aQ7EvcBNiBkJRyhwFXPAuqhthazew=
Date: Tue, 17 Aug 2010 13:56:05 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init/main.c: add __force markup when casts to a __user
 pointer
Message-ID: <20100817055605.GE5095@cr0.nay.redhat.com>
References: <1281865998-7784-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281865998-7784-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 06:53:18PM +0900, Namhyung Kim wrote:
>add __force markup when casts to a __user address space pointer. This removes
>following sparse warnings:
>
> init/main.c:900:23: warning: cast adds address space to expression (<asn:1>)
> init/main.c:913:25: warning: cast adds address space to expression (<asn:1>)
>
>Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

>---
> init/main.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/init/main.c b/init/main.c
>index b06b8f2..5a0be5c 100644
>--- a/init/main.c
>+++ b/init/main.c
>@@ -897,7 +897,7 @@ static int __init kernel_init(void * unused)
> 	do_basic_setup();
> 
> 	/* Open the /dev/console on the rootfs, this should never fail */
>-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
>+	if (sys_open((const char __user __force *) "/dev/console", O_RDWR, 0) < 0)
> 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
> 
> 	(void) sys_dup(0);
>@@ -910,7 +910,7 @@ static int __init kernel_init(void * unused)
> 	if (!ramdisk_execute_command)
> 		ramdisk_execute_command = "/init";
> 
>-	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
>+	if (sys_access((const char __user __force *) ramdisk_execute_command, 0) != 0) {
> 		ramdisk_execute_command = NULL;
> 		prepare_namespace();
> 	}
>-- 
>1.7.0.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
