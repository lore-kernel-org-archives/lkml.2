Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0JYQbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:31:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33367 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0JYQbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tIL284KUxMAKGBl0UoM6VH617ZMEfshXKBQU/CoQvg9vDOX2urVDNvUvfYnVJrSZOy
         WQNBy03o6YrLORYTD8wrkwzoH+AAEfzFopatAlKNkOzIv4zh/r6jfAYNkxJPt4z2prbg
         V4N+a/48Nx/kxHAxMxWRGkh7K+HPQtOgA6yPM=
Subject: Re: [PATCH 2/3] sparc32: remove CONFIG_HAVE_PERF_EVENTS option
From: Namhyung Kim <namhyung@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101025.085937.226775583.davem@davemloft.net>
References: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
	 <1288021958-3130-2-git-send-email-namhyung@gmail.com>
	 <20101025.085937.226775583.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 01:31:19 +0900
Message-ID: <1288024279.1689.23.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-25 (월), 08:59 -0700, David Miller:
> From: Namhyung Kim <namhyung@gmail.com>
> Date: Tue, 26 Oct 2010 00:52:37 +0900
> 
> > Remove HAVE_PERF_EVENTS and PERF_USE_VMALLOC under config
> > SPARC because they're under SPARC64 too. Supporting
> > perf_event needs atomic64 operations but AFAIK sparc32
> > doesn't provide them, CMIIW. ;-) Also removes redundant
> > HAVE_IRQ_WORK line.
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> The generic non-hw perf event stuff builds fine on sparc32,
> please don't remove this unless you have a legitimate build
> failure to report and fix.
> 
> Even if sparc32 doesn't provide atomic64_t support, it very
> easily could do so using include/asm-generic/atomic64.h which
> implements them using spinlocks.

Now I see following build failure without this patch. Maybe some work is
needed to deal with atomic64_t. I'll try to prepare for it soon. Thanks.


  CC      arch/sparc/kernel/setup_32.o
In file included from arch/sparc/include/asm/local64.h:1:0,
                 from include/linux/perf_event.h:465,
                 from include/linux/ftrace_event.h:8,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:76,
                 from arch/sparc/kernel/setup_32.c:23:
include/asm-generic/local64.h:62:2: error: expected
                            specifier-qualifier-list before 'atomic64_t'
In file included from include/linux/ftrace_event.h:8:0,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:76,
                 from arch/sparc/kernel/setup_32.c:23:
include/linux/perf_event.h:722:2: error: expected
                            specifier-qualifier-list before 'atomic64_t'
include/linux/perf_event.h: In function 'perf_fetch_caller_regs':
include/linux/perf_event.h:1004:2: error: 'struct pt_regs' has no member
                                           named 'tstate'
include/linux/perf_event.h:1004:2: error: 'struct pt_regs' has no member
                                           named 'tpc'
include/linux/perf_event.h:1004:2: error: 'struct pt_regs' has no member
                                           named 'tnpc'
include/linux/perf_event.h:1004:2: error: 'struct pt_regs' has no member
                                           named 'tpc'
make[3]: *** [arch/sparc/kernel/setup_32.o] Error 1
make[2]: *** [arch/sparc/kernel] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2


-- 
Regards,
Namhyung Kim


