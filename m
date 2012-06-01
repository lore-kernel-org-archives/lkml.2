Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab2FANvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:51:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37364 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863Ab2FANvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:51:06 -0400
Date: Fri, 1 Jun 2012 10:50:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tool: build fix, remove duplicate declarations
Message-ID: <20120601135058.GC16429@infradead.org>
References: <1338352913-60483-1-git-send-email-dsahern@gmail.com>
 <4FC851AB.2090905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FC851AB.2090905@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 31, 2012 at 11:22:51PM -0600, David Ahern escreveu:
> Arnaldo:
> 
> On 5/29/12 10:41 PM, David Ahern wrote:
> >I'm sure I have some gremlins running around today, but I am
> >consistently hitting this compile failure on Fedora 14 and 16:
> >
> >In file included from util/sort.h:12:0,
> >                  from builtin-diff.c:15:
> >util/string.h:7:5: error: redundant redeclaration of ‘hex2u64’ [-Werror=redundant-decls]
> >util/symbol.h:32:5: note: previous declaration of ‘hex2u64’ was here
> >util/string.h:8:7: error: redundant redeclaration of ‘strxfrchar’ [-Werror=redundant-decls]
> >util/symbol.h:33:7: note: previous declaration of ‘strxfrchar’ was here
> >util/string.h:9:5: error: redundant redeclaration of ‘perf_atoll’ [-Werror=redundant-decls]
> >util/util.h:238:5: note: previous declaration of ‘perf_atoll’ was here
> >util/string.h:10:8: error: redundant redeclaration of ‘argv_split’ [-Werror=redundant-decls]
> >util/util.h:239:8: note: previous declaration of ‘argv_split’ was here
> >util/string.h:11:6: error: redundant redeclaration of ‘argv_free’ [-Werror=redundant-decls]
> >util/util.h:240:6: note: previous declaration of ‘argv_free’ was here
> >util/string.h:12:6: error: redundant redeclaration of ‘strglobmatch’ [-Werror=redundant-decls]
> >util/util.h:241:6: note: previous declaration of ‘strglobmatch’ was here
> >util/string.h:13:6: error: redundant redeclaration of ‘strlazymatch’ [-Werror=redundant-decls]
> >util/util.h:242:6: note: previous declaration of ‘strlazymatch’ was here
> >cc1: all warnings being treated as errors
> >make: *** [/tmp/pbuild/builtin-diff.o] Error 1
> >make: *** Waiting for unfinished jobs....
> >make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
> 
> You are probably not hitting this compile problem, and I have no

Strange, I just tested on f14 x86_64 and i386, in addition to RHEL6.2,
no problems :-\

> idea why I am suddenly hitting it on F14 and F16 (my usual test
> servers; i have always hit this on older systems), but nonetheless
> there are duplicate declarations between util.h and symbol.h which
> should be fixed.

Yeah, but the patch is not applying on my perf/urgent branch, can you
take a look?

 
> David
> 
> 
> >
> >Fix it by removing duplicates.
> >
> >Signed-off-by: David Ahern<dsahern@gmail.com>
> >---
> >  tools/perf/util/symbol.h |    4 +---
> >  tools/perf/util/util.h   |    6 +-----
> >  2 files changed, 2 insertions(+), 8 deletions(-)
> >
> >diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> >index 1f00388..4ba5206 100644
> >--- a/tools/perf/util/symbol.h
> >+++ b/tools/perf/util/symbol.h
> >@@ -9,6 +9,7 @@
> >  #include<linux/list.h>
> >  #include<linux/rbtree.h>
> >  #include<stdio.h>
> >+#include "string.h"
> >
> >  #ifdef HAVE_CPLUS_DEMANGLE
> >  extern char *cplus_demangle(const char *, int);
> >@@ -29,9 +30,6 @@ static inline char *bfd_demangle(void __used *v, const char __used *c,
> >  #endif
> >  #endif
> >
> >-int hex2u64(const char *ptr, u64 *val);
> >-char *strxfrchar(char *s, char from, char to);
> >-
> >  /*
> >   * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
> >   * for newer versions we can use mmap to reduce memory usage:
> >diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> >index 2daaedb..5152592 100644
> >--- a/tools/perf/util/util.h
> >+++ b/tools/perf/util/util.h
> >@@ -78,6 +78,7 @@
> >  #include "../../../include/linux/magic.h"
> >  #include "types.h"
> >  #include<sys/ttydefaults.h>
> >+#include "string.h"
> >
> >  extern const char *graph_line;
> >  extern const char *graph_dotted_line;
> >@@ -235,11 +236,6 @@ static inline int sane_case(int x, int high)
> >  int mkdir_p(char *path, mode_t mode);
> >  int copyfile(const char *from, const char *to);
> >
> >-s64 perf_atoll(const char *str);
> >-char **argv_split(const char *str, int *argcp);
> >-void argv_free(char **argv);
> >-bool strglobmatch(const char *str, const char *pat);
> >-bool strlazymatch(const char *str, const char *pat);
> >  int strtailcmp(const char *s1, const char *s2);
> >  unsigned long convert_unit(unsigned long value, char *unit);
> >  int readn(int fd, void *buf, size_t size);
