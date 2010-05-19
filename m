Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0ESFos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:44:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64799 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0ESFor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kAGp6U5OM5TXS0XB5mYN7MN2SlMHFfB5UO/YpROe4UFopGLIyohKREJ5EEwkI4EdEN
         w9RoKtBZRXwXy3hEs7AEuy3UCVcGTcDi5EFB8LJtt2teUoSUE15Y335yLmjOPmCr1YTJ
         YJLIO9jlyPxfg2PMzEAr7bu+sdIW29teUpmBE=
MIME-Version: 1.0
In-Reply-To: <20100518.142021.135951273.davem@davemloft.net>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
Date: Wed, 19 May 2010 08:44:43 +0300
X-Google-Sender-Auth: GJ2TIaXuMKQmSt97B9E44YF261M
Message-ID: <AANLkTimjyRdzK3gXptoheWQGEdzdQlJjSdpCTXSbGseV@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, herbert@gondor.hengli.com.au, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, May 19, 2010 at 12:20 AM, David Miller <davem@davemloft.net> wrote:
>> Why? It doesn't make much sense for SLOB, which tries to be as space
>> efficient as possible, as a default. If things break on sparc, it
>> really needs to set ARCH_KMALLOC_MINALIGN as slab default alignment is
>> not something you really want to depend on.
>
> I think it does make sense to expect that, whatever my architecture
> defines or does not define, I can expect the allocators to provide the
> same minimum alignment guarentee.  Otherwise it is no guarantee at all.

They're not a guarantee, the default values are just "oh, you don't
care about alignment, let me provide one for you".

> I'll add the define for sparc, but saying "sparc's fault" is bogus
> because I defined what was necessary to get SLAB/SLUB to provide the
> necessary alignment.  SLOB pays for choosing not to use the same
> calculations for minimum alignment as the other allocators, and
> therefore pays for being different in this regard.
>
> And in fact I do know that the ifdef'ery in SLAB/SLUB is derived from
> a change long ago that was specifically added to handle platforms like
> sparc.
>
> So one of two things should happen:
>
> 1) SLOB conforms to SLAB/SLUB in it's test
>
> 2) SLAB/SLUB conforms to SLOB in it's test
>
> And yes this is an either-or, you can't say they are both valid.

I don't agree with that. The default values are subject to change and
as pointed out by Paul, they have done so in the past. If you
architecture has alignment requirements for _correctness_ you
absolutely need to define ARCH_KMALLOC_MINALIGN.

                         Pekka
