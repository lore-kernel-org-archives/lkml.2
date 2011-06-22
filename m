Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab1FVBYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:24:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab1FVBYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HkiAn622IVg256eJOxueQF8ELiGSwnkEccEnEsRZrzfaMwbfQg1jkCsQ6EjHJ7wfYt
         yDnkxlEaii/acummbPAQ==
Date: Tue, 21 Jun 2011 18:23:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Amerigo Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: improve THP printk messages
In-Reply-To: <1308643849-3325-3-git-send-email-amwang@redhat.com>
Message-ID: <alpine.DEB.2.00.1106211823310.5205@chino.kir.corp.google.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-3-git-send-email-amwang@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, Amerigo Wang wrote:

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 126c96b..f9e720c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -506,7 +506,7 @@ static int __init hugepage_init(void)
>  	if (no_hugepage_init) {
>  		err = 0;
>  		transparent_hugepage_flags = 0;
> -		printk(KERN_INFO "hugepage: totally disabled\n");
> +		printk(KERN_INFO "THP: totally disabled\n");
>  		goto out;
>  	}
>  
> @@ -514,19 +514,19 @@ static int __init hugepage_init(void)
>  	err = -ENOMEM;
>  	hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>  	if (unlikely(!hugepage_kobj)) {
> -		printk(KERN_ERR "hugepage: failed kobject create\n");
> +		printk(KERN_ERR "THP: failed kobject create\n");
>  		goto out;
>  	}
>  
>  	err = sysfs_create_group(hugepage_kobj, &hugepage_attr_group);
>  	if (err) {
> -		printk(KERN_ERR "hugepage: failed register hugeage group\n");
> +		printk(KERN_ERR "THP: failed register hugeage group\n");
>  		goto out;
>  	}
>  
>  	err = sysfs_create_group(hugepage_kobj, &khugepaged_attr_group);
>  	if (err) {
> -		printk(KERN_ERR "hugepage: failed register hugeage group\n");
> +		printk(KERN_ERR "THP: failed register hugeage group\n");
>  		goto out;
>  	}
>  #endif

You're changing a printk() but not fixing the typos in it?
