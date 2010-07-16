Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641Ab0GPNfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 09:35:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44861 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab0GPNfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 09:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Onl9lchUct3WRqXezecmW3hTevq7WJTaivG8OcQ8T0VYw2RK5FpOjzR8ArmxiP6e7i
         7IRl3kAvc2KOwR56gzgMIrna/S5ZACrTaWV2y5lxSP3KvBIqhxGU1Bt2HI9Ou/9yLdqc
         Xu2VqsBIQYyB/JJ2jWZ398rvoRGFQuQmlU110=
MIME-Version: 1.0
In-Reply-To: <19520.11654.346814.433232@pilspetsen.it.uu.se>
References: <AANLkTilDmFF4IN1Glo_Bv_-eBX1jcdi7JDToeIbvToC8@mail.gmail.com>
	<19520.11654.346814.433232@pilspetsen.it.uu.se>
Date: Fri, 16 Jul 2010 08:35:36 -0500
Message-ID: <AANLkTimsudVzj12-HuEKZyRVfR1yAcXvZhpf0cqokKRr@mail.gmail.com>
Subject: Re: anonymous mmap() and random heap allocation
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 4:59 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Xianghua Xiao writes:
>  > It seems mmap() can not do random allocation for malloc()/heap on
>  > Linux, anyone used pax's 'mmap randonness' option for that? what's the
>  > price for that?
>  >
>  > I want to port openbsd's malloc() to linux to avoid heap
>  > crashes(overrun/underrun), openbsd's malloc() can do random allocation
>  > for security reasons, meanwhile it helps to avoid some
>  > overrun/underrun crashes with no extra cost, the latter is what I'm
>  > looking for.
>
> You can implement this in user-space with existing kernel features.
> 1: place guard pages around mmap():ed data
> 2: parse /proc/self/maps and mmap(MAP_FIXED)
> 3: use a "safe" compiler or a dynamic binary instrumenter
> 4: use x86 segments (ugh!)
> 5: use a safe programming language
> ...
>

Mikael,
Thanks.
Forgot to mention this is a powerpc platform. This will be enhancement
to an existing system, i.e. language(mostly C) is already set.
Also, this is for runtime, placing guard pages around mmap() will slow
down the system dramatically.
I'm porting OpenBSD's malloc now. Even though linux's mmap(), unlike
OpenBSD, can not randomize its allocations(which offers free
overrun/underrun protections to some extent), however OpenBSD's malloc
does not put its control block on the heap, that's a plus at least.

What do you mean by 'safe' compiler, something like checkergcc? I
think checkergcc is obsolete now.

cheers,
xianghua
