Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab1FWQBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:01:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40562 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab1FWQBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hYh0G40mMYk5Yb7SqYktKrOavGNtZF4owaAmMnuMccaaNK+IWz5bVTtjxEyiwEFehE
         1dqPwpukw0jQq6txEBmZMxoy+sXIZMFfEfo5jnA0jyU7mey561gmdzEEVIpXA+h8+VaB
         M/m+6TqqPbKbQB5JDTdQqsA8bAi2E6fj7ZTVw=
MIME-Version: 1.0
In-Reply-To: <20110623114536.GA14011@linux-mips.org>
References: <20110623114536.GA14011@linux-mips.org>
Date: Thu, 23 Jun 2011 18:01:47 +0200
X-Google-Sender-Auth: kcLn_n0i-1kAVj79QiMBhOsQu4k
Message-ID: <BANLkTimR98qo5fjMRf-kZahcA=hE-E3+Hg@mail.gmail.com>
Subject: Re: [PATCH] STAGING: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-am33-list@redhat.com, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 13:45, Ralf Baechle <ralf@linux-mips.org> wrote:
> On architectures that don't define PAGE_KERNEL_NOCACHE, the Comedi driver turns
> into tragedy:
>
>  CC [M]  drivers/staging/comedi/drivers.o
> drivers/staging/comedi/drivers.c: In function ‘comedi_buf_alloc’:
> drivers/staging/comedi/drivers.c:505:41: error: ‘PAGE_KERNEL_NOCACHE’ undeclared (first use in this function)
> drivers/staging/comedi/drivers.c:505:41: note: each undeclared identifier is rep orted only once for each function it appears in
> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
>
> Restrict the driver to only those architectures that define PAGE_KERNEL_NOCACHE.
>
> PAGE_KERNEL_NOCACHE is a kludge - some system architectures such as SGI IP27
> are even uable to offer uncached operation - at least in the way an unwitting
> driver might assume.  I haven't looked in details how the driver is using
> the area vmaped with PAGE_KERNEL_NOCACHE but maybe doing it XFS-style using
> cached memory and the flush_kernel_vmap_range / invalidate_kernel_vmap_range
> APIs in conjunction with the DMA API is a practical alternative.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

If only to get m68k/allmodconfig going again (hmm, there's another
staging driver
preventing a green light).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
