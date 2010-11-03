Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0KCWcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:32:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41771 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0KCWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IopFcgJRAym7COoI2lul8Xzs1iSJt8BK/RR/nZub6c9nj48fCPGBdROsP1HeN/BOU9
         nazVKq+8E4O4c8MzOm5QBf6M4/EvIH5zp0HrrNWWTnLp8dVmi6NxYwajSgNruOmmRK7Z
         8elBZhrHyh3oE1KHrgRAI+73mtyLsZ2qwR478=
Message-ID: <4CD1E2D9.20007@gmail.com>
Date: Thu, 04 Nov 2010 06:31:53 +0800
From: Li Zefan <lizf.kern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101006 Thunderbird/3.1.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>, Thomas Graf <tgraf@suug.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: Linux 2.6.37-rc1 (net/sched: cls_cgroup)
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>	 <20101103142156.73c2d3c9.randy.dunlap@oracle.com> <1288821677.2718.27.camel@edumazet-laptop> <4CD1DFEC.1080209@gmail.com>
In-Reply-To: <4CD1DFEC.1080209@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> On 2010年11月04日 06:01, Eric Dumazet wrote:
>> Le mercredi 03 novembre 2010 à 14:21 -0700, Randy Dunlap a écrit :
>>> Maybe this isn't normal usage:  just modprobe cls_cgroup && rmmod cls_cgroup:
>>>
>>>
>>> [  107.806607] ------------[ cut here ]------------
>>> [  107.810180] kernel BUG at /local/linsrc/lnx-2637-rc1/kernel/cgroup.c:3855!
>>> [  107.810180] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>>> [  107.822274] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/devnum
>>> [  107.824889] CPU 0 
>>> [  107.832854] Modules linked in: cls_cgroup(-) ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97_codec ac97_bus usbmouse snd_seq snd_seq_device usbkbd usbhid snd_pcm ppdev hid tg3 led_class snd_timer dcdbas sr_mod snd iTCO_wdt cdrom iTCO_vendor_support sg rtc_cmos pcspkr soundcore i2c_i801 rng_core snd_page_alloc rtc_core parport_pc shpchp evdev rtc_lib parport 8250_pnp pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmwar
e
> _c!
>>>  lass ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
>>> [  107.933458] 
>>> [  107.933458] Pid: 3400, comm: rmmod Not tainted 2.6.37-rc1 #7 0HH807/OptiPlex GX620               
>>> [  107.937800] RIP: 0010:[<ffffffff810e6c9d>]  [<ffffffff810e6c9d>] cgroup_unload_subsys+0x64/0x1c8
>>> [  107.937800] RSP: 0018:ffff88006c107ea8  EFLAGS: 00010202
>>> [  107.937800] RAX: 0000000000000000 RBX: ffffffffa0009d50 RCX: 0000000000000000
>>> [  107.937800] RDX: ffffffff81a3a5f0 RSI: ffff88006c107dc8 RDI: ffff88006c107e48
>>> [  107.937800] RBP: ffff88006c107ec8 R08: ffffffff81a3a5f0 R09: 000000000000039a
>>> [  107.937800] R10: 0000000000000001 R11: ffff88006c107e48 R12: 0000000000000000
>>> [  107.937800] R13: 00007fff2664ffc0 R14: 0000000000000000 R15: 0000000000000001
>>> [  107.937800] FS:  00007f52809e46f0(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
>>> [  107.937800] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [  107.937800] CR2: 0000003fb5a7bf20 CR3: 000000006c1d8000 CR4: 00000000000006f0
>>> [  107.937800] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [  107.937800] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [  107.937800] Process rmmod (pid: 3400, threadinfo ffff88006c106000, task ffff880075a33000)
>>> [  107.937800] Stack:
>>> [  107.937800]  ffff88006c107ec8 ffffffffa000a0e0 0000000000000000 00007fff2664ffc0
>>> [  107.937800]  ffff88006c107ed8 ffffffffa0009819 ffff88006c107f78 ffffffff810d3cb0
>>> [  108.048442]  ffffffffa000a0e0 0000000000000880 ffff88006c107f14 ffffffff8155036b
>>> [  108.057485] Call Trace:
>>> [  108.065148]  [<ffffffffa0009819>] exit_cgroup_cls+0x45/0x4e [cls_cgroup]
>>> [  108.070071]  [<ffffffff810d3cb0>] sys_delete_module+0x2d6/0x368
>>> [  108.085255]  [<ffffffff8155036b>] ? lockdep_sys_exit_thunk+0x35/0x67
>>> [  108.093771]  [<ffffffff81007075>] ? xen_zap_pfn_range+0x53/0x139
>>> [  108.101589]  [<ffffffff815502f5>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [  108.111624]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
>>> [  108.119099] Code: 05 51 8d 71 01 0f 0b eb fe 31 f6 48 c7 c7 a0 a5 a3 81 48 ff 05 45 8d 71 01 e8 42 83 46 00 83 7b 58 07 7f 0b 48 ff 05 43 8d 71 01 <0f> 0b eb fe 48 ff 05 40 8d 71 01 48 8d bb 30 01 00 00 48 63 43 
>>> [  108.145840] RIP  [<ffffffff810e6c9d>] cgroup_unload_subsys+0x64/0x1c8
>>> [  108.152902]  RSP <ffff88006c107ea8>
>>> [  108.161767] ---[ end trace 659fde6f8f5f2810 ]---
>>>
>>>
>>>
>>> kernel config file is attached (almost allmodconfig).
>>> There may be some CONFIG options that are not helping...
>>>
>>> ---
>>
>> commits 8e039d84b323c450 
>> (cgroups: net_cls as module)
>>
>> followed by commit f845172531f
>> (cls_cgroup: Store classid in struct sock)
>>
>> are the problem :
>>
>> if CONFIG_NET_CLS_CGROUP is not defined
>>
>> exit_cgroup_cls() does :
>>
>> #ifndef CONFIG_NET_CLS_CGROUP
>> 	net_cls_subsys_id = -1;  <<< -1
>> 	synchronize_rcu();
>> #endif
>> 	cgroup_unload_subsys(&net_cls_subsys);
>>
>>
>> but net_cls_subsys_id is an alias of net_cls_subsys.subsys_id
>>
>> so putting -1 in it triggers BUG_ON() on line 3855 of kernel/cgroup.c
>>
>> BUG_ON(ss->subsys_id < CGROUP_BUILTIN_SUBSYS_COUNT);
>>
>> Herbert, I'll let you fix it ?
>>
> 
> Exactly what I was going to reply. This bug report also reveals
> another bug..
> 
> I'll post fixes for the 2 bugs in minutes.

Sorry I'll leave so I can't make it. I'll fix this later
if Herbert hasn't fix it.
