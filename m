Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab0HLL5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759931Ab0HLL5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:57:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100811150746.GA9070@suse.de>
References: <20100811150746.GA9070@suse.de> <20100811140102.19596.84876.stgit@warthog.procyon.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: dhowells@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Break the kobject namespace defs into their own header
Date: Thu, 12 Aug 2010 12:56:25 +0100
Message-ID: <12812.1281614185@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote:

> What "ordering problem" is there?  I don't see a build error here, do
> you?

Yes:

  CC      arch/mn10300/kernel/asm-offsets.s
In file included from include/linux/kobject.h:21,
                 from include/linux/sched.h:91,
                 from arch/mn10300/kernel/asm-offsets.c:7:
include/linux/sysfs.h:177: warning: parameter 1 ('type') has incomplete type
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
<stdin>:1526:2: warning: #warning syscall fanotify_init not implemented
<stdin>:1530:2: warning: #warning syscall fanotify_mark not implemented
<stdin>:1534:2: warning: #warning syscall prlimit64 not implemented
  CC      init/main.o
  CC      arch/mn10300/mm/init.o
  CC      arch/mn10300/kernel/process.o
In file included from include/linux/kobject.h:21,
                 from include/linux/sched.h:91,
                 from include/linux/utsname.h:35,
                 from /warthog/am33/linux-2.6-mn10300/arch/mn10300/include/asm/elf.h:15,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from init/main.c:13:
include/linux/sysfs.h:177: warning: parameter 1 ('type') has incomplete type
In file included from include/linux/kobject.h:21,
                 from include/linux/sched.h:91,
                 from arch/mn10300/mm/init.c:13:
include/linux/sysfs.h:177: warning: parameter 1 ('type') has incomplete type
In file included from include/linux/kobject.h:21,
                 from include/linux/sched.h:91,
                 from include/linux/utsname.h:35,
                 from /warthog/am33/linux-2.6-mn10300/arch/mn10300/include/asm/elf.h:15,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from arch/mn10300/kernel/process.c:11:
include/linux/sysfs.h:177: warning: parameter 1 ('type') has incomplete type
...


The problem appears to be that 

	enum kobj_ns_type

is defined in linux/kobject.h but referenced in linux/sysfs.h, which is
included by linux/kobject.h.  Whilst I see a predeclaration at the top of
linux/sysfs.h, my compiler seems to ignore it.

The compiler is:

	gcc version 3.4-am33-04r2-5

which is a supported version according to the compiler-gcc3.h header file.

David
