Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab2AMN4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:56:17 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:37001 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2AMN4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:56:16 -0500
Date: Fri, 13 Jan 2012 08:56:15 -0500 (EST)
From: Ramon de C Valle <rcvalle@redhat.com>
Reply-To: Ramon de C Valle <rcvalle@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] New PT_GNU_COMPAT segment header extension
Message-ID: <e821ec65-3872-45a6-ad0a-ae01c97bc1ee@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <90c73bcf-9c80-47c2-a0de-89bc066013d1@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.11.172]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a brief example of the behavior of the system I use for some time
already. For an ELF binary with the PT_GNU_STACK segment header and the PF_X
flag not set (i.e. the default), the following are its currently virtual
memory mappings and their access permissions:

[rcvalle@Fedora-15-i386 ~]$ cat /proc/2253/maps 
004e2000-004e3000 r-xp 00000000 00:00 0          [vdso]
08048000-08049000 r-xp 00000000 fd:02 926785     /home/rcvalle/a.out
08049000-0804a000 rw-p 00000000 fd:02 926785     /home/rcvalle/a.out
495c9000-495e8000 r-xp 00000000 fd:01 1971790    /lib/ld-2.13.90.so
495e8000-495e9000 r--p 0001f000 fd:01 1971790    /lib/ld-2.13.90.so
495e9000-495ea000 rw-p 00020000 fd:01 1971790    /lib/ld-2.13.90.so
495ec000-49774000 r-xp 00000000 fd:01 1971791    /lib/libc-2.13.90.so
49774000-49776000 r--p 00188000 fd:01 1971791    /lib/libc-2.13.90.so
49776000-49777000 rw-p 0018a000 fd:01 1971791    /lib/libc-2.13.90.so
49777000-4977a000 rw-p 00000000 00:00 0 
b780c000-b780d000 rw-p 00000000 00:00 0 
b7824000-b7825000 rw-p 00000000 00:00 0 
bfdc3000-bfde4000 rw-p 00000000 00:00 0          [stack]
[rcvalle@Fedora-15-i386 ~]$

The following are its currently virtual memory mappings and their access
permissions with the PT_GNU_STACK segment header and the PF_X flag unset:

[rcvalle@Fedora-15-i386 ~]$ cat /proc/2257/maps 
00dcc000-00dcd000 r-xp 00000000 00:00 0          [vdso]
08048000-08049000 r-xp 00000000 fd:02 926825     /home/rcvalle/a.out
08049000-0804a000 rw-p 00000000 fd:02 926825     /home/rcvalle/a.out
495c9000-495e8000 r-xp 00000000 fd:01 1971790    /lib/ld-2.13.90.so
495e8000-495e9000 r--p 0001f000 fd:01 1971790    /lib/ld-2.13.90.so
495e9000-495ea000 rw-p 00020000 fd:01 1971790    /lib/ld-2.13.90.so
495ec000-49774000 r-xp 00000000 fd:01 1971791    /lib/libc-2.13.90.so
49774000-49776000 r--p 00188000 fd:01 1971791    /lib/libc-2.13.90.so
49776000-49777000 rw-p 0018a000 fd:01 1971791    /lib/libc-2.13.90.so
49777000-4977a000 rw-p 00000000 00:00 0 
b7711000-b7712000 rw-p 00000000 00:00 0 
b7729000-b772a000 rw-p 00000000 00:00 0 
bfca7000-bfcc8000 rwxp 00000000 00:00 0          [stack]
[rcvalle@Fedora-15-i386 ~]$

The following are its currently virtual memory mappings and their access
permissions with the PT_GNU_COMPAT segment header and the PF_X flag set:

[rcvalle@Fedora-15-i386 ~]$ cat /proc/2349/maps 
00850000-00851000 r-xp 00000000 00:00 0          [vdso]
00d29000-00d2a000 rwxp 00000000 00:00 0 
00fd2000-00fd3000 rwxp 00000000 00:00 0 
08048000-08049000 r-xp 00000000 fd:02 926785     /home/rcvalle/a.out
08049000-0804a000 rwxp 00000000 fd:02 926785     /home/rcvalle/a.out
495c9000-495e8000 r-xp 00000000 fd:01 1971790    /lib/ld-2.13.90.so
495e8000-495e9000 r-xp 0001f000 fd:01 1971790    /lib/ld-2.13.90.so
495e9000-495ea000 rwxp 00020000 fd:01 1971790    /lib/ld-2.13.90.so
495ec000-49774000 r-xp 00000000 fd:01 1971791    /lib/libc-2.13.90.so
49774000-49776000 r-xp 00188000 fd:01 1971791    /lib/libc-2.13.90.so
49776000-49777000 rwxp 0018a000 fd:01 1971791    /lib/libc-2.13.90.so
49777000-4977a000 rwxp 00000000 00:00 0 
bfd2b000-bfd4c000 rwxp 00000000 00:00 0          [stack]
[rcvalle@Fedora-15-i386 ~]$

Notice the difference between its currently virtual memory mappings and
their access permissions with the PT_GNU_STACK segment header and the PF_X
flag unset and their access permissions with the PT_GNU_COMPAT segment
header and the PF_X flag set. The latter is the current behavior of the
Linux kernel for any ELF binary with the PT_GNU_STACK segment header and the
PF_X flag unset (i.e. all its virtual memory mappings are executable).

Any comments about these patches would be greatly appreciated.

Thanks,


-- 
Ramon de C Valle / Red Hat Security Response Team
