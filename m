Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1BYGUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:20:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47102 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1BYGUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:20:30 -0500
MIME-Version: 1.0
In-Reply-To: <20110224200631.0007833e@queued.net>
References: <20110224200631.0007833e@queued.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 24 Feb 2011 23:20:10 -0700
X-Google-Sender-Auth: IBiVg03bi1_AIPFoQ-nx4buZvZw
Message-ID: <AANLkTi=PpPKoHr1sOAwZZaFhVX9HOOqT7AYgY2QaX92O@mail.gmail.com>
Subject: Re: [PATCH] x86: OLPC: have prom_early_alloc BUG rather than return NULL
To: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 9:06 PM, Andres Salomon <dilinger@queued.net> wrote:
>
> ..similar to what sparc's prom_early_alloc does.
>
> Signed-off-by: Andres Salomon <dilinger@queued.net>

What the hey, I've picked this up since it makes the other patch
simpler.  I'll push the two patches to linux-next tomorrow and ask
Linus to pull in a few days.

g.

> ---
>  arch/x86/platform/olpc/olpc_dt.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
> index dab8746..044bda5 100644
> --- a/arch/x86/platform/olpc/olpc_dt.c
> +++ b/arch/x86/platform/olpc/olpc_dt.c
> @@ -140,8 +140,7 @@ void * __init prom_early_alloc(unsigned long size)
>                 * wasted bootmem) and hand off chunks of it to callers.
>                 */
>                res = alloc_bootmem(chunk_size);
> -               if (!res)
> -                       return NULL;
> +               BUG_ON(!res);
>                prom_early_allocated += chunk_size;
>                memset(res, 0, chunk_size);
>                free_mem = chunk_size;
> --
> 1.7.2.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
