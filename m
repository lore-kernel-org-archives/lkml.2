Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0K0Aa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 19:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0K0Aa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 19:30:57 -0500
Date: Fri, 26 Nov 2010 22:30:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@gnu.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/5] perf tools: Add GCC optimization to memory
	allocating functions
Message-ID: <20101127003040.GB17400@ghostprotocols.net>
References: <1290808041-16535-1-git-send-email-acme@infradead.org> <1290808041-16535-4-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290808041-16535-4-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 26, 2010 at 07:47:19PM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> We can benefit from the alloc_size attribute in xrealloc and zalloc.
> 
> Quoting from http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html:
> 
> "The alloc_size attribute is used to tell the compiler that the function return
> value points to memory, where the size is given by one or two of the functions
> parameters. GCC uses this information to improve the correctness of
> __builtin_object_size."

Ingo, please don't pull this, it breaks the build with older GCCs...

util/util.h:185: warning: ‘alloc_size’ attribute directive ignored
util/util.h:190: warning: ‘alloc_size’ attribute directive ignored
make: *** [/home/acme/git/build/perf/builtin-annotate.o] Error 1
make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
[acme@mica linux-2.6-tip]$ gcc -v
Using built-in specs.
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info --enable-shared --enable-threads=posix
--enable-checking=release --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-libgcj-multifile
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada
--enable-java-awt=gtk --disable-dssi --enable-plugin
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre
--with-cpu=generic --host=x86_64-redhat-linux
Thread model: posix
gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)

I'll reorg this using compiler.h tricks probably, for now I'll just
remove it from my perf/core branch.

- Arnaldo
