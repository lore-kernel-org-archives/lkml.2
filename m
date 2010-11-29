Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0K2MyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:54:18 -0500
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:38061 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753752Ab0K2MyR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:54:17 -0500
Subject: Re: [PATCH 3/5] perf tools: Add GCC optimization to memory
 allocating functions
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20101127003040.GB17400@ghostprotocols.net>
References: <1290808041-16535-1-git-send-email-acme@infradead.org>
	 <1290808041-16535-4-git-send-email-acme@infradead.org>
	 <20101127003040.GB17400@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 09:54:09 -0300
Message-ID: <1291035249.2189.20.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 22:30 -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 26, 2010 at 07:47:19PM -0200, Arnaldo Carvalho de Melo escreveu:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > We can benefit from the alloc_size attribute in xrealloc and zalloc.
> > 
> > Quoting from http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html:
> > 
> > "The alloc_size attribute is used to tell the compiler that the function return
> > value points to memory, where the size is given by one or two of the functions
> > parameters. GCC uses this information to improve the correctness of
> > __builtin_object_size."
> 
> Ingo, please don't pull this, it breaks the build with older GCCs...
> 

Sorry about that. This attribute was added for the 4.2 series in early
2007 (http://gcc.gnu.org/ml/gcc-patches/2007-04/msg01649.html)

> util/util.h:185: warning: ‘alloc_size’ attribute directive ignored
> util/util.h:190: warning: ‘alloc_size’ attribute directive ignored
> make: *** [/home/acme/git/build/perf/builtin-annotate.o] Error 1
> make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
> [acme@mica linux-2.6-tip]$ gcc -v
> Using built-in specs.
> Target: x86_64-redhat-linux
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> --infodir=/usr/share/info --enable-shared --enable-threads=posix
> --enable-checking=release --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-libgcj-multifile
> --enable-languages=c,c++,objc,obj-c++,java,fortran,ada
> --enable-java-awt=gtk --disable-dssi --enable-plugin
> --with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre
> --with-cpu=generic --host=x86_64-redhat-linux
> Thread model: posix
> gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)
> 
> I'll reorg this using compiler.h tricks probably, for now I'll just
> remove it from my perf/core branch.
> 
> - Arnaldo
> 


