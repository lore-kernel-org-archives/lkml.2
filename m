Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0IDDmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 23:42:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46204 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab0IDDmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 23:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wAWiUvxau/UTd7vjOR8O5yeFryM4aXsfIArkg+blgEjuGZbXTw/GnvXk9NqnUCM0Jt
         AQyKclm7sv1+1M2QMBVQVocdCGIadqEyG5WclN4q17lkW3P+vDDFQ3Sqe/ciAZHoQqpN
         BPDby2PvtzKOFMhUd3KPkjUCo1JuDydIu9UWY=
MIME-Version: 1.0
In-Reply-To: <1283504768.2100.43.camel@steven>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com> <1283504768.2100.43.camel@steven>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 4 Sep 2010 11:41:57 +0800
Message-ID: <AANLkTik=0wMHh9fg8_vK_Aor40J43mNojvfHadhHObKA@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
To: Steven <mqyoung@gmail.com>
Cc: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Fri, Sep 3, 2010 at 17:06, Steven <mqyoung@gmail.com> wrote:
> Dear Hui,
>
> I encountered two issue when I use your GTP.
>
> 1) Following your HOWTO, I collect the two variables jiffies_64(global),
> *file(argument), the result are as following, where you may see
> jiffies_64 = 4298520928, that's OK, but the members of *file are all 0.
> What's the problem? Thank you very much!
>        -------------------------------------------------------------------
>        (gdb) trace vfs_readdir
>        Tracepoint 3 at 0xc1175690: file fs/readdir.c, line 23.
>        (gdb) actions
>        Enter actions for tracepoint 3, one per line.
>        End with a line saying just "end".
>        > collect jiffies_64
>        > collect *file
>        > end
>        (gdb) tstart
>        (gdb) tstop
>        (gdb) tfind
>        #0  0xc1175691 i (file=0x0, filler=0, buf=0x0) at
>        fs/readdir.c:23
>        23      {
>        (gdb) p jiffies_64
>        $7 = 4298520928
>        (gdb) p *file
>        $8 = {f_u = {fu_list = {next = 0x0, prev = 0x0}, fu_rcuhead =
>        {next = 0x0, func = 0}}, f_path = {mnt = 0x0, dentry = 0x0},
>        f_op = 0x0, f_lock = {{ rlock = {raw_lock = {slock = 0}}}},
>        f_count = {counter = 0}, f_flags = 0, f_mode = 0, f_pos = 0,
>        f_owner = {lock = {raw_lock = { lock = 0}}, pid = 0x0, pid_type
>        = PIDTYPE_PID, uid = 0, euid = 0, signum = 0}, f_cred = 0x0,
>        f_ra = {stra_pages = 00, f_security = 0x0, private_data = 0x0,
>        f_ep_links = {next = 0x0, prev = 0x0}, f_mapping = 0x0}
>        -------------------------------------------------------------------
>

It looks like a old bug that I have fixed in new version.
I try it in 20100830 version cannot reproduce this issue:
(gdb) target remote /proc/gtp
Remote debugging using /proc/gtp
0x0000000000000000 in ?? ()
(gdb) trace vfs_readdir
Tracepoint 1 at 0xffffffff81147d3c: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
(gdb) actions
Enter actions for tracepoint 1, one per line.
End with a line saying just "end".
>collect jiffies_64
>collect *file
>end
(gdb) tstart
(gdb) sh
sharedlibrary  shell          show
(gdb) shell ls
2      block	firmware  i	   ipc	   Makefile	    modules.order
scripts   source	  t~	vmlinux
a.out  crypto	fs	  include  kernel  mm		    Module.symvers  security
System.map  usr	vmlinux.o
arch   drivers	gdb.txt   init	   lib	   modules.builtin  net		
sound     t		  virt
(gdb) tstop
(gdb) tfind
Found trace frame 0, tracepoint 1
#0  0xffffffff81147d3d in vfs_readdir (file=0xffff88007b22bcc0,
filler=0xffffffff81147ba0 <filldir>, buf=0xffff88006cc31f38)
    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
24	{
(gdb) p jiffies_64
$1 = 4295113995
(gdb) p *file
$2 = {f_u = {fu_list = {next = 0xffff88007b22b480, prev =
0xffffe8ffffc86960}, fu_rcuhead = {next = 0xffff88007b22b480,
      func = 0xffffe8ffffc86960}}, f_path = {mnt = 0xffff880037bd6b00,
dentry = 0xffff88007e15b6c0}, f_op = 0xffffffff81622b00, f_lock = {{
      rlock = {raw_lock = {slock = 0}}}}, f_sb_list_cpu = 1, f_count =
{counter = 2}, f_flags = 624640, f_mode = 29, f_pos = 0, f_owner = {
    lock = {raw_lock = {lock = 16777216}}, pid = 0x0, pid_type =
PIDTYPE_PID, uid = 0, euid = 0, signum = 0}, f_cred =
0xffff88007ae6f780,
  f_ra = {start = 0, size = 0, async_size = 0, ra_pages = 32,
mmap_miss = 0, prev_pos = -1}, f_version = 0, f_security = 0x0,
  private_data = 0x0, f_ep_links = {next = 0xffff88007b22bd68, prev =
0xffff88007b22bd68}, f_mapping = 0xffff880036662590}


Could you try the new version?  I think it will work OK.

If you still meet this issue, maybe you can try with the new GDB from
http://www.gnu.org/software/gdb/download/ANNOUNCEMENT


>
> 2) I can not collect local variable, despite I rebuild the kernel with
> -O0 optimization option. what is the problem? Many thanks
>        -------------------------------------------------------------------
>        (gdb) trace fs/readdir.c:29
>        Tracepoint 2 at 0xc11756ca: file fs/readdir.c, line 29.
>        (gdb) actions
>        Enter actions for tracepoint 2, one per line.
>        End with a line saying just "end".
>        > collect res
>        > end
>        (gdb) tstart
>        res: don't know symbol class 20

This error is from GDB, I think it's a GDB bug, I will try to find out
the root cause.

BTW, looks GCC and GDB don't want handle the optimization debug
trouble (all they want is rewrite the GCC in C++ :P).
So I think make linux kernel can close optimization is better idea, do
you know some way or some patch to do it?


The MIPS support that you interest is check in to the KGTP truck.  I
just try it with a mips32el board.
To cross-compile it, you need set the CROSS_COMPILE ,KERNELDIR and
ARCH in Makefile.

Thanks,
Hui





>        -------------------------------------------------------------------
>
>        Code fragment of readdir.c
>        -------------------------------------------------------------------
>         22 int vfs_readdir(struct file *file, filldir_t filler, void
>        *buf)
>         23 {
>         24         struct inode *inode = file->f_path.dentry->d_inode;
>         25         int res = -ENOTDIR;
>         26         if (!file->f_op || !file->f_op->readdir)
>         27                 goto out;
>         28
>         29         res = security_file_permission(file, MAY_READ);
>         30         if (res)
>         31                 goto out;
>        -------------------------------------------------------------------
>
> Best Regards,
> Steven
>
>
> On Mon, 2010-08-30 at 15:00 +0800, Hui Zhu wrote:
>> http://kgtp.googlecode.com/files/kgtp_20100830.tar.bz2
>> or
>> svn co https://kgtp.googlecode.com/svn/tags/20100830
>> to get it.
>>
>> Fix bug in ref16, ref32, ref64 in issue
>> https://code.google.com/p/kgtp/issues/detail?id=2
>> Fix bug that disable some tracepoint will make "tstart" get error.
>>
>> Support qtstatus. Then KGTP support GDB command "tstatus".
>> Add support for "make install" and "make uninstall".
>> Add support for qtro. Fix a bug about GTP_GDBRSP_REG_SIZE.
>>
>> Change gtp_list make it more efficient.
>>
>> Please goto http://code.google.com/p/kgtp/wiki/HOWTO to get more info
>> about how to use KGTP.
>
>
>
