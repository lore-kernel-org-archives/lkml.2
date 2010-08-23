Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0HWJFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:05:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34674 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0HWJF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ResptL+2ESvaECxZLHZnmNeTaArdrBtVkWQr0x5H0U7Jd7d4cuJFSsCKpWlJSaCdZg
         /v02H1nok8CVSInNeTJenfTLbuGuDz6V7tPYj46/AHeSEKcUuq8hG/iJcHfdIuxbV3+Z
         tTFl/6thTprfCgNTISKwKbJinXMZyzX9oTk8s=
MIME-Version: 1.0
In-Reply-To: <AANLkTinP3ZcBgr5rt=gLeLXb7szBcEkErB_4QYYmx2vM@mail.gmail.com>
References: <AANLkTini-CCAe2wrVytdURKAwj+kpLvj1tU0DNRVEsqN@mail.gmail.com> <AANLkTinP3ZcBgr5rt=gLeLXb7szBcEkErB_4QYYmx2vM@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 23 Aug 2010 17:05:05 +0800
Message-ID: <AANLkTim7dprdseD2KE5RHArka3yNuDm=0eB0Yve4uaRj@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module support most collect now
To: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        mqyoung@gmail.com
Cc: Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some people have trouble with access to KGTP website. You can access
kgtp through svn:

svn checkout http://kgtp.googlecode.com/svn/ kgtp-read-only
kgtp-read-only/tags/ This directory have each release of KGTP.
The debug of this KGTP is open, please open gtp.c file remove line
"#define GTP_DEBUG	 KERN_WARNING" to close it.

Thanks,
Hui

On Mon, Aug 23, 2010 at 16:39, Hui Zhu <teawater@gmail.com> wrote:
> Do a small update to fix a dangerous bug.
>
> http://kgtp.googlecode.com/files/kgtp_20100823.tar.bz2
>
> Thanks,
> Hui
>
> On Sun, Aug 22, 2010 at 23:16, Hui Zhu <teawater@gmail.com> wrote:
>> Linux Kernel GDB tracepoint module support action X and all agent
>> expression except the trace state variable codes. So KGTP can support
>> a lot of collect command of tracepoint in x86-64 and x86-32.
>>
>> To get the new KGTP please goto http://code.google.com/p/kgtp/downloads/list
>>
>> To get more message about GDB tracepoint please goto
>> http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html
>>
>> For example:
>>
>> make
>> sudo insmod gtp.ko
>> sudo gdb ./vmlinux
>>
>> (gdb) trace vfs_readdir
>> Tracepoint 1 at 0xffffffff8113f7fc: file
>> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
>> (gdb) actions
>> Enter actions for tracepoint 1, one per line.
>> End with a line saying just "end".
>>>collect *(unsigned char *)$rsp@512
>>>collect *file
>>>end
>> (gdb) target remote /proc/gtp
>> Remote debugging using /proc/gtp
>> 0x0000000000000000 in ?? ()
>> (gdb) tstart
>> (gdb) shell ls
>> 2      block    firmware  i        ipc     Makefile
>> modules.order   scripts   source      t~    vmlinux
>> a.out  crypto   fs        include  kernel  mm
>> Module.symvers  security  System.map  usr   vmlinux.o
>> arch   drivers  gdb.txt   init     lib     modules.builtin  net
>>     sound     t           virt
>> (gdb) tstop
>> (gdb) tfind
>> Found trace frame 0, tracepoint 1
>> #0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
>> filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
>>    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
>> 24      {
>> (gdb) bt
>> #0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
>> filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
>>    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
>> #1  0xffffffff8113fa14 in sys_getdents (fd=<value optimized out>,
>> dirent=0x801108, count=32768)
>>    at /home/teawater/kernel/linux-2.6/fs/readdir.c:214
>> #2  0xffffffff8100af42 in ?? () at
>> /home/teawater/kernel/linux-2.6/arch/x86/kernel/entry_64.S:487
>> #3  0x00007f3249a81765 in ?? ()
>> #4  0x00000018555503f7 in ?? ()
>> #5  0x0000015400000000 in ?? ()
>> #6  0x0000000000bf5048 in ?? ()
>> #7  0x0000000000000000 in ?? ()
>> (gdb) p file
>> $1 = (struct file *) 0xffff880075f00780
>> (gdb) p *file
>> $2 = {f_u = {fu_list = {next = 0xffff880075f00480, prev =
>> 0xffffe8ffffc06948}, fu_rcuhead = {next = 0xffff880075f00480,
>>      func = 0xffffe8ffffc06948}}, f_path = {mnt = 0xffff880037d92e00,
>> dentry = 0xffff8800353239c0}, f_op = 0xffffffff81622a60, f_lock = {{
>>      rlock = {raw_lock = {slock = 0}}}}, f_sb_list_cpu = 0, f_count =
>> {counter = 2}, f_flags = 624640, f_mode = 29, f_pos = 0, f_owner = {
>>    lock = {raw_lock = {lock = 16777216}}, pid = 0x0, pid_type =
>> PIDTYPE_PID, uid = 0, euid = 0, signum = 0}, f_cred =
>> 0xffff880079b40a80,
>>  f_ra = {start = 0, size = 0, async_size = 0, ra_pages = 32,
>> mmap_miss = 0, prev_pos = -1}, f_version = 0, f_security = 0x0,
>>  private_data = 0x0, f_ep_links = {next = 0xffff880075f00828, prev =
>> 0xffff880075f00828}, f_mapping = 0xffff88003539d6b8}
>> (gdb) tfind
>> Found trace frame 1, tracepoint 1
>> 0xffffffff8113f7fd      24      {
>> (gdb) bt
>> #0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
>> filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
>>    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
>> #1  0xffffffff8113fa14 in sys_getdents (fd=<value optimized out>,
>> dirent=0x801108, count=32768)
>>    at /home/teawater/kernel/linux-2.6/fs/readdir.c:214
>> #2  0xffffffff8100af42 in ?? () at
>> /home/teawater/kernel/linux-2.6/arch/x86/kernel/entry_64.S:487
>> #3  0x00007f3249a81765 in ?? ()
>> #4  0x00000018555503f7 in ?? ()
>> #5  0x0000015400000000 in ?? ()
>> #6  0x0000000000bf5048 in ?? ()
>> #7  0x0000000000000000 in ?? ()
>> (gdb) p *file
>> $3 = {f_u = {fu_list = {next = 0xffff880075f00480, prev =
>> 0xffffe8ffffc06948}, fu_rcuhead = {next = 0xffff880075f00480,
>>      func = 0xffffe8ffffc06948}}, f_path = {mnt = 0xffff880037d92e00,
>> dentry = 0xffff8800353239c0}, f_op = 0xffffffff81622a60, f_lock = {{
>>      rlock = {raw_lock = {slock = 0}}}}, f_sb_list_cpu = 0, f_count =
>> {counter = 2}, f_flags = 624640, f_mode = 29, f_pos = 2147483647,
>>  f_owner = {lock = {raw_lock = {lock = 16777216}}, pid = 0x0,
>> pid_type = PIDTYPE_PID, uid = 0, euid = 0, signum = 0},
>>  f_cred = 0xffff880079b40a80, f_ra = {start = 0, size = 0, async_size
>> = 0, ra_pages = 32, mmap_miss = 0, prev_pos = -1}, f_version = 16,
>>  f_security = 0x0, private_data = 0xffff8800755d5600, f_ep_links =
>> {next = 0xffff880075f00828, prev = 0xffff880075f00828},
>>  f_mapping = 0xffff88003539d6b8}
>>
>
