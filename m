Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab1KGQNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:13:16 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46550 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1KGQNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:13:15 -0500
MIME-Version: 1.0
In-Reply-To: <20111107153220.GD3249@redhat.com>
References: <201111071221.35403.nai.xia@gmail.com>
	<20111107153220.GD3249@redhat.com>
Date: Tue, 8 Nov 2011 00:13:14 +0800
Message-ID: <CAPQyPG5bWCQ5TDau-s1DLv5zT0VN92+nv7+VHiPqgeGEum-f9w@mail.gmail.com>
Subject: Re: [PATCH] mremap: skip page table lookup for non-faulted anonymous VMAs
From: Nai Xia <nai.xia@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 11:32 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Mon, Nov 07, 2011 at 12:21:35PM +0800, Nai Xia wrote:
>> If an anonymous vma has not yet been faulted, move_page_tables() in move_vma()
>> is not necessary for it.
>
> I actually thought of adding that (in fact fork has it and it's more
> likely to be beneficial for fork than for mremap I suspect), but this
> adds a branch to the fast path for a case that shouldn't normally
> materialize. So I don't think it's worth adding it as I expect it to
> add overhead in average.
>

Well, it seems like I forgot to embrace it with unlikely(), with instr
prefetching  this line seems a trivial even for the average cases.

But in case it really materializes, it may avoid tedious page table
locking and pmd allocation and furthermore, a semantically
confusing operation of move_page_tables() on a same VMA.

Anyway, it's not a big deal, indeed. You are the maintainers,
it's left for you to decide.
