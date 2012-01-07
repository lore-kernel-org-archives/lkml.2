Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2AGPmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 10:42:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54382 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2AGPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 10:42:36 -0500
Subject: [ERROR] perf build failure on current tip:perf/core
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Jan 2012 00:42:29 +0900
Message-ID: <1325950949.1486.20.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I tried to build perf, I was faced with following error:

    CC util/trace-event-info.o
cc1: warnings being treated as errors
util/trace-event-info.c: In function ‘record_file’:
util/trace-event-info.c:192: error: implicit declaration of function
‘pwrite’
util/trace-event-info.c:192: error: nested extern declaration of
‘pwrite’
make: *** [util/trace-event-info.o] Error 1

The code I tried was latest tip:perf/core - 9e183426bfb5 ("perf kvm: Fix
copy & paste error in description") and code in mainline (v3.2) doesn't
have this problem. Looking at the code, I couldn't find any clue to
this. Any idea?

FYI, my system is Ubuntu 10.04 on x86_64. gcc version is 4.4.3:

namhyung@leonhard:perf$ gcc -v
Using built-in specs.
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu
4.4.3-4ubuntu5' --with-bugurl=file:///usr/share/doc/gcc-4.4/README.Bugs
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
--enable-shared --enable-multiarch --enable-linker-build-id
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.4
--program-suffix=-4.4 --enable-nls --enable-clocale=gnu
--enable-libstdcxx-debug --enable-plugin --enable-objc-gc
--disable-werror --with-arch-32=i486 --with-tune=generic
--enable-checking=release --build=x86_64-linux-gnu
--host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) 

Thanks.


-- 
Regards,
Namhyung Kim


