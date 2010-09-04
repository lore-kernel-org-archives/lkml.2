Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0IDGyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:54:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39923 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0IDGyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:54:53 -0400
Message-ID: <4C81ED2C.6000304@cs.helsinki.fi>
Date: Sat, 04 Sep 2010 09:54:36 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] percpu: use percpu allocator on UP too
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org> <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org> <4C8121BC.7040609@kernel.org>
In-Reply-To: <4C8121BC.7040609@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.9.2010 19.26, Tejun Heo wrote:
> On UP, percpu allocations were redirected to kmalloc.  This has the
> following problems.
>
> * For certain amount of allocations (determined by
>    PERCPU_DYNAMIC_EARLY_SLOTS and PERCPU_DYNAMIC_EARLY_SIZE), percpu
>    allocator can be used before the usual kernel memory allocator is
>    brought online.  On SMP, this is used to initialize the kernel
>    memory allocator.
>
> * percpu allocator honors alignment upto PAGE_SIZE but kmalloc()
>    doesn't.  For example, workqueue makes use of larger alignments for
>    cpu_workqueues.
>
> Currently, users of percpu allocators need to handle UP differently,
> which is somewhat fragile and ugly.  Other than small amount of
> memory, there isn't much to lose by enabling percpu allocator on UP.
> It can simply use kernel memory based chunk allocation which was added
> for SMP archs w/o MMUs.
>
> This patch removes mm/percpu_up.c, builds mm/percpu.c on UP too and
> makes UP build use percpu-km.  As percpu addresses and kernel
> addresses are always identity mapped and static percpu variables don't
> need any special treatment, nothing is arch dependent and mm/percpu.c
> implements generic setup_per_cpu_areas() for UP.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Christoph Lameter<cl@linux-foundation.org>
> Cc: Pekka Enberg<penberg@cs.helsinki.fi>

Acked-by: Pekka Enberg <penberg@kernel.org>

Is this going into some public append-only branch I could cherry-pick 
the changeset from to my 'slub/cleanups' branch?

			Pekka
