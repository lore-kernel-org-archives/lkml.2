Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0JDDYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 23:24:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40027 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0JDDYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 23:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NMqHRXTr0ro78ur1bfBRlP938yCcbOa+at9H+mC3dhdkr2IEHKxjrI57+6/pL+ClmS
         0Igk0ij8X3lRXrYuuBmZ2/gKSmG7GrSsGM8uJrItW+MewWsMwQnvCGod9cRGFWtfeYUN
         QWF0I7qaY5Q6IhVFvcibXEB+uAr0l8lhaCD1c=
Date: Mon, 4 Oct 2010 11:29:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] alloc_large_system_hash printk overflow on 16TB boot.
Message-ID: <20101004032911.GD5189@cr0.nay.redhat.com>
References: <20101003132604.459149164@gulag1.americas.sgi.com>
 <20101003132612.011159635@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101003132612.011159635@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 08:26:05AM -0500, Robin Holt wrote:
>During boot of a 16TB system, the following is printed:
>Dentry cache hash table entries: -2147483648 (order: 22, 17179869184 bytes)
>
>Signed-off-by: Robin Holt <holt@sgi.com>
>To: Andrew Morton <akpm@linux-foundation.org>
>Cc: lkml <linux-kernel@vger.kernel.org>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.


>
>---
>
> mm/page_alloc.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>Index: pv1010934/mm/page_alloc.c
>===================================================================
>--- pv1010934.orig/mm/page_alloc.c	2010-10-01 10:27:07.000000000 -0500
>+++ pv1010934/mm/page_alloc.c	2010-10-03 07:53:13.551824924 -0500
>@@ -5182,9 +5182,9 @@ void *__init alloc_large_system_hash(con
> 	if (!table)
> 		panic("Failed to allocate %s hash table\n", tablename);
> 
>-	printk(KERN_INFO "%s hash table entries: %d (order: %d, %lu bytes)\n",
>+	printk(KERN_INFO "%s hash table entries: %ld (order: %d, %lu bytes)\n",
> 	       tablename,
>-	       (1U << log2qty),
>+	       (1UL << log2qty),
> 	       ilog2(size) - PAGE_SHIFT,
> 	       size);
> 
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
