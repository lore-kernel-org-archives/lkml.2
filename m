Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0HDL5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:57:03 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48809 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab0HDL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:57:00 -0400
Date: Wed, 4 Aug 2010 13:56:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: missing .data.shared_align placement in vmlinux
Message-ID: <20100804115658.GA21357@merkur.ravnborg.org>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 04:58:53PM -0400, Mike Frysinger wrote:
> am i missing something or does the .data.shared_align section lack
> definition in vmlinux.lds.h and all arch vmlinux.lds.S files ?
> 
> with the recent change "net: remove time limit in process_backlog()",
> the softnet_data variable changed from "DEFINE_PER_CPU()" to
> "DEFINE_PER_CPU_ALIGNED()" which moved it from the .data section to
> the .data.shared_align section.  i'm not saying this patch is wrong,
> just that is what caused me to notice this larger problem.  no one
> else in the kernel is using this aligned macro variant, so i imagine
> that's why no one has noticed yet.
> 
> since .data.shared_align isnt declared in any vmlinux files that i can
> see, the linker just places it last.  this "just works" for most
> people, but when building a ROM kernel on Blackfin systems, it causes
> section overlap errors:
> bfin-uclinux-ld.real: section .init.data [00000000202e06b8 ->
> 00000000202e48b7] overlaps section .data.shared_aligned
> [00000000202e06b8 -> 00000000202e0723]
> i imagine other arches which support the ROM config option and thus do
> funky placement would see similar issues ...
> 
> on x86, it is stuck in a dedicated section:
>   [ 8] .data             PROGBITS        ffffffff810ec000 2ec000
> 0303a8 00  WA  0   0 4096
>   [ 9] .data.shared_alig PROGBITS        ffffffff8111c3c0 31c3c0
> 0000c8 00  WA  0   0 64
> 
> the ifdef forest in asm-generic/percpu.h is beyond a quick glance &
> fix, so i leave it up to someone else ;)

as there any resolution on this?
I briefly looked at it some time ago.
And it looks like a plain oversight.

But I was also a bit lost in the forest of ifdef land...

	Sam
