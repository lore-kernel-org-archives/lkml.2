Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2C0VUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:20:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2C0VUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <1324643253-3024-6-git-send-email-m.szyprowski@samsung.com>
References: <1324643253-3024-1-git-send-email-m.szyprowski@samsung.com>
	<1324643253-3024-6-git-send-email-m.szyprowski@samsung.com>
Date: Tue, 27 Mar 2012 14:20:05 -0700
X-Google-Sender-Auth: f7E4OaokyPRw3lkbP3PGUjIEWjo
Message-ID: <CA+8MBbLAafFbVwviFmkjD0DNz5RsCbB_TNLL67wEi2k-hyXkXA@mail.gmail.com>
Subject: Re: [PATCH 05/14] IA64: adapt for dma_map_ops changes
From: Tony Luck <tony.luck@intel.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
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

On Fri, Dec 23, 2011 at 4:27 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>
> Adapt core IA64 architecture code for dma_map_ops changes: replace
> alloc/free_coherent with generic alloc/free methods.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/ia64/hp/common/sba_iommu.c     |   11 ++++++-----
>  arch/ia64/include/asm/dma-mapping.h |   18 ++++++++++++------
>  arch/ia64/kernel/pci-swiotlb.c      |    9 +++++----
>  arch/ia64/sn/pci/pci_dma.c          |    9 +++++----
>  4 files changed, 28 insertions(+), 19 deletions(-)

The series breaks bisection from part 2 (when the x86 part changes
lib/swiotlb.c)
until part 5 (when ia64 sees the changes to match).  You could either merge part
5 into part 2 (to make a combined x86+ia64 piece) ... or try to pull
the libswiotlb
changes into their own piece (which would have some of the ia64 and x86 bits).
Or at the very least minimize the breakage window by putting ia64
right after x86
in the patch sequence.

Otherwise seems OK

Acked-by: Tony Luck <tony.luck@intel.com>
