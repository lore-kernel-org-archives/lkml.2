Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2BCHJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:09:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54593 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2BCHJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:09:18 -0500
MIME-Version: 1.0
In-Reply-To: <4F2B02BC.8010308@gmail.com>
References: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
	<1326776095-2629-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<CAAHN_R2g9zaujw30+zLf91AGDHNqE6HDc8Z4yJbrzgJcJYFkXg@mail.gmail.com>
	<4F2B02BC.8010308@gmail.com>
Date: Fri, 3 Feb 2012 12:39:17 +0530
Message-ID: <CAAHN_R0O7a+RX7BDfas3+vC+mnQpp0h3y4bBa1u4T-Jt=S9J_w@mail.gmail.com>
Subject: Re: [RESEND][PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 3:10 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>>  extern unsigned long move_page_tables(struct vm_area_struct *vma,
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 3f758c7..2f9f540 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -992,6 +992,9 @@ unsigned long do_mmap_pgoff(struct file *file,
>> unsigned long addr,
>>        vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
>>                        mm->def_flags | VM_MAYREAD | VM_MAYWRITE |
>> VM_MAYEXEC;
>>
>> +       if (flags&  MAP_STACK)
>> +               vm_flags |= VM_STACK_FLAGS;
>
>
> ??
> MAP_STACK doesn't mean auto stack expansion. Why do you turn on
> VM_GROWSDOWN?
> Seems incorrect.
>

Right now MAP_STACK does not mean anything since it is ignored. The
intention of this behaviour change is to make MAP_STACK mean that the
map is going to be used as a stack and hence, set it up like a stack
ought to be. I could not really think of a valid case for fixed size
stacks; it looks like a limitation in the pthread implementation in
glibc rather than a feature. So this patch will actually result in
uniform behaviour across threads when it comes to stacks.

This does change vm accounting since thread stacks were earlier
accounted as anon memory.

-- 
Siddhesh Poyarekar
http://siddhesh.in
