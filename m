Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab0JEGsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:48:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56049 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0JEGsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:48:10 -0400
X-Nat-Received: from [202.181.97.72]:50178 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1286261288.24245
Message-Id: <201010050648.o956m7r6094121@www262.sakura.ne.jp>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Oct 2010 15:48:07 +0900
References: <20101005102446.28C3.A69D9226@jp.fujitsu.com> <201010050224.o952Oaso040307@www262.sakura.ne.jp> <20101005121511.28D4.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101005121511.28D4.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 05102010 #4286695, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> > Thus, I think retval could be
> > ELF_PAGEALIGN(elf_bss + load_bias) if elf_bss + load_bias is bogus.
> 
> What's mean bogus?
> do_brk() call get_unmapped_area() and it check an argument is correctly
> unmapped and userland address. If elf_bss + load_bias point to invalid
> address, set_brk doesn't return elf_bss+load_bias.
> 
> 
> > I'm OK with this if it is guaranteed that elf_bss + load_bias is always valid
> > and set_brk() never returns ELF_PAGEALIGN(elf_bss + load_bias).
> 
> I think elf_bss + load_bias could be invalid (i.e. >TASK_SIZE). 
> but set_brk can detect it.
> 

Indeed. Then, we can replace BAD_ADDR() with IS_ERR_VALUE() as you proposed.



Well... who returns positive value when do_execve() succeeds? Nobody?
Then, I wonder why search_binary_handler() is designed to return positive value...
