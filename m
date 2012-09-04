Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2IDUA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:00:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807Ab2IDUAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:00:24 -0400
Date: Tue, 4 Sep 2012 17:00:07 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kexec/kdump kernel fails to start
Message-ID: <20120904170007.5fa65d72@obelix.rh>
In-Reply-To: <CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
	<20120904161737.358d51ad@obelix.rh>
	<CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 12:20:14 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Sep 4, 2012 at 12:17 PM, Flavio Leitner <fbl@redhat.com> wrote:
> > On Tue, 4 Sep 2012 12:02:00 -0700
> > [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> > [    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
> > [    0.000000] initial memory mapped : 0 - 20000000
> > [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
> > [    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
> > [    0.000000]  0000000000 - 00bf800000 page 2M
> > [    0.000000] kernel direct mapping tables up to bf800000 @ 1fa00000-20000000
> > [    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
> > [    0.000000]  0100000000 - 0440000000 page 2M
> > [    0.000000] kernel direct mapping tables up to 440000000 @ bdaab000-bf4bd000
> > [    0.000000] RAMDISK: 352c8000 - 3695c000
> >

Alright, moving the extra accounting to be inside of CONFIG_X86_32 works out.

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..63e6a5c 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -60,10 +60,10 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
-#endif
 		/* The first 2/4M doesn't use large pages. */
 		if (mr->start < PMD_SIZE)
 			extra += mr->end - mr->start;
+#endif
 
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else

> BTW, can you please try our new init_memory_mapping clean up at
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm
> 
> hope it could make your kdump working.

I will give a try.
fbl

