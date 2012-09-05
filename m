Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab2IEPe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:34:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49776 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2IEPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120904143215.5bbbb2a4@obelix.rh>
References: <20120904143215.5bbbb2a4@obelix.rh>
Date: Wed, 5 Sep 2012 23:34:25 +0800
Message-ID: <CAM_iQpVVCjJ0Bde9RS9Rm-0RJ=CtTyX3eUH45+oaaepvdAvAmQ@mail.gmail.com>
Subject: Re: kexec/kdump kernel fails to start
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Flavio Leitner <fbl@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 1:32 AM, Flavio Leitner <fbl@redhat.com> wrote:
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

There was some attempt to fix this:
https://patchwork.kernel.org/patch/1195751/

but for some reason it is not accepted.
