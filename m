Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2EDKZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:25:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52451 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2EDKZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:25:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120502191205.GG5745@infradead.org>
References: <1327744256-10786-1-git-send-email-js1304@gmail.com>
	<1336036107-12334-1-git-send-email-js1304@gmail.com>
	<20120502191205.GG5745@infradead.org>
Date: Fri, 4 May 2012 19:25:00 +0900
Message-ID: <CAAmzW4Po_HS--AiVew9_afkD-WmzU37F+W4mhLEbB+Fpmd5p0w@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix Makefile to clean auto-generated
 bison/flex files properly
From: JoonSoo Kim <js1304@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you sure?
>
> [acme@sandy perf]$ make -j8 > /dev/null
> PERF_VERSION = 3.4.rc2.45.g89290d
>  * new build flags or prefix
> [acme@sandy perf]$ ls -la util/*bison*
> -rw-rw-r--. 1 acme acme  51448 May  2 16:10 util/parse-events-bison.c
> -rw-rw-r--. 1 acme acme   2553 May  2 16:10 util/parse-events-bison.h
> -rw-rw-r--. 1 acme acme 179488 May  2 16:10 util/parse-events-bison.o
> -rw-rw-r--. 1 acme acme  12484 May  2 16:10 util/parse-events-bison.output
> -rw-rw-r--. 1 acme acme  43849 May  2 16:10 util/pmu-bison.c
> -rw-rw-r--. 1 acme acme   2313 May  2 16:10 util/pmu-bison.h
> -rw-rw-r--. 1 acme acme  66064 May  2 16:10 util/pmu-bison.o
> -rw-rw-r--. 1 acme acme   3416 May  2 16:10 util/pmu-bison.output
> [acme@sandy perf]$ make clean > /dev/null
> [acme@sandy perf]$ ls -la util/*bison*
> ls: cannot access util/*bison*: No such file or directory
> [acme@sandy perf]$

Hmm...

I do more test on 4 types of environment(VM_x86_32_ubuntu10.04,
x86_32_ubuntu10.04,
x86_64_ubuntu11.10, x86_64_ubuntu12.04) and same result is occured.

All the GNU Make version is 3.81.
Below is my log.

So my conclusion is it relate to ubuntu.

js1304@ubuntu:~/Project/linux-torvalds/tools/perf$ make -j4 > /dev/null
Makefile:503: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
Makefile:533: GTK2 not found, disables GTK2 support. Please install
gtk2-devel or libgtk2.0-dev
Makefile:590: The path '/usr/bin/python-config' is not executable.
Makefile:594: No python-config tool was found
Makefile:594: Python support won't be built
Makefile:663: No bfd.h/libbfd found, install
binutils-dev[el]/zlib-static to gain symbol demangling
PERF_VERSION = 3.4.rc5
Makefile:503: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
Makefile:533: GTK2 not found, disables GTK2 support. Please install
gtk2-devel or libgtk2.0-dev
Makefile:590: The path '/usr/bin/python-config' is not executable.
Makefile:594: No python-config tool was found
Makefile:594: Python support won't be built
Makefile:663: No bfd.h/libbfd found, install
binutils-dev[el]/zlib-static to gain symbol demangling
    * new build flags or prefix
js1304@ubuntu:~/Project/linux-torvalds/tools/perf$ ls -al util/*-bison*
-rw-r--r-- 1 js1304 js1304  51448 2012-05-03 02:47 util/parse-events-bison.c
-rw-r--r-- 1 js1304 js1304   2553 2012-05-03 02:47 util/parse-events-bison.h
-rw-r--r-- 1 js1304 js1304 145340 2012-05-03 02:47 util/parse-events-bison.o
-rw-r--r-- 1 js1304 js1304  12484 2012-05-03 02:47
util/parse-events-bison.output
-rw-r--r-- 1 js1304 js1304  43849 2012-05-03 02:47 util/pmu-bison.c
-rw-r--r-- 1 js1304 js1304   2313 2012-05-03 02:47 util/pmu-bison.h
-rw-r--r-- 1 js1304 js1304  58240 2012-05-03 02:47 util/pmu-bison.o
-rw-r--r-- 1 js1304 js1304   3416 2012-05-03 02:47 util/pmu-bison.output
js1304@ubuntu:~/Project/linux-torvalds/tools/perf$ make clean > /dev/null
Makefile:503: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
Makefile:533: GTK2 not found, disables GTK2 support. Please install
gtk2-devel or libgtk2.0-dev
Makefile:590: The path '/usr/bin/python-config' is not executable.
Makefile:594: No python-config tool was found
Makefile:594: Python support won't be built
Makefile:663: No bfd.h/libbfd found, install
binutils-dev[el]/zlib-static to gain symbol demangling
Makefile:503: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
Makefile:533: GTK2 not found, disables GTK2 support. Please install
gtk2-devel or libgtk2.0-dev
Makefile:590: The path '/usr/bin/python-config' is not executable.
Makefile:594: No python-config tool was found
Makefile:594: Python support won't be built
Makefile:663: No bfd.h/libbfd found, install
binutils-dev[el]/zlib-static to gain symbol demangling
js1304@ubuntu:~/Project/linux-torvalds/tools/perf$ ls -al util/*-bison*
-rw-r--r-- 1 js1304 js1304 51448 2012-05-03 02:47 util/parse-events-bison.c
-rw-r--r-- 1 js1304 js1304  2553 2012-05-03 02:47 util/parse-events-bison.h
-rw-r--r-- 1 js1304 js1304 12484 2012-05-03 02:47 util/parse-events-bison.output
-rw-r--r-- 1 js1304 js1304 43849 2012-05-03 02:47 util/pmu-bison.c
-rw-r--r-- 1 js1304 js1304  2313 2012-05-03 02:47 util/pmu-bison.h
-rw-r--r-- 1 js1304 js1304  3416 2012-05-03 02:47 util/pmu-bison.output
js1304@ubuntu:~/Project/linux-torvalds/tools/perf$ grep RM.*bison Makefile
	$(RM) $(OUTPUT)util/*-{bison,flex}*
js1304@ubuntu:~/Project/linux-torvalds/tools/perf$ make --version
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
