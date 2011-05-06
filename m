Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab1EFTrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:47:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54661 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab1EFTrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:47:51 -0400
Date: Fri, 6 May 2011 12:47:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rodolfo Giometti <giometti@linux.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39-rc6 (pps ktimer uses freed memory)
Message-Id: <20110506124722.797ff109.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTin=0VvkzVCswMYXcHE2gH78V7V5Lw@mail.gmail.com>
References: <BANLkTin=0VvkzVCswMYXcHE2gH78V7V5Lw@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DC45052.015F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loading and unloading pps-ktimer.ko (on x86_64) causes this:


pps pps0: ktimer PPS source unregistered
=============================================================================
BUG kmalloc-512: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88005d3b45e0-0xffff88005d3b45e0. First byte 0x6a instead of 0x6b
INFO: Allocated in pps_register_source+0xf0/0x1f3 [pps_core] age=277 cpu=0 pid=8778
INFO: Freed in pps_device_destruct+0x7f/0x8b [pps_core] age=16 cpu=1 pid=8786
INFO: Slab 0xffffea0001464f60 objects=28 used=2 fp=0xffff88005d3b4490 flags=0x100000000040c1
INFO: Object 0xffff88005d3b4490 @offset=1168 fp=0xffff88005d3b46d8

Bytes b4 0xffff88005d3b4480:  1c c1 34 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .Á4.....ZZZZZZZZ
  Object 0xffff88005d3b4490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b44a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b44b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b44c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b44d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b44e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b44f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b45a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b45b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b45c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b45d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b45e0:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b jkkkkkkkkkkkkkkk
  Object 0xffff88005d3b45f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88005d3b4680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
 Redzone 0xffff88005d3b4690:  bb bb bb bb bb bb bb bb                         »»»»»»»»        
 Padding 0xffff88005d3b46d0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 8789, comm: sleep Not tainted 2.6.39-rc6 #1
Call Trace:
 [<ffffffff811b0d32>] print_trailer+0x18d/0x19d
 [<ffffffff8122f76b>] ? load_elf_interp+0xb1/0x640
 [<ffffffff811b1481>] check_bytes_and_report+0xf5/0x12d
 [<ffffffff8122f7bb>] ? load_elf_interp+0x101/0x640
 [<ffffffff811b15b3>] check_object+0xfa/0x238
 [<ffffffff8122f78d>] ? load_elf_interp+0xd3/0x640
 [<ffffffff811b20ee>] alloc_debug_processing+0xcc/0x184
 [<ffffffff811b4091>] __slab_alloc+0x40d/0x457
 [<ffffffff810b034e>] ? sched_clock_local+0x1a/0xc0
 [<ffffffff8122f78d>] ? load_elf_interp+0xd3/0x640
 [<ffffffff8122f78d>] ? load_elf_interp+0xd3/0x640
 [<ffffffff811b5005>] __kmalloc+0x143/0x21b
 [<ffffffff8122f78d>] load_elf_interp+0xd3/0x640
 [<ffffffff812d20d4>] ? __clear_user+0x47/0x73
 [<ffffffff812d20ae>] ? __clear_user+0x21/0x73
 [<ffffffff812309e0>] load_elf_binary+0xbc1/0x1108
 [<ffffffff811d70ca>] search_binary_handler+0x112/0x386
 [<ffffffff8122fe1f>] ? set_brk+0x125/0x125
 [<ffffffff811d97f1>] do_execve+0x269/0x3db
 [<ffffffff81017843>] sys_execve+0x5a/0x7f
 [<ffffffff8157552c>] stub_execve+0x6c/0xc0
FIX kmalloc-512: Restoring 0xffff88005d3b45e0-0xffff88005d3b45e0=0x6b

FIX kmalloc-512: Marking all objects used

