Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0ERVPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:15:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56007 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0ERVPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=h43OyjOaSIr49ixrfGPm1ZPzPfnKpOm10vodrfZdenlfQMkOlBlDFt4TYfW6mHRyi9
         khSk21rJKo27XqM2IhJd434t23QTjTMY1wfNtAPpPslN2TM0wqkqLnWINRJQbt/JbiS5
         O2vYRRj55UxkURkZV6VACu+XQYMG4i0q1Nkow=
MIME-Version: 1.0
In-Reply-To: <20100518.135945.180391159.davem@davemloft.net>
References: <20100518102701.GA7293@gondor.apana.org.au>
	 <20100518.122512.73694279.davem@davemloft.net>
	 <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
Date: Wed, 19 May 2010 00:15:46 +0300
X-Google-Sender-Auth: kt_8Dx6jFsM6MYHAzv8-ucbsZSk
Message-ID: <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, herbert@gondor.hengli.com.au, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, May 18, 2010 at 11:59 PM, David Miller <davem@davemloft.net> wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Tue, 18 May 2010 14:33:55 -0500
>
>> SLOB honors ARCH_KMALLOC_MINALIGN. If your arch has alignment
>> requirements, I recommend you set it.
>
> I recommend that the alignment provided by the allocator is not
> determined by which allocator I happen to have enabled.
>
> The values and ifdef'ery should be identical in all of our
> allocators.

Why? It doesn't make much sense for SLOB, which tries to be as space
efficient as possible, as a default. If things break on sparc, it
really needs to set ARCH_KMALLOC_MINALIGN as slab default alignment is
not something you really want to depend on.

                        Pekka
