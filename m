Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab1KVO5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:57:05 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:32096 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752838Ab1KVO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:57:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FOF6PsMVM1lkSmz_f8X7o5TdQwFdXLy4vTK8tbiZg9bsAR0
 YVIt1CHCKPVXoTPRJSG9_JvqpNSsClt5JmVejRMlrHbZD_rlkmj1xHgonfBB
 F5.TrA3aoV1GFh67c7vXa4XTZvCf0QcqU6Mimvmj8Z2wbJZXch6wNKENiyfI
 gf50uUZ4kNcV.1wE8DjENxPA4DSnz2Mm6AMw8lef8qZS59ZBoWC3b.L_VoxE
 7l4b4gfORj5U2CYI7cj.ZioomNN8aSl4Bbn5oNuKTLUX9DWdKWBJqlSpS8b1
 z6Gr7PntpJff32FCt0kGdd0jRIZ1WRba32gEUGaJ8GClRZLq1aF_.oGOvlOx
 2nzxF9LchgfSFyvhV6Uzvj3ylfxLbzXPhNNdsQRX83ZBd_gZsoVpybhEJuEa
 UPiQMwjoquHdbsuAVF.Kw
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 08:57:01 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: avoid potential NULL dereference or corruption
In-Reply-To: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111220855460.25785@router.home>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 7d2a996..e8e6714 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4436,29 +4436,33 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
>  		for_each_possible_cpu(cpu) {
>  			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
>  			struct page *page;
> +			int node;
>
> -			if (!c || c->node < 0)
> +			if (!c)
>  				continue;

Drop the check. c can never be NULL these days.

Otherwiswe it looks okay.

