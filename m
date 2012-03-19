Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab2CSRTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:19:44 -0400
Received: from seven.medozas.de ([188.40.89.202]:54321 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab2CSRTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:19:43 -0400
Date: Mon, 19 Mar 2012 18:19:41 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: xemul@parallels.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: procfs: introduce the /proc/<pid>/map_files/ directory
Message-ID: <alpine.LNX.2.01.1203191755490.20699@frira.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I tried out the map_files directory in v3.3, stumbling upon a few 
things:

/proc> echo $$
1724
/proc> cd 1724/map_files/
/proc/1724/map_files> ls
ls: reading directory .: Permission denied
/proc/1724/map_files> ls -dl .
dr-x------ 2 jengelh users 0 Mar 19 12:54 .

By all means, I have the permission - according to stat.

Also, not all mappings - in particular, anonymous mappings - seem to be 
represented:

00400000-0049b000 r-xp 00000000 08:02 10425                              /bin/ba
0069a000-0069b000 r--p 0009a000 08:02 10425                              /bin/ba
0069b000-0069f000 rw-p 0009b000 08:02 10425                              /bin/ba
0069f000-006a9000 rw-p 00000000 00:00 0 
01a90000-01bf8000 rw-p 00000000 00:00 0                                  [heap]
7f87eb3be000-7f87eb559000 r-xp 00000000 08:02 980                        /lib64/
7f87eb559000-7f87eb758000 ---p 0019b000 08:02 980                        /lib64/
7f87eb758000-7f87eb75c000 r--p 0019a000 08:02 980                        /lib64/
7f87eb75c000-7f87eb75e000 rw-p 0019e000 08:02 980                        /lib64/
7f87eb75e000-7f87eb762000 rw-p 00000000 00:00 0 
[...]
7f87ebffd000-7f87ebffe000 rw-p 00021000 08:02 71                         /lib64/ld-2.15.so
7f87ebffe000-7f87ebfff000 rw-p 00000000 00:00 0
7fffb9f1e000-7fffb9f3f000 rw-p 00000000 00:00 0                          [stack]
7fffb9fb5000-7fffb9fb6000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

/proc/1724/map_files # ls -alog
total 0
dr-x------ 2  0 Mar 19 12:54 .
dr-xr-xr-x 9  0 Mar 19 12:54 ..
lr-------- 1 64 Mar 19 12:54 400000-49b000 -> /bin/bash
lr-------- 1 64 Mar 19 12:54 69a000-69b000 -> /bin/bash
lr-------- 1 64 Mar 19 12:54 69b000-69f000 -> /bin/bash
lr-------- 1 64 Mar 19 12:54 7f87eb3be000-7f87eb559000 -> /lib64/libc-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb559000-7f87eb758000 -> /lib64/libc-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb758000-7f87eb75c000 -> /lib64/libc-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb75c000-7f87eb75e000 -> /lib64/libc-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb762000-7f87eb764000 -> /lib64/libdl-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb764000-7f87eb964000 -> /lib64/libdl-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb964000-7f87eb965000 -> /lib64/libdl-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb965000-7f87eb966000 -> /lib64/libdl-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87eb966000-7f87eb98f000 -> /lib64/libtinfo.so.5.9
lr-------- 1 64 Mar 19 12:54 7f87eb98f000-7f87ebb8e000 -> /lib64/libtinfo.so.5.9
lr-------- 1 64 Mar 19 12:54 7f87ebb8e000-7f87ebb92000 -> /lib64/libtinfo.so.5.9
lr-------- 1 64 Mar 19 12:54 7f87ebb92000-7f87ebb97000 -> /lib64/libtinfo.so.5.9
lr-------- 1 64 Mar 19 12:54 7f87ebb98000-7f87ebbd3000 -> /lib64/libreadline.so.6.2
lr-------- 1 64 Mar 19 12:54 7f87ebbd3000-7f87ebdd3000 -> /lib64/libreadline.so.6.2
lr-------- 1 64 Mar 19 12:54 7f87ebdd3000-7f87ebdd5000 -> /lib64/libreadline.so.6.2
lr-------- 1 64 Mar 19 12:54 7f87ebdd5000-7f87ebddb000 -> /lib64/libreadline.so.6.2
lr-------- 1 64 Mar 19 12:54 7f87ebddc000-7f87ebdfd000 -> /lib64/ld-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87ebffc000-7f87ebffd000 -> /lib64/ld-2.15.so
lr-------- 1 64 Mar 19 12:54 7f87ebffd000-7f87ebffe000 -> /lib64/ld-2.15.so

Having symlinks into anonmaps would provide for an interesting type
of debug/insight without having to resort to ptracting, just as
/proc/X/fd/Y is when the file behind Y is nlink=0.
