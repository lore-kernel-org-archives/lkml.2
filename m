Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab2EXWMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:12:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2EXWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:12:32 -0400
Date: Thu, 24 May 2012 15:12:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KyongHo <pullip.cho@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: mm: fix faulty initialization in vmalloc_init()
Message-Id: <20120524151231.e3a18ac5.akpm@linux-foundation.org>
In-Reply-To: <001c01cd3987$d1a71a50$74f54ef0$%cho@samsung.com>
References: <001c01cd3987$d1a71a50$74f54ef0$%cho@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 17:32:56 +0900
KyongHo <pullip.cho@samsung.com> wrote:

> vmalloc_init() adds 'vmap_area's for early 'vm_struct's.
> This patch fixes vmalloc_init() to correctly initialize
> vmap_area for the given vm_struct.
> 

<daily message>
Insufficient information.  When fixing a bug please always always
always describe the user-visible effects of the bug.  Does the kernel
instantly crash?  Is it a comestic cleanliness thing which has no
effect?  Something in between?  I have simply no idea, and am dependent
upon you to tell me.

> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1185,9 +1185,10 @@ void __init vmalloc_init(void)
>  	/* Import existing vmlist entries. */
>  	for (tmp = vmlist; tmp; tmp = tmp->next) {
>  		va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
> -		va->flags = tmp->flags | VM_VM_AREA;
> +		va->flags = VM_VM_AREA;

This change is a mystery.  Why do we no longer transfer ->flags?

>  		va->va_start = (unsigned long)tmp->addr;
>  		va->va_end = va->va_start + tmp->size;
> +		va->vm = tmp;

OK, I can see how this might be important.  But why did you find it
necessary?  Why was this change actually needed?

>  		__insert_vmap_area(va);
>  	}

