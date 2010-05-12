Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0ELIdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:33:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46769 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0ELIdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YMJtBOKpO8ECI7CHzzp3i2B3Zj8okbI5hKghu9X0mq4L/1qpJ1UOuSDWf0kTwiw/Dk
         6NRfeAx1s0FWplI14l8AqsBsmdZiKes/D3+sLWsC/IMxeG3ccn6nteV8ce4fJZkfJ3Kw
         kAnJe1TFxDGvXqow7F4sS9gejzRgVQQI2bPHs=
Date: Wed, 12 May 2010 16:37:06 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?B?QW5kcsOp?= Goddard Rosa <andre.goddard@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sanchin Sant <sanchinp@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mqueue: fix kernel BUG caused by double free() on
 mq_open()
Message-ID: <20100512083706.GE5718@cr0.nay.redhat.com>
References: <17ea945f6d53443000524eb7cc5c4fc66ee3ecf8.1273396690.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17ea945f6d53443000524eb7cc5c4fc66ee3ecf8.1273396690.git.andre.goddard@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 06:22:28AM -0300, André Goddard Rosa wrote:
>
>kernel BUG at mm/slub.c:2846!
>invalid opcode: 0000 [#1] PREEMPT SMP
>last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
>CPU 0
>Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc vboxnetadp vboxnetflt vboxdrv af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq binfmt_misc fuse loop arc4 snd_hda_codec_idt ecb iwl3945 snd_hda_intel iwlcore snd_hda_codec uvcvideo snd_hwdep snd_pcm videodev mac80211 snd_timer v4l1_compat snd v4l2_compat_ioctl32 i2c_i801 ide_cd_mod cfg80211 soundcore video sony_laptop snd_page_alloc rfkill i2c_core cdrom output sg joydev serio_raw pcspkr ac battery button usbhid hid sd_mod uhci_hcd ahci libata rtc_cmos rtc_core rtc_lib scsi_mod ehci_hcd usbcore fan processor piix ide_core thermal thermal_sys hwmon
>
>Pid: 2743, comm: a.out Not tainted 2.6.34-rc7-3.2-default #252 VAIO/VGN-FZ15L
>RIP: 0010:[<ffffffff810c94d1>]  [<ffffffff810c94d1>] kfree+0xa1/0xb0
>RSP: 0018:ffff880073321dc8  EFLAGS: 00010246
>RAX: ffffea000191ca00 RBX: ffff880073150708 RCX: ffff8800731503a8
>RDX: 4000000000080000 RSI: ffffffff81609520 RDI: ffff880072cc0000
>RBP: ffff880072cc0000 R08: 00000000000004c0 R09: 0000000000000001
>R10: ffff880001622550 R11: ffff880073150700 R12: ffff880073150708
>R13: ffffffff814f84e0 R14: 00000000000fde80 R15: ffff880073150700
>FS:  00007fd6845616f0(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 00007fd684194fe0 CR3: 000000007e0a4000 CR4: 00000000000006f0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>Process a.out (pid: 2743, threadinfo ffff880073320000, task ffff88007dd5f800)
>Stack:
>0000000000000040 ffff880073150708 ffff880073150700 ffffffff811e0012
><0> ffff880073150708 ffffffff813cb200 ffffffff814f0820 0000000000124f80
><0> 00000000000fde80 ffffffff810e47ec ffff880073150708 0000000000000000
>Call Trace:
>[<ffffffff811e0012>] ? mqueue_delete_inode+0x92/0x120
>[<ffffffff810e47ec>] ? generic_delete_inode+0x8c/0x130
>[<ffffffff811e0322>] ? mqueue_get_inode+0x282/0x290
>[<ffffffff811e0430>] ? mqueue_create+0x90/0x190
>[<ffffffff810d8eec>] ? vfs_create+0xac/0xd0
>[<ffffffff811e0ae2>] ? sys_mq_open+0x5b2/0x710
>[<ffffffff81002eab>] ? system_call_fastpath+0x16/0x1b
>Code: 5d c3 48 89 ea 48 89 c6 e8 ed fa ff ff eb ea 66 f7 c2 00 c0 74 15 41 5b 48 89 c7 5b 5d e9 c8 75 fd ff 48 8b 40 10 48 8b 10 eb 90 <0f> 0b eb fe 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 48 81
>
>Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
>---
> ipc/mqueue.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>
>diff --git a/ipc/mqueue.c b/ipc/mqueue.c
>index 722b013..77a3c8e 100644
>--- a/ipc/mqueue.c
>+++ b/ipc/mqueue.c
>@@ -159,6 +159,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
> 			    task_rlimit(p, RLIMIT_MSGQUEUE)) {
> 				spin_unlock(&mq_lock);
> 				kfree(info->messages);
>+				info->messages = NULL;
> 				goto out_inode;
> 			}

In the latest git, you already removed the above kfree() since it is
not necessary. mqueue_delete_inode() will kfree it.
so why this fix though?

Thanks.
