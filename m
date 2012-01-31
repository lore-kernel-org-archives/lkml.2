Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2AaNgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:36:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65195 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2AaNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:36:10 -0500
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 31 Jan 2012 21:35:29 +0800
Message-ID: <CANFwon0njeNjEGxvU00eZK5ojpHT_ZgS0vrFAVaPTYYndL1Atw@mail.gmail.com>
Subject: KGTP (Linux Kernel debugger and tracer) 20120131 release(fix memory
 leaks of 20111218)
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
offline debug (See https://code.google.com/p/kgtp/wiki/HOWTO#Offline_debug).
And it can work with Android (See
https://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).
Now, it supports X86-32, X86-64, MIPS and ARM.

Now, KGTP 20120131 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20120131.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20120131


The change of this release is:
Fix two memory leaks bug of gtp_rb, if you are the user of 20111218,
please update to this version at once.
The two issue is:
Fix bug of gtp_rb page release in function gtp_rb_page_free.
Fix bug of gtp_rb_put_page that is used by gtpframe_pipe.

Add support for GDB rsp package "qXfer:traceframe-info:read". Then
tfind mode will show the memory that is not in traceframe as
"<unavailable>".  It is more accurate than before.
It fixed issue 1 and Issue 101.

Add ignore gtp.ko function to getmod.py.

Add define for perf_event_enable and perf_event_disable in gtp.c and
perf_event.c because both of them EXPORT_SYMBOL_GPL in Linux Kernel
3.3.

To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE

According to the comments of Christoph.  I make a patch for Linux
Kernel and make it looks OK with checkpatch.pl.  I will post the patch
for review in next mail.

Thanks,
Hui
