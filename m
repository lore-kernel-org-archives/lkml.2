Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2CWVgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:36:14 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35162 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2CWVgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <1332228283-29077-1-git-send-email-m.szyprowski@samsung.com>
References: <1332228283-29077-1-git-send-email-m.szyprowski@samsung.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Mar 2012 14:35:48 -0700
X-Google-Sender-Auth: kSZ5nqSZH1I5cpZoP5ckbA_ybIQ
Message-ID: <CA+55aFy9oxMrfm-+deMqV=XnFOa98aKXqW+8PR-P-zOARtC2BQ@mail.gmail.com>
Subject: Re: [GIT PULL] DMA-mapping framework updates for 3.4
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        discuss@x86-64.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Jonathan Corbet <corbet@lwn.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:24 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
>  git://git.infradead.org/users/kmpark/linux-samsung dma-mapping-next
>
> Those patches introduce a new alloc method (with support for memory
> attributes) in dma_map_ops structure, which will later replace
> dma_alloc_coherent and dma_alloc_writecombine functions.

So I'm quite unhappy with these patches.

Here's just the few problems I saw from some *very* quick look-through
of the git tree:

 - I'm not seeing ack's from the architecture maintainers for the
patches that change some architecture.

 - Even more importantly, what I really want is acks and comments from
the people who are expected to *use* this.

 - it looks like patches break compilation half-way through the
series. Just one example I noticed: the "x86 adaptation" patch changes
the functions in lib/swiotlb.c, but afaik ia64 *also* uses those. So
now ia64 is broken until a couple of patches later. I suspect there
are other examples like that.

 - the sign-off chains are odd. What happened there? Several patches
are signed off by Kyungmin Park, but he doesn't seem to be "in the
chain" at all. Whazzup? (*)

(Btw, I notice the same thing in the tree I pulled from Dave Airlie,
btw - what the F is going on with samsung submissions - those are
marked as committed by Dave Airlie, and don't have Dave in the
sign-off chain at all!)

 - Finally, how/why are "dma attributes" different from the per-device
dma limits ("device_dma_parameters")

Hmm?

                  Linus

(*) Btw, I notice the same thing in the tree I pulled from Dave
Airlie, btw - what the F is going on with samsung submissions - those
are marked as committed by Dave Airlie, and don't have Dave in the
sign-off chain at all! Dave?
