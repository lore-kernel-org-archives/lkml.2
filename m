Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2HNBlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:41:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab2HNBk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:40:59 -0400
Message-ID: <5029AC92.2060408@redhat.com>
Date: Mon, 13 Aug 2012 22:40:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr> <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda> <501FD69D.7070702@metafoo.de> <alpine.DEB.2.02.1208101558100.2011@hadrien> <50295A43.30305@redhat.com> <alpine.DEB.2.02.1208132219060.2355@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1208132219060.2355@localhost6.localdomain6>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-08-2012 17:20, Julia Lawall escreveu:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Using devm_kzalloc simplifies the code and ensures that the use of
> devm_request_irq is safe.  When kzalloc and kfree were used, the interrupt
> could be triggered after the handler's data argument had been freed.
> 
> This also introduces some missing initializations of the return variable
> ret, and uses devm_request_and_ioremap instead of the combination of
> devm_request_mem_region and devm_ioremap.
> 
> The problem of a free after a devm_request_irq was found using the
> following semantic match (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression e1,e2,x,a,b,c,d;
> identifier free;
> position p1,p2;
> @@
> 
>   devm_request_irq@p1(e1,e2,...,x)
>   ... when any
>       when != e2 = a
>       when != x = b
>   if (...) {
>     ... when != e2 = c
>         when != x = d
>     free@p2(...,x,...);
>     ...
>     return ...;
>   }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> v3: due to a conflict with another patch

Not sure what tree you used for it, but the result was
worse ;)

patching file drivers/media/video/mx2_emmaprp.c
Hunk #1 FAILED at 896.
Hunk #2 FAILED at 904.
Hunk #3 FAILED at 946.
Hunk #4 FAILED at 993.
Hunk #5 FAILED at 1009.
5 out of 5 hunks FAILED -- rejects in file drivers/media/video/mx2_emmaprp.c

Well, I've massively applied hundreds of patches today, but not much
on this driver. Maybe it is better for you to wait for a couple of
days for these to be at -next, or use, instead, our tree as the basis for
it:
	git://linuxtv.org/media_tree.git staging/for_v3.7

Regards,
Mauro
