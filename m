Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0JDFAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 01:00:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60268 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0JDFAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 01:00:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201010010519.o915Jv7v026590@www262.sakura.ne.jp>
References: <201010010229.o912T3rT089958@www262.sakura.ne.jp> <201010010519.o915Jv7v026590@www262.sakura.ne.jp>
Message-Id: <20101004135524.E8A5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  4 Oct 2010 13:59:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thus, TASK_SIZE == 0xC0000000.
> 
> fs/binfmt_elf.c:
>  77 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
>  78 
>  79 static int set_brk(unsigned long start, unsigned long end)
>  80 {
>  81         start = ELF_PAGEALIGN(start);
>  82         end = ELF_PAGEALIGN(end);
>  83         if (end > start) {
>  84                 unsigned long addr;
>  85                 down_write(&current->mm->mmap_sem);
>  86                 addr = do_brk(start, end - start);
>  87                 up_write(&current->mm->mmap_sem);
>  88                 if (BAD_ADDR(addr))
>  89                         return addr;
>  90         }
>  91         current->mm->start_brk = current->mm->brk = end;
>  92         return 0;
>  93 }
> 
> Thus, BAD_ADDR(x) is ((unsigned long)(x) >= 0xC0000000).


Can do_brk() return BAD_ADDR() _and_ !IS_ERR_VALUE() value? when?



