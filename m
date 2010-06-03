Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0FCPR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:17:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:47710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab0FCPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:17:54 -0400
Date: Thu, 3 Jun 2010 17:17:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Reinette Chatre <reinette.chatre@intel.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: iwl3945 oops with latest git
Message-ID: <20100603151752.GB2053@tiehlicka.suse.cz>
References: <E1OKBva-00080h-8E@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OKBva-00080h-8E@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 03-06-10 17:01:50, Miklos Szeredi wrote:
> Hi,

Hi,

> 
> This oops comes shortly after booting machine and using wireless
> network.  Reproduced two times now.
> 
> Please let me know if you need more info.
> 
> Thanks,
> Miklos
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa022738f>] iwl3945_request_scan+0x961/0xd68 [iwl3945]

Sounds pretty much like https://patchwork.kernel.org/patch/103596/
I have similar problem but didn't get to testing the patch.

> PGD 0 
> Oops: 0000 [#1] PREEMPT SMP 
> last sysfs file: /sys/class/rfkill/rfkill1/state
> CPU 0 
> Modules linked in: nfs lockd nfs_acl sunrpc rfcomm sco bnep l2cap acpi_cpufreq mperf nf_conntrack_netbios_ns fuse iwl3945 iwlcore thinkpad_acpi nsc_ircc mac80211 backlight btusb led_class uinput ac irda battery crc_ccitt thermal cfg80211 bluetooth button processor e1000e rfkill kvm_intel kvm
> 
> Pid: 1493, comm: iwl3945 Not tainted 2.6.35-rc1-00194-gaef4b9a #76 2007FUG/2007FUG
> RIP: 0010:[<ffffffffa022738f>]  [<ffffffffa022738f>] iwl3945_request_scan+0x961/0xd68 [iwl3945]
> RSP: 0018:ffff8800b4d71d10  EFLAGS: 00010287
> RAX: ffff8800bea80c00 RBX: ffff8800b4171380 RCX: 0000000000000021
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800b4171380
> RBP: ffff8800b4d71de0 R08: 000000000000030e R09: 00000000ffffffff
> R10: 000000000ad21900 R11: 0000000000000292 R12: 0000000000000000
> R13: ffff8800b60950f2 R14: 0000000000000000 R15: 0000000000000058
> FS:  0000000000000000(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000001612000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process iwl3945 (pid: 1493, threadinfo ffff8800b4d70000, task ffff8800b6790940)
> Stack:
>  ffff880001a12f40 0000000000012f40 ffff8800b64f8800 ffffffff8161a378
> <0> 0000000000000000 ffff8800b6095000 00578800b4d71e20 0000005800000021
> <0> ffff8800b4d71fd8 00ff8800b4175128 ffff8800b4d71fd8 002188ffb6790940
> Call Trace:
>  [<ffffffffa01f9bb5>] iwl_bg_start_internal_scan+0x34f/0x371 [iwlcore]
>  [<ffffffff8104e175>] worker_thread+0x1fc/0x2a3
>  [<ffffffffa01f9866>] ? iwl_bg_start_internal_scan+0x0/0x371 [iwlcore]
>  [<ffffffff81051d96>] ? autoremove_wake_function+0x0/0x34
>  [<ffffffff813f4590>] ? _raw_spin_unlock_irqrestore+0x27/0x29
>  [<ffffffff8104df79>] ? worker_thread+0x0/0x2a3
>  [<ffffffff810518db>] kthread+0x7a/0x82
>  [<ffffffff81002c94>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81051861>] ? kthread+0x0/0x82
>  [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10
> Code: 48 b5 00 00 48 89 45 80 48 89 85 70 ff ff ff 41 8d 47 ff 66 89 85 66 ff ff ff e9 43 02 00 00 48 63 55 a8 4c 8b 64 d0 38 8b 55 a4 <41> 39 14 24 0f 85 2a 02 00 00 66 41 8b 54 24 06 48 89 df 41 88 
> RIP  [<ffffffffa022738f>] iwl3945_request_scan+0x961/0xd68 [iwl3945]
>  RSP <ffff8800b4d71d10>
> CR2: 0000000000000000
> ---[ end trace 63fe07b50f147114 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
