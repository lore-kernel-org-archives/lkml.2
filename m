Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2IMA25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:28:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63788 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab2IMA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+VMtUPuLHg3CwDxFm-TjbN1=YavGO79Oo3GuymOLvikeA@mail.gmail.com>
References: <CALF0-+VMtUPuLHg3CwDxFm-TjbN1=YavGO79Oo3GuymOLvikeA@mail.gmail.com>
Date: Wed, 12 Sep 2012 21:28:47 -0300
Message-ID: <CALF0-+W10VNUxm5oT+kmiSUwRqwdZhxgDu5jQjD5ao_w1b7dNA@mail.gmail.com>
Subject: Re: [PATCH v2 0/10] mm: SLxB cleaning and trace accuracy improvement
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: JoonSoo Kim <js1304@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Glauber Costa <glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Sat, Sep 8, 2012 at 5:49 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hi everyone,
>
> This is the second spin of my patchset to clean SLxB and improve kmem
> trace events accuracy.
>
> For this v2, the most relevant stuff is:
>
> I've dropped two patches that were not very well received:
> Namely this two are now gone:
>   mm, slob: Use only 'ret' variable for both slob object and returned pointer
>   mm, slob: Trace allocation failures consistently
> I believe consistency is important but perhaps this is just me being paranoid.
>
> There's a lot of dumb movement and renaming. This might seem stupid
> (and maybe it is) but it's necessary to create some common code between SLAB
> and SLUB, and then factor it out.
>
> Also, there's a patch to add a new option to disable gcc auto-inlining.
> I know we hate to add new options, but this is necessary to get
> accurate call site
> traces. Plus, the option is in "Kernel Hacking", so it's for kernel
> developers only.
>
> This work is part of CELF Workgroup Project:
> "Kernel_dynamic_memory_allocation_tracking_and_reduction" [1]
>
> Feedback, comments, suggestions are very welcome.
>
> Ezequiel Garcia (10):
>  mm: Factor SLAB and SLUB common code
>  mm, slub: Rename slab_alloc() -> slab_alloc_node() to match SLAB
>  mm, slab: Rename __cache_alloc() -> slab_alloc()
>  mm, slab: Match SLAB and SLUB kmem_cache_alloc_xxx_trace() prototype
>  mm, slab: Replace 'caller' type, void* -> unsigned long
>  mm, util: Use dup_user to duplicate user memory
>  mm, slob: Add support for kmalloc_track_caller()
>  mm, slab: Remove silly function slab_buffer_size()
>  mm, slob: Use NUMA_NO_NODE instead of -1
>  Makefile: Add option CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
>

Can you pick patches 2, 3, 4, and 5?
Namely only those related to SLOB and to simple cleanups.

I'll redo SLAB/SLUB commonization, as Christoph requested.

Thanks,
Ezequiel.
