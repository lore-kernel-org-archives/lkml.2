Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2FMUZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab2FMUZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:25:38 -0400
Message-ID: <4FD8F70F.7080405@redhat.com>
Date: Wed, 13 Jun 2012 16:24:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
 v2
References: <1339542816-21663-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1339542816-21663-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 07:13 PM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

> There was some desire in large applications using MAP_HUGETLB/SHM_HUGETLB
> to use 1GB huge pages on some mappings, and stay with 2MB on others. This
> is useful together with NUMA policy: use 2MB interleaving on some mappings,
> but 1GB on local mappings.
>
> This patch extends the IPC/SHM syscall interfaces slightly to allow specifying
> the page size.

This would also be useful for emulators such as qemu-kvm,
which want the guest memory to be 2MB aligned.

That would require extending mmap to specify the desired
alignment, which may be possible using the upper bits of
the mmap flags, like you did for the shm interface.

> +#define MAP_HUGE_2MB    (21<<  MAP_HUGE_SHIFT)
> +#define MAP_HUGE_1GB    (30<<  MAP_HUGE_SHIFT)

Nice idea, that way each architecture can define the
names for possible offsets, yet the numeric values
will always line up between all of them.

> + * Assume these are all power of twos.
> + * When 0 use the default page size.
> + */
> +#define SHM_HUGE_SHIFT  26
> +#define SHM_HUGE_MASK   0x3f
> +#define SHM_HUGE_2MB    (21<<  SHM_HUGE_SHIFT)
> +#define SHM_HUGE_1GB    (30<<  SHM_HUGE_SHIFT)
> +
> +#ifdef __KERNEL__

Excellent, this is very similar to what I was
thinking about implementing myself, in order
to pass "desired alignment" information to my
implementation of arch_get_unmapped_area(_topdown) :)


