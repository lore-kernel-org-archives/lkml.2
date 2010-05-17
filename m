Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0EQQRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:17:20 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38521 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0EQQRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NqTc3TaFc9MoBM30dU8P9Buwd+STLygL3bqFzQBhcptKX0HDKwCLRNnLK3YcZO5ZDz
         niEfJIyzf2eiTfl5vyLYc0Jo8dCM8w1OFtfgMBGk4P+T39eAdeVG/ooxrNZVXSROB+lu
         M+dYuVkpJYiDHFkcUkdIlAAFOVSEzZ53S46Fs=
MIME-Version: 1.0
In-Reply-To: <20100319003351.GC20227@gondor.apana.org.au>
References: <4B9E38AF.70309@fami-braun.de>
	 <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
	 <4BA29A19.2050307@fami-braun.de>
	 <20100319003351.GC20227@gondor.apana.org.au>
Date: Mon, 17 May 2010 18:17:14 +0200
X-Google-Sender-Auth: r_wxeK6O2vkRO-Bjix4idjKzajo
Message-ID: <AANLkTilPEnh3ewTb-KDsReBpjcszh1wkbfZohIaPXBKe@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: michael-dev@fami-braun.de, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 02:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Mar 18, 2010 at 10:24:41PM +0100, michael-dev@fami-braun.de wrote:
>>
>> Pekka Enberg schrieb:
>> > Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
>> > CONFIG_SLUB_DEBUG_ON?
>>
>> no, these options have not been / are not enabled.
>
> Can you please try it with those options enabled? That will tell
> us if there is some latent bug in the crypto layer that only shows
> up right away under SLOB.

After seeing a posting from Nemoto-san on the linux-mips list (should
show up soon on
http://www.linux-mips.org/archives/linux-mips/2010-05/threads.html),
I'm wondering if these defaults are the culprit;

mm/slab.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
mm/slob.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
mm/slub.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)

Note that some platforms override this.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
