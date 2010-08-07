Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502Ab0HGDVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 23:21:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55424 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0HGDVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 23:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:organization:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=pPvtvFeEUTQeUru2AEIgHACt+PIlrOFnohnvN1ozGtSxP6YKNjFalZfbM/ezaXZivf
         fekGn8R9vWBVps/XIvINIyyQm9cb2Eog3fovOGn3EE/2Spo2G11Y9hGdvGP/uiFD9Y3b
         91qKjOicfk5GLfcnUEJqnz4iu3kzQIEsF8R70=
Date: Sat, 7 Aug 2010 19:21:22 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: TTY: warning in tty_lock on 2.6.35+gregkh tree
Message-ID: <20100807192122.2005c856@tom-lei>
Organization: private
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Following the ttty warning during kernel boot, seems it is for a long time
in gregkh's tree.

[    0.660082] ------------[ cut here ]------------
[    0.660088] WARNING: at include/linux/tty.h:590 tty_lock+0x24/0x3e()
[    0.660089] Hardware name:        
[    0.660091] Modules linked in:
[    0.660094] Pid: 1, comm: swapper Not tainted 2.6.35-gkh-wl+ #51
[    0.660096] Call Trace:
[    0.660101]  [<ffffffff8104766a>] warn_slowpath_common+0x80/0x98
[    0.660105]  [<ffffffff81047697>] warn_slowpath_null+0x15/0x17
[    0.660108]  [<ffffffff8123a5a3>] tty_lock+0x24/0x3e
[    0.660111]  [<ffffffff8123d69c>] tty_open+0x60/0x4a4
[    0.660115]  [<ffffffff810e81be>] chrdev_open+0x134/0x155
[    0.660118]  [<ffffffff810e808a>] ? chrdev_open+0x0/0x155
[    0.660122]  [<ffffffff810e4074>] __dentry_open+0x147/0x27d
[    0.660125]  [<ffffffff810e426f>] nameidata_to_filp+0x3a/0x4b
[    0.660137]  [<ffffffff810ef69c>] do_last+0x472/0x5b9
[    0.660140]  [<ffffffff810efc1b>] do_filp_open+0x1ee/0x5f1
[    0.660144]  [<ffffffff8106164a>] ? sched_clock_cpu+0xc3/0xce
[    0.660147]  [<ffffffff8106aba1>] ? lockstat_clock+0x11/0x13
[    0.660151]  [<ffffffff8136ff42>] ? _raw_spin_unlock+0x3e/0x4c
[    0.660155]  [<ffffffff810f99f5>] ? alloc_fd+0x111/0x123
[    0.660158]  [<ffffffff810e3e44>] do_sys_open+0x5e/0x10a
[    0.660162]  [<ffffffff81059765>] ? flush_workqueue+0x0/0xa7
[    0.660166]  [<ffffffff810e3f19>] sys_open+0x1b/0x1d
[    0.660170]  [<ffffffff81892745>] kernel_init+0x1b5/0x222
[    0.660174]  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
[    0.660177]  [<ffffffff81370694>] ? restore_args+0x0/0x30
[    0.660181]  [<ffffffff81892590>] ? kernel_init+0x0/0x222
[    0.660183]  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
[    0.660185] ---[ end trace f777fed7c0166a97 ]---
[    0.660369] ------------[ cut here ]------------
[    0.660372] WARNING: at include/linux/tty.h:590 tty_lock+0x24/0x3e()
[    0.660374] Hardware name:        
[    0.660375] Modules linked in:
[    0.660378] Pid: 1, comm: swapper Tainted: G        W   2.6.35-gkh-wl+ #51
[    0.660379] Call Trace:
[    0.660382]  [<ffffffff8104766a>] warn_slowpath_common+0x80/0x98
[    0.660386]  [<ffffffff81047697>] warn_slowpath_null+0x15/0x17
[    0.660388]  [<ffffffff8123a5a3>] tty_lock+0x24/0x3e
[    0.660391]  [<ffffffff8123dab9>] tty_open+0x47d/0x4a4
[    0.660394]  [<ffffffff810e81be>] chrdev_open+0x134/0x155
[    0.660397]  [<ffffffff810e808a>] ? chrdev_open+0x0/0x155
[    0.660399]  [<ffffffff810e4074>] __dentry_open+0x147/0x27d
[    0.660402]  [<ffffffff810e426f>] nameidata_to_filp+0x3a/0x4b
[    0.660405]  [<ffffffff810ef69c>] do_last+0x472/0x5b9
[    0.660408]  [<ffffffff810efc1b>] do_filp_open+0x1ee/0x5f1
[    0.660411]  [<ffffffff8106164a>] ? sched_clock_cpu+0xc3/0xce
[    0.660414]  [<ffffffff8106aba1>] ? lockstat_clock+0x11/0x13
[    0.660417]  [<ffffffff8136ff42>] ? _raw_spin_unlock+0x3e/0x4c
[    0.660420]  [<ffffffff810f99f5>] ? alloc_fd+0x111/0x123
[    0.660430]  [<ffffffff810e3e44>] do_sys_open+0x5e/0x10a
[    0.660433]  [<ffffffff81059765>] ? flush_workqueue+0x0/0xa7
[    0.660437]  [<ffffffff810e3f19>] sys_open+0x1b/0x1d
[    0.660440]  [<ffffffff81892745>] kernel_init+0x1b5/0x222
[    0.660443]  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
[    0.660446]  [<ffffffff81370694>] ? restore_args+0x0/0x30
[    0.660449]  [<ffffffff81892590>] ? kernel_init+0x0/0x222
[    0.660452]  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
[    0.660454] ---[ end trace f777fed7c0166a98 ]---
