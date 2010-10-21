Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab0JUKQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:16:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0JUKQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:16:23 -0400
Date: Thu, 21 Oct 2010 12:16:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, heukelum@fastmail.fm, tglx@linutronix.de,
        hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86, asm: Fix CFI macro invocations to deal with
 shortcomings in gas
Message-ID: <20101021101605.GA21465@elte.hu>
References: <4CBDBEBA020000780001E05A@vpn.id2.novell.com>
 <tip-3234282f33b29d349bcada40204fc7c8fda7fe72@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-3234282f33b29d349bcada40204fc7c8fda7fe72@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Jan Beulich <JBeulich@novell.com> wrote:

> Commit-ID:  3234282f33b29d349bcada40204fc7c8fda7fe72
> Gitweb:     http://git.kernel.org/tip/3234282f33b29d349bcada40204fc7c8fda7fe72
> Author:     Jan Beulich <JBeulich@novell.com>
> AuthorDate: Tue, 19 Oct 2010 14:52:26 +0100
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 19 Oct 2010 14:28:02 -0700
> 
> x86, asm: Fix CFI macro invocations to deal with shortcomings in gas

This commit broke the UML build (see the full error log below).

	Ingo

/home/mingo/tip/arch/um/os-Linux/irq.c: In function ‘os_waiting_for_events’:
/home/mingo/tip/arch/um/os-Linux/irq.c:35: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/irq.c: In function ‘os_free_irq_by_cb’:
/home/mingo/tip/arch/um/os-Linux/irq.c:94: error: expected ‘)’ before string constant
make[2]: *** [arch/um/os-Linux/irq.o] Error 1
make[2]: *** Waiting for unfinished jobs....
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘do_aio’:
/home/mingo/tip/arch/um/os-Linux/aio.c:93: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘aio_thread’:
/home/mingo/tip/arch/um/os-Linux/aio.c:116: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c:126: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘do_not_aio’:
/home/mingo/tip/arch/um/os-Linux/aio.c:156: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘not_aio_thread’:
/home/mingo/tip/arch/um/os-Linux/aio.c:183: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c:188: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c:199: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘init_aio_24’:
/home/mingo/tip/arch/um/os-Linux/aio.c:239: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘init_aio_26’:
/home/mingo/tip/arch/um/os-Linux/aio.c:252: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c:264: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘submit_aio_26’:
/home/mingo/tip/arch/um/os-Linux/aio.c:281: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/aio.c: In function ‘init_aio’:
/home/mingo/tip/arch/um/os-Linux/aio.c:332: error: expected ‘)’ before string constant
make[2]: *** [arch/um/os-Linux/aio.o] Error 1
/home/mingo/tip/arch/um/os-Linux/helper.c: In function ‘run_helper’:
/home/mingo/tip/arch/um/os-Linux/helper.c:57: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c:64: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c:79: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c:97: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c: In function ‘run_helper_thread’:
/home/mingo/tip/arch/um/os-Linux/helper.c:129: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c:137: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c:142: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c: In function ‘helper_wait’:
/home/mingo/tip/arch/um/os-Linux/helper.c:157: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/helper.c:161: error: expected ‘)’ before string constant
make[2]: *** [arch/um/os-Linux/helper.o] Error 1
/home/mingo/tip/arch/um/os-Linux/file.c: In function ‘os_file_size’:
/home/mingo/tip/arch/um/os-Linux/file.c:278: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c:290: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c:296: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c: In function ‘os_file_modtime’:
/home/mingo/tip/arch/um/os-Linux/file.c:316: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c: In function ‘os_pipe’:
/home/mingo/tip/arch/um/os-Linux/file.c:358: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c: In function ‘os_set_fd_async’:
/home/mingo/tip/arch/um/os-Linux/file.c:376: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c:384: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c: In function ‘os_rcv_fd’:
/home/mingo/tip/arch/um/os-Linux/file.c:492: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c:498: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c: In function ‘os_create_unix_socket’:
/home/mingo/tip/arch/um/os-Linux/file.c:518: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/os-Linux/file.c: In function ‘os_lock_file’:
/home/mingo/tip/arch/um/os-Linux/file.c:558: error: expected ‘)’ before string constant
make[2]: *** [arch/um/os-Linux/file.o] Error 1
/home/mingo/tip/arch/um/kernel/exec.c: In function ‘um_execve’:
/home/mingo/tip/arch/um/kernel/exec.c:69: warning: passing argument 2 of ‘execve1’ from incompatible pointer type
/home/mingo/tip/arch/um/kernel/exec.c:47: note: expected ‘const char * const*’ but argument is of type ‘char **’
/home/mingo/tip/arch/um/kernel/exec.c:69: warning: passing argument 3 of ‘execve1’ from incompatible pointer type
/home/mingo/tip/arch/um/kernel/exec.c:47: note: expected ‘const char * const*’ but argument is of type ‘char **’
/home/mingo/tip/arch/um/kernel/exec.c: In function ‘sys_execve’:
/home/mingo/tip/arch/um/kernel/exec.c:85: warning: passing argument 2 of ‘execve1’ from incompatible pointer type
/home/mingo/tip/arch/um/kernel/exec.c:47: note: expected ‘const char * const*’ but argument is of type ‘char **’
/home/mingo/tip/arch/um/kernel/exec.c:85: warning: passing argument 3 of ‘execve1’ from incompatible pointer type
/home/mingo/tip/arch/um/kernel/exec.c:47: note: expected ‘const char * const*’ but argument is of type ‘char **’
make[1]: *** [arch/um/os-Linux] Error 2
make[1]: *** Waiting for unfinished jobs....
/home/mingo/tip/arch/um/drivers/fd.c: In function ‘fd_init’:
/home/mingo/tip/arch/um/drivers/fd.c:31: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/drivers/fd.c:38: error: expected ‘)’ before string constant
/home/mingo/tip/arch/um/drivers/fd.c: In function ‘fd_close’:
/home/mingo/tip/arch/um/drivers/fd.c:81: error: expected ‘)’ before string constant
make[2]: *** [arch/um/drivers/fd.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/um/drivers] Error 2
/home/mingo/tip/kernel/irq/handle.c:432:3: warning: #warning __do_IRQ is deprecated. Please convert to proper flow handlers
make: *** [sub-make] Error 2
