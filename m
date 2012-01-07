Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab2AGRfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:35:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55023 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2AGRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:35:18 -0500
Date: Sat, 7 Jan 2012 15:35:10 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [ERROR] perf build failure on current tip:perf/core
Message-ID: <20120107173510.GA24443@infradead.org>
References: <1325950949.1486.20.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325950949.1486.20.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 08, 2012 at 12:42:29AM +0900, Namhyung Kim escreveu:
> Hi,
> 
> When I tried to build perf, I was faced with following error:
> 
>     CC util/trace-event-info.o
> cc1: warnings being treated as errors
> util/trace-event-info.c: In function ‘record_file’:
> util/trace-event-info.c:192: error: implicit declaration of function
> ‘pwrite’
> util/trace-event-info.c:192: error: nested extern declaration of
> ‘pwrite’
> make: *** [util/trace-event-info.o] Error 1
> 
> The code I tried was latest tip:perf/core - 9e183426bfb5 ("perf kvm: Fix
> copy & paste error in description") and code in mainline (v3.2) doesn't
> have this problem. Looking at the code, I couldn't find any clue to
> this. Any idea?
> 
> FYI, my system is Ubuntu 10.04 on x86_64. gcc version is 4.4.3:

Yeah, yesterday Joerg reported this as well, I managed to reproduce it
on a newly installed ubuntu 10.04.3 (LTS) i686 VM, haven't had time to
investigate yet tho.

- Arnaldo
 
> namhyung@leonhard:perf$ gcc -v
> Using built-in specs.
> Target: x86_64-linux-gnu
> Configured with: ../src/configure -v --with-pkgversion='Ubuntu
> 4.4.3-4ubuntu5' --with-bugurl=file:///usr/share/doc/gcc-4.4/README.Bugs
> --enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
> --enable-shared --enable-multiarch --enable-linker-build-id
> --with-system-zlib --libexecdir=/usr/lib --without-included-gettext
> --enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.4
> --program-suffix=-4.4 --enable-nls --enable-clocale=gnu
> --enable-libstdcxx-debug --enable-plugin --enable-objc-gc
> --disable-werror --with-arch-32=i486 --with-tune=generic
> --enable-checking=release --build=x86_64-linux-gnu
> --host=x86_64-linux-gnu --target=x86_64-linux-gnu
> Thread model: posix
> gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) 
> 
> Thanks.
> 
> 
> -- 
> Regards,
> Namhyung Kim
> 
