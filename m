Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1ARQTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:19:12 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65056 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1ARQTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Jb3EROtM/mcerScM+3uyj5Rl1PKYWUjltWMZne5fl+FO7qN7E8u0D4KgpnjUei2wIx
         eMqz9rYn2hH1Chx0aQdNp6cXBM5rv8+bsYBaHCwVZic6JHurbUIW2+7Sef5Ob/5CVOkU
         ExeSMF7J7dizI81kLtGV2eKBc7QdncLid1NNc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [REPORT] BUG: spinlock recursion on CPU#0, init/1
Date: Tue, 18 Jan 2011 17:19:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
In-Reply-To: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101181719.05608.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=27022
for your bug report, please add your address to the CC list in there, thanks!

On poniedziałek, 10 stycznia 2011 o 16:21:59 Santosh Shilimkar wrote:
> On latest mainline commit I seeing a regression when rootfs
> is mounted on NFS. Not sure if it's already known regression.
> 
> Anybody is aware of this one ?
> 
> --------------------------------------
> Uncompressing Linux... done, booting the kernel.
> Linux version 2.6.37-03766-g0390214 (a0393909@a0393909-desktop) (gcc
> version 4.4.1 (Sourcery G++ Lite 2010q1-202) ) #44 SMP Mon Jan 10 20:41:27
> IST 2011
> 
> [....]
> 
> VFS: Mounted root (nfs filesystem) on device 0:13.
> Freeing init memory: 296K
> BUG: spinlock recursion on CPU#0, init/1
>  lock: ef5a1e0c, .magic: dead4ead, .owner: init/1, .owner_cpu: 0
> [<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024ce90>]
> (do_raw_spin_lock+0x48/0x158)
> [<c024ce90>] (do_raw_spin_lock+0x48/0x158) from [<c012f4e0>]
> (nameidata_dentry_drop_rcu+0x84/0x17c)
> [<c012f4e0>] (nameidata_dentry_drop_rcu+0x84/0x17c) from [<c012f608>]
> (d_revalidate+0x30/0x58)
> [<c012f608>] (d_revalidate+0x30/0x58) from [<c0132120>]
> (link_path_walk+0xb44/0xb64)
> [<c0132120>] (link_path_walk+0xb44/0xb64) from [<c0132338>]
> (do_path_lookup+0x44/0xcc)
> [<c0132338>] (do_path_lookup+0x44/0xcc) from [<c0132f08>]
> (do_filp_open+0xc8/0x56c)
> [<c0132f08>] (do_filp_open+0xc8/0x56c) from [<c0124828>]
> (do_sys_open+0x58/0xe4)
> [<c0124828>] (do_sys_open+0x58/0xe4) from [<c005c240>]
> (ret_fast_syscall+0x0/0x3c)
> BUG: spinlock lockup on CPU#0, init/1, ef5a1e0c
> [<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024cf84>]
> (do_raw_spin_lock+0x13c/0x158)
> [<c024cf84>] (do_raw_spin_lock+0x13c/0x158) from [<c012f4e0>]
> (nameidata_dentry_drop_rcu+0x84/0x17c)
> [<c012f4e0>] (nameidata_dentry_drop_rcu+0x84/0x17c) from [<c012f608>]
> (d_revalidate+0x30/0x58)
> [<c012f608>] (d_revalidate+0x30/0x58) from [<c0132120>]
> (link_path_walk+0xb44/0xb64)
> [<c0132120>] (link_path_walk+0xb44/0xb64) from [<c0132338>]
> (do_path_lookup+0x44/0xcc)
> [<c0132338>] (do_path_lookup+0x44/0xcc) from [<c0132f08>]
> (do_filp_open+0xc8/0x56c)
> [<c0132f08>] (do_filp_open+0xc8/0x56c) from [<c0124828>]
> (do_sys_open+0x58/0xe4)
> [<c0124828>] (do_sys_open+0x58/0xe4) from [<c005c240>]
> (ret_fast_syscall+0x0/0x3c)
> BUG: spinlock lockup on CPU#1, kworker/u:2/499, c05d3c80
> [<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024cf84>]
> (do_raw_spin_lock+0x13c/0x158)
> [<c024cf84>] (do_raw_spin_lock+0x13c/0x158) from [<c014afac>]
> (exit_fs+0x2c/0x84)
> [<c014afac>] (exit_fs+0x2c/0x84) from [<c0098274>] (do_exit+0x254/0x674)
> [<c0098274>] (do_exit+0x254/0x674) from [<c00b0944>] (kthread+0x88/0x8c)
> [<c00b0944>] (kthread+0x88/0x8c) from [<c005d490>]
> (kernel_thread_exit+0x0/0x8)
> 
> --------------------------------------
> 
> Regards,
> Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
