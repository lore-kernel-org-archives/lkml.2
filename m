Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0CVLag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:30:36 -0400
Received: from ozlabs.org ([203.10.76.45]:59004 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0CVLaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:30:35 -0400
Date: Mon, 22 Mar 2010 22:30:26 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       benh@kernel.crashing.org, tglx@linutronix.de, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.c
Message-ID: <20100322113026.GA11526@brick.ozlabs.ibm.com>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
 <20100322092809.GA20607@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322092809.GA20607@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 10:28:09AM +0100, Ingo Molnar wrote:

> ( Cc:-ed Andrew and Linus as this is a general design/policy matter wrt. 
>   memory management. )

[snip]

> Please also realize the difficulties Yinghai has gone through already: 
> converting and generalizing _all_ of the x86 early allocation code to a more 
> generic core kernel approach, with essentially zero interest from _any_ 
> non-x86 person ...

It still seemed to have a lot that was x86-specific - in particular it
seemed to have a lot of code to cope with various mistakes that
firmware might have made in the memory map.  That adds code which is
basically just bloat on architectures where those problems don't
arise.

The fw_memmap.c code also still seemed to be tied to the x86 e820 data
structures and layouts.

> Those early_res patches were posted all over on lkml, it was literally 
> hundreds of difficult patches, and now, months down the line, after we've 
> tested and upstreamed it (with many nasty regressions fixed on x86 during the 
> development of it) you come with a rigid "do it some other way, convert all of 
> x86 over again or else" position.

Well I personally don't mind if x86 uses early_res or whatever other
code in arch/x86 to handle the problems that arise from deficient
firmware.  I just don't see any value in converting powerpc or sparc64
over to using ~2000 lines of early_res/fw_memmap code where the
existing ~500 lines of lmb code is working just fine.

And I don't see the point of moving the x86 e820 stuff into the kernel
directory.  Does any other platform use e820 tables?

> I really wish non-x86 architectures apprecitated (and helped) the core kernel 
> work x86 is doing, because it is subsidizing non-x86 architectures all the 
> time.

We do help with core kernel work.  Coping with deficient x86 firmware
doesn't really feel like core kernel work to me though.

Paul.
