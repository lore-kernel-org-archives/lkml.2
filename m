Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0ICJGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:06:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52645 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0ICJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kQhfauwLhavhCqsSForRCQuXai4WP7GFbP4Nspaj0fbAp+k3vqi8GqXpNcRhhq2Nx8
         dqXDh1MXk10C7m7D0HTVe9pHBS4W38Bn99F6i6yVSWO1kc1skr8Mez65aSApjURbQOf2
         sMpxg5SokvAJp9m8NBoCCSkgLKYcQnL5Rfhbw=
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
From: Steven <mqyoung@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
In-Reply-To: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 17:06:08 +0800
Message-ID: <1283504768.2100.43.camel@steven>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hui,

I encountered two issue when I use your GTP.

1) Following your HOWTO, I collect the two variables jiffies_64(global),
*file(argument), the result are as following, where you may see
jiffies_64 = 4298520928, that's OK, but the members of *file are all 0.
What's the problem? Thank you very much!
        -------------------------------------------------------------------
        (gdb) trace vfs_readdir 
        Tracepoint 3 at 0xc1175690: file fs/readdir.c, line 23.
        (gdb) actions
        Enter actions for tracepoint 3, one per line.
        End with a line saying just "end".
        > collect jiffies_64
        > collect *file
        > end
        (gdb) tstart
        (gdb) tstop
        (gdb) tfind
        #0  0xc1175691 i (file=0x0, filler=0, buf=0x0) at
        fs/readdir.c:23
        23      {
        (gdb) p jiffies_64
        $7 = 4298520928
        (gdb) p *file
        $8 = {f_u = {fu_list = {next = 0x0, prev = 0x0}, fu_rcuhead =
        {next = 0x0, func = 0}}, f_path = {mnt = 0x0, dentry = 0x0},
        f_op = 0x0, f_lock = {{ rlock = {raw_lock = {slock = 0}}}},
        f_count = {counter = 0}, f_flags = 0, f_mode = 0, f_pos = 0,
        f_owner = {lock = {raw_lock = { lock = 0}}, pid = 0x0, pid_type
        = PIDTYPE_PID, uid = 0, euid = 0, signum = 0}, f_cred = 0x0,
        f_ra = {stra_pages = 00, f_security = 0x0, private_data = 0x0,
        f_ep_links = {next = 0x0, prev = 0x0}, f_mapping = 0x0}
        -------------------------------------------------------------------


2) I can not collect local variable, despite I rebuild the kernel with
-O0 optimization option. what is the problem? Many thanks
        -------------------------------------------------------------------
        (gdb) trace fs/readdir.c:29
        Tracepoint 2 at 0xc11756ca: file fs/readdir.c, line 29.
        (gdb) actions 
        Enter actions for tracepoint 2, one per line.
        End with a line saying just "end".
        > collect res
        > end
        (gdb) tstart
        res: don't know symbol class 20
        -------------------------------------------------------------------
        
        Code fragment of readdir.c
        -------------------------------------------------------------------
         22 int vfs_readdir(struct file *file, filldir_t filler, void
        *buf)
         23 {
         24         struct inode *inode = file->f_path.dentry->d_inode;
         25         int res = -ENOTDIR;
         26         if (!file->f_op || !file->f_op->readdir)
         27                 goto out;
         28 
         29         res = security_file_permission(file, MAY_READ);
         30         if (res)
         31                 goto out;
        -------------------------------------------------------------------

Best Regards,
Steven


On Mon, 2010-08-30 at 15:00 +0800, Hui Zhu wrote:
> http://kgtp.googlecode.com/files/kgtp_20100830.tar.bz2
> or
> svn co https://kgtp.googlecode.com/svn/tags/20100830
> to get it.
> 
> Fix bug in ref16, ref32, ref64 in issue
> https://code.google.com/p/kgtp/issues/detail?id=2
> Fix bug that disable some tracepoint will make "tstart" get error.
> 
> Support qtstatus. Then KGTP support GDB command "tstatus".
> Add support for "make install" and "make uninstall".
> Add support for qtro. Fix a bug about GTP_GDBRSP_REG_SIZE.
> 
> Change gtp_list make it more efficient.
> 
> Please goto http://code.google.com/p/kgtp/wiki/HOWTO to get more info
> about how to use KGTP.


