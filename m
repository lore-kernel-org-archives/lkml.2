Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2JMMxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 08:53:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46268 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2JMMw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 08:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <20121011203421.12444.32871.stgit@gitlad.jf.intel.com>
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
	<20121011203421.12444.32871.stgit@gitlad.jf.intel.com>
Date: Sat, 13 Oct 2012 20:52:57 +0800
Message-ID: <CAJd=RBApQjWBA8w0y7_FhVAOoi17FO=UkCKQqnAX_vbFikkEVA@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] swiotlb: Make io_tlb_end a physical address
 instead of a virtual one
From: Hillf Danton <dhillf@gmail.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Fri, Oct 12, 2012 at 4:34 AM, Alexander Duyck
<alexander.h.duyck@intel.com> wrote:
> This change replaces all references to the virtual address for io_tlb_end
> with references to the physical address io_tlb_end.  The main advantage of
> replacing the virtual address with a physical address is that we can avoid
> having to do multiple translations from the virtual address to the physical
> one needed for testing an existing DMA address.
>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
>
>  lib/swiotlb.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index f114bf6..19aac9f 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -57,7 +57,8 @@ int swiotlb_force;
>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
>   * API.
>   */
> -static char *io_tlb_start, *io_tlb_end;
> +static char *io_tlb_start;
> +phys_addr_t io_tlb_end;

If add io_tlb_start_phy and io_tlb_end_phy, could we get same results
with less hunks?

Hillf
