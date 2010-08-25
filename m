Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0HYJVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:21:18 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42434 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0HYJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=FYRotayhcFCariNt+Cjl9ZUArf/0Qn6PX9wUVJMDnvbRbhOWSQdLu/OVzI+mzMAxea
         yDxAxIBpvvh1qiQCeZzllIKo+DorYLXHiE/BhySYLWmG2ARWXt2XMDS2H6jK+5LTOMP2
         t0fe9h1jBscCB1aHDbLRWkL9YB9KI6QM8S+PE=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 25 Aug 2010 17:20:52 +0800
Message-ID: <AANLkTinD76VCpZutts7Qcj0U0vNyxqNWxEKwVgz6ge3Y@mail.gmail.com>
Subject: Linux Kernel GDB tracepoint module 2010-8-25 release
To: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org
Cc: Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>, mqyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kgtp.googlecode.com/files/kgtp_20100825.tar.bz2
Add support for action M.
Fix some bug.
Make debug more friendly.

The x86-32 backtrace bug is fixed.

And we can access to global variable in tracepoint.
For example:
(gdb) trace vfs_readdir
Tracepoint 1 at 0xc01ed740: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
(gdb) actions
Enter actions for tracepoint 1, one per line.
End with a line saying just "end".
>collect jiffies_64
>collect *file
>end
(gdb) tstart
(gdb) shell ls
arch    drivers   include  kernel    mm               Module.symvers
security  System.map  virt
block   firmware  init     lib       modules.builtin  net
sound     t           vmlinux
crypto  fs        ipc      Makefile  modules.order    scripts
source    usr         vmlinux.o
(gdb) tstop
(gdb) tfind
Found trace frame 0, tracepoint 1
#0  0xc01ed741 in vfs_readdir (file=0xf4063000, filler=0xc01ed580
<filldir64>, buf=0xd6dfdf90)
    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
24      {
(gdb) p jiffies_64
$1 = 4297248706
(gdb) p *file
$2 = {f_u = {fu_list = {next = 0xf5b8fe40, prev = 0xc500ad3c},
fu_rcuhead = {next = 0xf5b8fe40, func = 0xc500ad3c}},
  f_path = {mnt = 0xc35abd80, dentry = 0xf5d8


To get more message about howto use KGTP, please goto see the HOWTO in
https://code.google.com/p/kgtp/wiki/HOWTO

Thanks,
Hui
