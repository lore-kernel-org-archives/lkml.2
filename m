Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2GXPwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:52:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63338 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2GXPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:52:35 -0400
MIME-Version: 1.0
In-Reply-To: <5000259D.9020303@canonical.com>
References: <5000259D.9020303@canonical.com>
Date: Tue, 24 Jul 2012 23:52:34 +0800
Message-ID: <CAM_iQpVPzB69R1_4E_J5Yw=d1TncqHe0+dWEwOufQniNcpBVtg@mail.gmail.com>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 9:41 PM, Stefan Bader
<stefan.bader@canonical.com> wrote:
> I was bisecting a problem on 64bit where any attempt to cause a crash kernel to
> boot would hang. The bisect ended up on commit 722bc6b (x86/mm: Fix the size
> calculation of mapping tables) and somehow, looking at the calling function and
> the ranges printed on boot, I think the calculations should only be done in the
> 32bit case.
>
> On 64bit:
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x77e87fff]
> [    0.000000]  [mem 0x00000000-0x77dfffff] page 2M
> [    0.000000]  [mem 0x77e00000-0x77e87fff] page 4k
>
> Attached patch would fix this if you agree with it. Thanks.
>
> -Stefan
>
>
> From 6b679d1af20656929c0e829f29eed60b0a86a74f Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Fri, 13 Jul 2012 15:16:33 +0200
> Subject: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
>
> commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)
> did modify the extra space calculation for mapping tables in order
> to make up for the first 2/4M memory range using 4K pages.
> However this setup is only used when compiling for 32bit. On 64bit
> there is only the trailing area of 4K pages (which is already added).
>
> The code was already adapted once for things went wrong on a 8TB
> machine (bd2753b x86/mm: Only add extra pages count for the first memory
> range during pre-allocation early page table space), but it looks a bit
> like it currently would overdo things for 64bit.
> I only noticed while bisecting for the reason I could not make a crash
> kernel boot (which ended up on this patch).
>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> Cc: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Sorry for that I was not aware of x86_64 is different with x86 in the
first 2/4M.
