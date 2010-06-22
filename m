Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0FVF0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 01:26:07 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44639 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0FVF0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:26:04 -0400
Message-ID: <4C204962.70208@in.ibm.com>
Date: Tue, 22 Jun 2010 10:55:54 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: -next June 21: WARNING: at include/linux/tty.h
References: <20100621170056.2fcf10ad.sfr@canb.auug.org.au>
In-Reply-To: <20100621170056.2fcf10ad.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With next-20100621 on a x86_64 box came across this warning :

TCP cubic registered
registered taskstats version 1
------------[ cut here ]------------
WARNING: at include/linux/tty.h:589 tty_open+0x76/0x57a()
Hardware name: BladeCenter LS21 -[79716AA]-
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.35-rc3-autotest-next-20100621 #1
Call Trace:
 [<ffffffff812428d8>] ? tty_open+0x76/0x57a
 [<ffffffff8103cf39>] warn_slowpath_common+0x80/0xae
 [<ffffffff8103cf7c>] warn_slowpath_null+0x15/0x17
 [<ffffffff812428d8>] tty_open+0x76/0x57a
 [<ffffffff810d4544>] ? exact_match+0x0/0x9
 [<ffffffff810d491f>] chrdev_open+0x133/0x152
 [<ffffffff810d47ec>] ? chrdev_open+0x0/0x152
 [<ffffffff810d07b4>] __dentry_open+0x140/0x252
 [<ffffffff810d0990>] nameidata_to_filp+0x3e/0x4f
 [<ffffffff810db588>] do_last+0x51a/0x643
 [<ffffffff810dd621>] do_filp_open+0x23d/0x5f8
 [<ffffffff810c1ba8>] ? slab_node+0x3c/0x78
 [<ffffffff810d05a1>] do_sys_open+0x5a/0xf0
 [<ffffffff810d0660>] sys_open+0x1b/0x1d
 [<ffffffff818e66fc>] kernel_init+0x1b3/0x220
 [<ffffffff810036d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff818e6549>] ? kernel_init+0x0/0x220
 [<ffffffff810036d0>] ? kernel_thread_helper+0x0/0x10
---[ end trace 108cb769a1c0e534 ]---

This warning seem to have been introduced with next-20100617.
The corresponding code is :

585 static inline void tty_lock(void) __acquires(kernel_lock)
586 {
587 #ifdef CONFIG_LOCK_KERNEL
588         /* kernel_locked is 1 for !CONFIG_LOCK_KERNEL */
589         WARN_ON(kernel_locked());
590 #endif
591         lock_kernel();
592 }

which was added by commit 01510c869f9..

tty: replace BKL with a new tty_lock

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

