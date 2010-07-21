Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab0GUXbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:31:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758800Ab0GUXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:31:39 -0400
Date: Wed, 21 Jul 2010 16:30:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: Question about binfmt_elf.c
Message-Id: <20100721163059.ffc5e70d.akpm@linux-foundation.org>
In-Reply-To: <201007161512.40388.rob@landley.net>
References: <201007161512.40388.rob@landley.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 15:12:39 -0500
Rob Landley <rob@landley.net> wrote:

> Could somebody please update this comment to explain why fiddling with 
> strangely protected bss is _not_ an easy way to leak arbitrary amounts of 
> uninitalized kernel memory (with whatever previous contents they have) to 
> userspace?
> 
>     nbyte = ELF_PAGEOFFSET(elf_bss);
>     if (nbyte) {
>             nbyte = ELF_MIN_ALIGN - nbyte;
>             if (nbyte > elf_brk - elf_bss)
>                         nbyte = elf_brk - elf_bss;
>             if (clear_user((void __user *)elf_bss +
>                                     load_bias, nbyte)) {
>                     /*
>                      * This bss-zeroing can fail if the ELF
>                      * file specifies odd protections. So
>                      * we don't check the return value
>                       */
>             }
>     }
> 
> Just curious.  Reading through the code and trying to understand it...
> 

In January 2005 davem added a check.  In Feb 2005 Pavel said "hey, my
Kylix application broke".  So we took the check out again.

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg60120.html
http://www.mail-archive.com/bk-commits-head@vger.kernel.org/msg01390.html

I don't kow how one would craft such an elf file.  I don't _think_ it
could leak unintialised memory, as we probably haven't faulted the page
in yet.  Perhaps a partial page could be exposed though.

Roland, Jakub: help!
