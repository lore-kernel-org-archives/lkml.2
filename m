Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2BBVkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:40:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53605 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab2BBVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:40:16 -0500
Message-ID: <4F2B02BC.8010308@gmail.com>
Date: Thu, 02 Feb 2012 16:40:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
CC: Jamie Lokier <jamie@shareable.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Subject: Re: [RESEND][PATCH] Mark thread stack correctly in proc/<pid>/maps
References: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk> <1326776095-2629-1-git-send-email-siddhesh.poyarekar@gmail.com> <CAAHN_R2g9zaujw30+zLf91AGDHNqE6HDc8Z4yJbrzgJcJYFkXg@mail.gmail.com>
In-Reply-To: <CAAHN_R2g9zaujw30+zLf91AGDHNqE6HDc8Z4yJbrzgJcJYFkXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   extern unsigned long move_page_tables(struct vm_area_struct *vma,
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 3f758c7..2f9f540 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -992,6 +992,9 @@ unsigned long do_mmap_pgoff(struct file *file,
> unsigned long addr,
>         vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
>                         mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
>
> +       if (flags&  MAP_STACK)
> +               vm_flags |= VM_STACK_FLAGS;

??
MAP_STACK doesn't mean auto stack expansion. Why do you turn on VM_GROWSDOWN?
Seems incorrect.

