Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2A3Vc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:32:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40914 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2A3Vcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:32:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1201242152480.1658@tux.localdomain>
References: <1324049134.25554.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.DEB.2.00.1112161030270.26651@router.home>
	<alpine.LFD.2.02.1201242152480.1658@tux.localdomain>
Date: Mon, 30 Jan 2012 22:32:53 +0100
X-Google-Sender-Auth: B0xRSK_5fdb7LIletvUuw8ZeQ6c
Message-ID: <CAMuHMdW-RbD-uxpOGmhv0LCsHLG-2Q0LvSRrB0cdM2efGRAYnw@mail.gmail.com>
Subject: Re: [PATCH] slub: prefetch next freelist pointer in slab_alloc()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, "Alex,Shi" <alex.shi@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Matt Mackall <mpm@selenic.com>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 20:54, Pekka Enberg <penberg@kernel.org> wrote:
> On Fri, 16 Dec 2011, Eric Dumazet wrote:
>>> Recycling a page is a problem, since freelist link chain is hot on
>>> cpu(s) which freed objects, and possibly very cold on cpu currently
>>> owning slab.
>
> On Fri, 16 Dec 2011, Christoph Lameter wrote:
>> Good idea. How do the tcp benchmarks look after this?
>>
>> Looks sane.
>>
>> Acked-by: Christoph Lameter <cl@linux.com>
>
> Applied, thanks!

m68k/allmodconfig at http://kisskb.ellerman.id.au/kisskb/buildresult/5527349/

mm/slub.c:274: error: implicit declaration of function 'prefetch'

Sorry, didn't notice it earlier due to other build breakage in -next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
