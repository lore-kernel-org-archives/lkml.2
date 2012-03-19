Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab2CSIvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:51:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48295 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347Ab2CSIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:51:36 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 19 Mar 2012 16:50:54 +0800
Message-ID: <CANFwon0FEaXZpUafutptdH8+oPetLYm+E92Bi_Brk5_w8ePJGQ@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20120319 release(include
 hotcode analyzer hotcode.py)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP is a realtime and lightweight Linux Kernel debugger and tracer.

It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
current machine or remote machine (see
https://code.google.com/p/kgtp/wiki/HOWTO#Make_GDB_connect_to_gtp) can
debug and trace Linux through GDB tracepoint without stopping the
Linux Kernel. And even if the board doesn't have GDB on it and doesn't
have interface for remote debug. It can debug the Linux Kernel using
offline debug (See
https://code.google.com/p/kgtp/wiki/HOWTO#Offline_debug).
And it can work with Android (See
https://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).
Now, it supports X86-32, X86-64, MIPS and ARM.

Now, KGTP 20120319 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20120319.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20120319

When 20120224 release, I said that I just work on a very interesting
add-ons(a python script for GDB).  Now, it is included in the KGTP and
named hotcode.py.
It can show the hotest code line in the Kernel or user space program
without interrupt them through parse and record the pc address in the
irq handler.
Following part is a output of hotcode.py:
sudo gdb ./vmlinux -x ~/kernel/svn/trunk/add-ons/hotcode.py
task 17502 /home/teawater/kernel/svn/bak/a.out
Kernel hotcode:
	Hotest function
	format_decode 		68
	string 		51
	__ticket_spin_lock 		27
	vsnprintf 		25
	memcpy 		25
	mutex_lock 		19
	mutex_unlock 		18
	system_call 		18
	copy_user_generic_string 		18
	strnlen 		17
	seq_read 		15
	fget_light 		8
	__ticket_spin_unlock 		8
	None 		6
	sys_lseek 		4
	rw_verify_area 		4
	proc_reg_read 		4
	vfs_read 		4
	fsnotify 		3
	seq_printf 		3

	Hotest file
	/home/teawater/kernel2/linux/lib/vsprintf.c 		144
	/home/teawater/kernel2/linux/arch/x86/include/asm/spinlock.h 		35
	/home/teawater/kernel2/linux/kernel/mutex.c 		35
	/home/teawater/kernel2/linux/arch/x86/lib/memcpy_64.S 		25
	/home/teawater/kernel2/linux/fs/seq_file.c 		21
	/home/teawater/kernel2/linux/arch/x86/lib/copy_user_64.S 		18
	/home/teawater/kernel2/linux/arch/x86/kernel/entry_64.S 		18
	/home/teawater/kernel2/linux/lib/string.c 		17
	/home/teawater/kernel2/linux/fs/read_write.c 		16
	/home/teawater/kernel2/linux/fs/proc/inode.c 		6
	None 		6
	/home/teawater/kernel2/linux/fs/notify/fsnotify.c 		5
	/home/teawater/kernel2/linux/fs/file_table.c 		5
	/home/teawater/kernel2/linux/include/linux/fdtable.h 		3
	/home/teawater/kernel2/linux/arch/x86/include/asm/paravirt.h 		2
	/home/teawater/kernel2/linux/include/linux/spinlock.h 		2
	/home/teawater/kernel2/linux/kernel/mutex.h 		2
	/home/teawater/kernel2/linux/include/linux/proc_fs.h 		2
	/home/teawater/kernel2/linux/kernel/sched/core.c 		1
	/home/teawater/kernel2/linux/include/linux/file.h 		1

	Hotest line
	/home/teawater/kernel2/linux/lib/vsprintf.c:983 		32
	/home/teawater/kernel2/linux/arch/x86/include/asm/spinlock.h:57 		26
	/home/teawater/kernel2/linux/lib/vsprintf.c:395 		24
	/home/teawater/kernel2/linux/kernel/mutex.c:124 		18
	/home/teawater/kernel2/linux/kernel/mutex.c:90 		15
	/home/teawater/kernel2/linux/lib/string.c:402 		15
	/home/teawater/kernel2/linux/arch/x86/kernel/entry_64.S:477 		14
	/home/teawater/kernel2/linux/arch/x86/lib/memcpy_64.S:73 		13
	/home/teawater/kernel2/linux/lib/vsprintf.c:982 		11
	/home/teawater/kernel2/linux/lib/vsprintf.c:394 		10
	/home/teawater/kernel2/linux/arch/x86/include/asm/spinlock.h:84 		8
	/home/teawater/kernel2/linux/lib/vsprintf.c:957 		8
	/home/teawater/kernel2/linux/arch/x86/lib/memcpy_64.S:75 		7
	/home/teawater/kernel2/linux/arch/x86/lib/copy_user_64.S:250 		7
	None:None 		6
	/home/teawater/kernel2/linux/lib/vsprintf.c:377 		6
	/home/teawater/kernel2/linux/lib/vsprintf.c:1015 		5
	/home/teawater/kernel2/linux/arch/x86/lib/memcpy_64.S:67 		5
	/home/teawater/kernel2/linux/lib/vsprintf.c:1132 		5
	/home/teawater/kernel2/linux/fs/seq_file.c:258 		5

User hotcode:
	Hotest function
	/lib/libc-2.12.1.so:lseek64 		11
	/home/teawater/kernel/svn/bak/a.out:main 		6
	/lib/libc-2.12.1.so:read 		6
	None 		1

	Hotest file
	None 		18
	readc.c 		6

	Hotest line
	None:None 		18
	readc.c:87 		2
	readc.c:83 		2
	readc.c:81 		1
	readc.c:85 		1

It can show the hot functions, hot files and hot lines.  Even if some
functions is inside libs, it can parser the info out.
And hotcode.py can monitor a lot of tasks in same time.
And I will add GUI to this add-ons to make it can outout infor more clear.

The other change of this release is:
Fix bug with GDB RSP package sum check.
Increase the speed of access to trace state variables.
Increase the speed of agent code execution.
Remove the current agent code "printf" support because GDB will
support new format of agent code "printf".
Fix bug about access $current_task_pid.
Add new debug switch GTP_DEBUG_V (just for developer).
To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

According to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.  I will post the patch
for review to linux-kernel@vger.kernel.org in a separate mail.

Thanks,
Hui
