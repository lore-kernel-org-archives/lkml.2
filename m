Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab1DYTGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:06:21 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:21106 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758203Ab1DYTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:06:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 301KiroVM1mSRlbtIYQumqDvku6NiwtqF1SDxeH2brerFEO
 jeMy6cTlfQOJvJkZhrv37ukQKPtOHfgIpPB9Ua9bT9CXGhupS73553Mg6P8H
 GZRY_7Kwp768QlDMssKNfyC5kDov4MuJKV8mqXKfoQB0QIFqeY8ABJ_S8hxz
 zkZLBP8OBonku1Q9BC1Gkb6iuOalv4o0dBmKUfRT1a87o.0vaDp_uBGcfO_g
 R14vzY6dIgQVYmHJSB027SPcBphMR9WQYwtz3Y07JOKMWmK1AC80cqrv7cMu
 6KRfAB773IuDwwLzdx5F8wgltwLxIF1bO3HeEXfkmKpi1vF8eS78ZT3d1Y0W
 b3baXjcTgohGyx772B2m9PO4-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Apr 2011 14:06:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH 1/2] slub: Break out alloc_kmem_cache_cpus() from
 kmem_cache_open()
In-Reply-To: <1303753608-19248-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1104251405130.9646@router.home>
References: <1303753608-19248-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Pekka Enberg wrote:

> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2638,11 +2638,7 @@ static int kmem_cache_open(struct kmem_cache *s,
>  #endif
>  	if (!init_kmem_cache_nodes(s))
>  		goto error;
> -
> -	if (alloc_kmem_cache_cpus(s))
> -		return 1;
> -
> -	free_kmem_cache_nodes(s);

free_kmem_cache_nodes() shows up nowhere now. Memory leak?

