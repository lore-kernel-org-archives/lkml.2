Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0JSAGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:06:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62856 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0JSAGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:06:43 -0400
MIME-Version: 1.0
X-Originating-IP: [196.201.217.245]
In-Reply-To: <20101018233834.GC5370@nowhere>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
	<20101018233834.GC5370@nowhere>
Date: Tue, 19 Oct 2010 03:06:41 +0300
Message-ID: <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
From: Brian Gitonga Marete <marete@toshnix.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 2:38 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Oct 19, 2010 at 02:24:00AM +0300, Brian Gitonga Marete wrote:
>> The following patch fixes compilation of the perf user-space tools on,
>> for example, gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) . It should not
>> break anything else.
>
>
>
> Hi,
>
> What kind of warning have you encountered and why it fixes it?
> Can you describe that in your changelog?
>

Hello Frederic,

Some versions of gcc, e.g. gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4), have
the (default) minimum size of buffers protected by `-fstack-protector' set
to 8. But in perf, there exist much smaller automatic buffers.

This in combination with the -fstack-protector-all, -Werror and
-Wstack-protector causes the compile to fail for such a compiler.

The error encountered with the above-mentioned compiler is:

gcc -o util/ui/util.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6
-D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow
-Winit-self -Wpacked -Wredundant-decls -Wstack-protector
-Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers
-Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast
-Wmissing-declarations -Wmissing-prototypes -Wnested-externs
-Wold-style-definition -Wstrict-prototypes
-Wdeclaration-after-statement  -fstack-protector-all
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include
-Iarch/x86/include -DLIBELF_NO_MMAP -I/usr/include/elfutils
-DDWARF_SUPPORT -I/usr/include/slang -DSHA1_HEADER='<openssl/sha.h>'
util/ui/util.c
cc1: warnings being treated as errors
util/ui/util.c: In function ‘ui__dialog_yesno’:
util/ui/util.c:110: error: not protecting function: no buffer at least
8 bytes long

Signed-off-by: Brian Gitonga Marete <marete@toshnix.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1950e19..64eb2ea 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -288,7 +288,7 @@ endif
 -include feature-tests.mak

 ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
-	CFLAGS := $(CFLAGS) -fstack-protector-all
+	CFLAGS := $(CFLAGS) -fstack-protector-all --param ssp-buffer-size=1
 endif


-- 
1.6.0.4


-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
