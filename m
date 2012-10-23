Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2JWSrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:47:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40382 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2JWSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210231307440.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-10-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com>
	<CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
	<alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com>
	<CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com>
	<CAE9FiQWSb5D=DZRA6AceonMwBEjEgVEodvnC0aQwa4H3v+e_2A@mail.gmail.com>
	<alpine.DEB.2.02.1210231307440.2689@kaball.uk.xensource.com>
Date: Tue, 23 Oct 2012 11:47:48 -0700
X-Google-Sender-Auth: WyusQNL6H6J_suNNNPUXu18IjYs
Message-ID: <CAE9FiQXARsxX61htTrF5Z7EGRi2dANrUUOa4BqaQBVwbyaKcNw@mail.gmail.com>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 5:16 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 22 Oct 2012, Yinghai Lu wrote:
>> On Mon, Oct 22, 2012 at 11:17 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Mon, Oct 22, 2012 at 6:19 AM, Stefano Stabellini
>>
>> > How about put sth:
>> > ---
>> > Xen mmu requires pages from this function should be directly mapped already.
>> > ---
>> >
>> > or you can introduce some doc tag specially that we can out those
>> > assumption easily?
>>
>> I add
>>
>> /* Xen requires pages from this function should be directly mapped already */
>>
>> in   [PATCH] x86, mm: Add alloc_low_pages(num)
>>
>> hope you are happy with that.
>>
>
> It is not bad, but let's just fix the English a bit and give more
> context:
>
> /* Pages returned by this function are already directly mapped.
>  *
>  * Changing that is likely to break Xen, see commit
>  * 279b706bf800b5967037f492dbe4fc5081ad5d0f for more information on the
>  * subject.
>  */


I put your change in separate patch.

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=patch;h=bc6e8a77f049f3ecaad291329238367af044aa57

>From bc6e8a77f049f3ecaad291329238367af044aa57 Mon Sep 17 00:00:00 2001
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date: Tue, 23 Oct 2012 11:24:07 -0700
Subject: [PATCH] x86, mm: Add pointer about Xen mmu requirement for
 alloc_low_pages

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e98a4b8..88f90f7 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -25,6 +25,13 @@ unsigned long __meminitdata pgt_buf_top;

 static unsigned long min_pfn_mapped;

+/*
+ * Pages returned are already directly mapped.
+ *
+ * Changing that is likely to break Xen, see commit
+ * 279b706bf800b5967037f492dbe4fc5081ad5d0f for more information on the
+ * subject.
+ */
 __ref void *alloc_low_pages(unsigned int num)
 {
 	unsigned long pfn;
-- 
1.7.7.6
