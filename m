Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0CaT7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:59:47 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61648 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab0CaT7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=i8NL2lCafX8GW1iN+E93qvpmxjoZ2fLfxPNGReSVBajT1r0iYz/JWJthsv0OOXDYaS
         rFx3+m10it0D/vtH9lKul+q6ICMZ3WIAhbA1ZDAcXDGhQua9EEutrsvC7CsqoymU6D6F
         PpV+M0yICLrAT1uC1HAbpxjqQOPhMby9t9Dvs=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: PROBLEM: crash on halt with 2.6.34-0.16.rc2.git0.fc14.x86_64
Date: Wed, 31 Mar 2010 21:59:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2; KDE/4.3.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <1269617372.3779.234.camel@localhost>
In-Reply-To: <1269617372.3779.234.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003312159.38098.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 26 marca 2010 o 16:29:32 Jon Masters wrote:
> No analysis yet. Just passing this along.
> 
> Jon.
> 
> --- begin oops log ---
> 
> Halting system...
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000004
> IP: [<ffffffff81017e7b>] amd_pmu_cpu_offline+0x38/0x6b
> PGD 741d5067 PUD 77715067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtual/block/dm-1/dm/name
> CPU 0
> Modules linked in: sit tunnel4 tun sunrpc powernow_k8 freq_table bridge
> stp llc nf_conntrack_netbios_ns ip6t_REJECT nf_conntrack_ipv6 ipv6
> kvm_amd kvm uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_seq snd_seq_device snd_pcm ppdev parport_pc parport r8169
> snd_timer mii snd edac_core soundcore microcode serio_raw snd_page_alloc
> edac_mce_amd k8temp i2c_nforce2 hwmon ata_generic pata_acpi
> firewire_ohci firewire_core crc_itu_t floppy sata_nv pata_amd nouveau
> ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded:
> cpufreq_ondemand]
> 
> Pid: 2792, comm: halt Not tainted 2.6.34-0.16.rc2.git0.fc14.x86_64 #1
> www.abit.com.tw  /System Product Name
> RIP: 0010:[<ffffffff81017e7b>]  [<ffffffff81017e7b>] amd_pmu_cpu_offline
> +0x38/0x6b
> RSP: 0018:ffff880024289ca8  EFLAGS: 00010292
> RAX: ffff880024124900 RBX: ffff88000520cc70 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81017e74 RDI: ffffffff81488830
> RBP: ffff880024289cb8 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000046 R11: ffffe8ffffc01980 R12: 00000000fffffffd
> R13: ffffffff81ac70c0 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007f7ec4f8a700(0000) GS:ffff880005000000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000004 CR3: 0000000077381000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process halt (pid: 2792, threadinfo ffff880024288000, task
> ffff880024124900)
> Stack:
>  ffff880024289cb8 0000000000000017 ffff880024289cc8 ffffffff8147fbb0
> <0> ffff880024289d18 ffffffff8148dede 0000000000000001 ffffffffa0294020
> <0> ffff880024289d28 0000000000000001 ffffffff81ba1de0 0000000000000010
> Call Trace:
>  [<ffffffff8147fbb0>] x86_pmu_notifier+0x52/0x59
>  [<ffffffff8148dede>] notifier_call_chain+0x68/0x9c
>  [<ffffffff81070b21>] raw_notifier_call_chain+0x14/0x16
>  [<ffffffff81471efc>] _cpu_down+0x1bb/0x2bf
>  [<ffffffff81051d71>] disable_nonboot_cpus+0x7a/0x112
>  [<ffffffff8106593e>] kernel_power_off+0x26/0x40
>  [<ffffffff81065c02>] sys_reboot+0x126/0x1b2
>  [<ffffffff811316bf>] ? __d_free+0x56/0x5a
>  [<ffffffff811316fa>] ? d_free+0x37/0x50
>  [<ffffffff81138ad0>] ? mntput_no_expire+0x2c/0xfd
>  [<ffffffff81122ab7>] ? __fput+0x1d0/0x1df
>  [<ffffffff8111f7b8>] ? sys_close+0x32/0x10f
>  [<ffffffff81129fb7>] ? path_put+0x22/0x27
>  [<ffffffff810a875a>] ? audit_syscall_entry+0x11e/0x14a
>  [<ffffffff81489c15>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> Code: 76 b8 00 01 76 54 48 63 ff 48 c7 c3 70 cc 00 00 48 03 1c fd 40 fa
> b9 81 48 c7 c7 40 b5 a4 81 e8 f9 1f 47 00 48 8b 93 28 07 00 00 <8b> 42
> 04 ff c8 85 c0 89 42 04 75 0c 48 8b bb 28 07 00 00 e8 b5
> RIP  [<ffffffff81017e7b>] amd_pmu_cpu_offline+0x38/0x6b
>  RSP <ffff880024289ca8>
> CR2: 0000000000000004
> ---[ end trace 7d3f5b5a80d53cb0 ]---
> init: rc main process (2792) killed by KILL signal
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15661
for your bug report, please add your address to the CC list in there, thanks! 

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
