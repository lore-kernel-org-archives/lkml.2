Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab2IDTCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:02:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59712 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2IDTCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120904143215.5bbbb2a4@obelix.rh>
References: <20120904143215.5bbbb2a4@obelix.rh>
Date: Tue, 4 Sep 2012 12:02:00 -0700
X-Google-Sender-Auth: XbGk6ncAUIhlHL6mA6odWWqD51c
Message-ID: <CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
Subject: Re: kexec/kdump kernel fails to start
From: Yinghai Lu <yinghai@kernel.org>
To: Flavio Leitner <fbl@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 10:32 AM, Flavio Leitner <fbl@redhat.com> wrote:
> Hi folks,
>
> I have system that no longer boots kdump kernel. Basically,
>
> # echo c > /proc/sysrq-trigger
>
> to dump a vmcore doesn't work. It just hangs after showing the usual
> panic messages. I've bisected the problem and the commit introducing
> the issue is the one below.
>
> Any idea?
>
> commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8
> Author: WANG Cong <xiyou.wangcong@gmail.com>  2012-03-05 20:05:13
> Committer: Ingo Molnar <mingo@elte.hu>  2012-03-06 05:38:26
> Parent: 550cf00dbc8ee402bef71628cb71246493dd4500 (Merge tag 'mmc-fixes-for-3.3' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
> Child:  a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f (x86, tlb: Switch cr3 in leave_mm() only when needed)
> Branches: master, remotes/origin/master
> Follows: v3.3-rc6
> Precedes: v3.5-rc1
>
>     x86/mm: Fix the size calculation of mapping tables
>
>     For machines that enable PSE, the first 2/4M memory region still uses
>     4K pages, so needs more PTEs in this case, but
>     find_early_table_space() doesn't count this.
>
>     This patch fixes it.
>
>     The bug was found via code review, no misbehavior of the kernel
>     was observed.

maybe just revert the offending commit?

Thanks

Yinghai
