Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418Ab2J2SlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:41:07 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34087 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2J2SlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:41:04 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] 3.7-rc2 [ INFO: suspicious RCU usage. ]
Date: Mon, 29 Oct 2012 19:40:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc3; KDE/4.8.4; x86_64; ; )
References: <201210232012.25163.maciej.rutecki@gmail.com>
In-Reply-To: <201210232012.25163.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210291940.59657.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 23 października 2012 o 20:12:25 Maciej Rutecki wrote:
> Got during normal boot:
> [    0.748900] ===============================
> [    0.748948] [ INFO: suspicious RCU usage. ]
> [    0.748997] 3.7.0-rc2 #1 Not tainted
> [    0.749045] -------------------------------
> [    0.749094] include/linux/cgroup.h:566 suspicious
> rcu_dereference_check() usage!
> [    0.749149]
> [    0.749149] other info that might help us debug this:
> [    0.749149]
> [    0.749207]
> [    0.749207] rcu_scheduler_active = 1, debug_locks = 0
> [    0.749260] 2 locks held by kdevtmpfs/29:
> [    0.749308]  #0:  (sb_writers){.+.+.+}, at: [<ffffffff81133b22>]
> mnt_want_write+0x1f/0x46
> [    0.749570]  #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at:
> [<ffffffff811250fa>] kern_path_create+0x7e/0x13f
> [    0.749919]
> [    0.749919] stack backtrace:
> [    0.749970] Pid: 29, comm: kdevtmpfs Not tainted 3.7.0-rc2 #1
> [    0.750022] Call Trace:
> [    0.750084]  [<ffffffff8108654b>] lockdep_rcu_suspicious+0x109/0x112
> [    0.750152]  [<ffffffff811ed588>]
> task_subsys_state.constprop.6+0x68/0x70 [    0.750219] 
> [<ffffffff811edce1>] devcgroup_inode_mknod+0x20/0x9b [    0.750287] 
> [<ffffffff811d6721>] ? security_capable+0x13/0x15
> [    0.750353]  [<ffffffff81049c49>] ? ns_capable+0x48/0x60
> [    0.750418]  [<ffffffff811255d0>] vfs_mknod+0x61/0xae
> [    0.750483]  [<ffffffff8132ce74>] handle_create.isra.2+0x13f/0x1b0
> [    0.750549]  [<ffffffff8132cf8e>] ? devtmpfsd+0xa9/0x156
> [    0.750614]  [<ffffffff81088371>] ? lock_release+0x164/0x1aa
> [    0.750679]  [<ffffffff8132cee5>] ? handle_create.isra.2+0x1b0/0x1b0
> [    0.750746]  [<ffffffff8132cfd3>] devtmpfsd+0xee/0x156
> [    0.750809]  [<ffffffff8132cee5>] ? handle_create.isra.2+0x1b0/0x1b0
> [    0.750876]  [<ffffffff8105d10a>] kthread+0xac/0xb4
> [    0.750939]  [<ffffffff8105d05e>] ? __kthread_parkme+0x60/0x60
> [    0.751006]  [<ffffffff814877bc>] ret_from_fork+0x7c/0xb0
> [    0.751070]  [<ffffffff8105d05e>] ? __kthread_parkme+0x60/0x60
> 
> 
> Last known good kernel: 3.6.1
> 
> lspci:
> http://mrutecki.pl/download/kernel/3.7-rc2/leon/lspci.txt
> 
> dmesg:
> http://mrutecki.pl/download/kernel/3.7-rc2/leon/dmesg-3.7-rc2.txt
> 
> Regards

It seems that in -rc3 warning has gone.
Regards

-- 
Maciej Rutecki
http://www.mrutecki.pl
