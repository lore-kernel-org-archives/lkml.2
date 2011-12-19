Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1LSDAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 22:00:31 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51651 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LSDA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 22:00:28 -0500
Date: Mon, 19 Dec 2011 11:55:08 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        cgroups <cgroups@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -tip 0/3] sched: some fixes for vruntime calculation
 related to cgroup movement(v2)
Message-Id: <20111219115508.0d5bc98d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20111215143506.335e443e.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	<20111215143506.335e443e.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone who have comments ?
If there are some problems that prevent these patches from being accepted,
I'll fix them.

Thanks,
Daisuke Nishimura

On Thu, 15 Dec 2011 14:35:06 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi, all.
> 
> This is an updated version based on comments and rebased onto the -tip tree.
> 
> These patches fix problems I could see in 3.2-rc2 when testing frequent cgroup movement
> under very high load. Without these patches, some processes were not scheduled
> (although they were queued into rq)for a very long time(minutes or hours!),
> because vruntime of these processes were far bigger than min_vruntime.
> 
> Daisuke Nishimura (3):
>   sched: fix cgroup movement of newly created process
>   sched: fix cgroup movement of forking process
>   sched: fix cgroup movement of waking process
> 
>  kernel/sched/fair.c |   22 ++++++++++++++++++++--
>  1 files changed, 20 insertions(+), 2 deletions(-)
> 
> Thanks,
> Daisuke Nishimura.
