Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2B0BEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 20:04:53 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63837 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2B0BEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 20:04:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of teawater@gmail.com designates 10.216.135.193 as permitted sender) smtp.mail=teawater@gmail.com; dkim=pass header.i=teawater@gmail.com
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 27 Feb 2012 09:04:11 +0800
Message-ID: <CANFwon1YoxbC8+6aq2eW68x2b2qAXkUgNsqnM7SqEboLzy9d3g@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20120224 release(more bug fix)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>, kernel@vger.linux-kernel.cn
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

Now, KGTP 20120224 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20120224.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20120224

I tried to done an very interesting add-ons(a python script for GDB)
in this release.  But I found some bugs and fixed them when I tested
this add-ons.  So I think maybe release a new version for these bug
fixes is better.
Please give KGTP some concern, our next version will include this
interesting add-ons.

The change of this release is:
Fix build error with Linux Kernel 3.0.x version. Thanks for report
from sam.wanshan.
Make getgtprsp.pl support all special trace state variables.
Fix the bug that set the id of FID_PAGE_BEGIN inside gtp_rb.
Change code to ignore the task that read the
/sys/kernel/debug/gtpframe_pipe in default.  And add special trace
state variable $pipe_trace to control it.
Fix error of doc about $ignore_error.
Add $current_task_pid to access to get_current()->pid.
Remove GTP_VAR_NOT_GETV, GTP_VAR_NOT_SETV and GTP_VAR_NOT_TRACEV.
Fix bug in gtp_frame_file_header that affect stack when src of
conditon or action is bigger than 200.
To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

According to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.  I will post the patch
for review to linux-kernel@vger.kernel.org in a separate mail.

Thanks,
Hui
