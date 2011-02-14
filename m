Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1BNCFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 21:05:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52362 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1BNCEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 21:04:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
Date: Sun, 13 Feb 2011 18:04:43 -0800
In-Reply-To: <AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 13 Feb 2011 09:39:39 -0800")
Message-ID: <m14o87wev8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/N+2C3GA6lhKiqv/jC0fIe5wnyLcl0skI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Feb 9, 2011 at 8:02 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Well, the thing is, Eric said he was using ext4.
>>
>> And there are absolutely no changes I can see after -rc3 that would
>> affect anything like this.
>
> Hmm. Eric - mind testing current -git?

Sorry for taking so long to get back to this.  I came down with
a nasty cold and haven't been had much time.

While I haven't been doing anything the machine has been still running
the builds so I have some interesting test results.

The build failures appear to have been due to a corrupted ccache. A
coworker turned off using the ccache and the compiles started working
again.  Unfortunately I can't qualify when my ccache got corrupted,
or give a hint at which kernel bug caused the corrupted cache.  I
expected it happened in whatever I tested just before -rc3.


There is something corrupting my page tables.

messages:Feb 13 12:50:00 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88028688b748 pmd:28688b067
messages:Feb 13 12:50:00 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88028688b748 pmd:28688b067
messages:Feb 13 12:52:17 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff880011065748 pmd:11065067
messages:Feb 13 12:52:17 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff880011065748 pmd:11065067
messages:Feb 13 12:52:27 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff8802460d3748 pmd:2460d3067
messages:Feb 13 12:52:27 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff8802460d3748 pmd:2460d3067
messages-20110213:Feb  7 05:50:21 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff8801d256b748 pmd:1d256b067
messages-20110213:Feb  7 05:50:21 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff8801d256b748 pmd:1d256b067
messages-20110213:Feb  7 18:34:32 bs38 kernel: BUG: Bad page map in process Mlag  pte:ffff8800cad2d748 pmd:cad2d067
messages-20110213:Feb  7 18:34:33 bs38 kernel: BUG: Bad page map in process Mlag  pte:ffff8800cad2d748 pmd:cad2d067
messages-20110213:Feb  7 18:35:11 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88003c021748 pmd:3c021067
messages-20110213:Feb  7 18:35:12 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88003c021748 pmd:3c021067
messages-20110213:Feb  8 04:08:26 bs38 kernel: BUG: Bad page map in process IgmpSnooping  pte:ffff880288b29748 pmd:288b29067
messages-20110213:Feb  8 04:08:26 bs38 kernel: BUG: Bad page map in process IgmpSnooping  pte:ffff880288b29748 pmd:288b29067
messages-20110213:Feb 10 14:21:34 bs38 kernel: BUG: Bad page map in process pylint  pte:ffff8802984d7c28 pmd:2984d7067
messages-20110213:Feb 10 14:21:35 bs38 kernel: BUG: Bad page map in process pylint  pte:ffff8802984d7c28 pmd:2984d7067
messages-20110213:Feb 11 00:02:32 bs38 kernel: BUG: soft lockup - CPU#5 stuck for 67s! [kswapd0:57]
messages-20110213:Feb 11 02:03:33 bs38 kernel: BUG: Bad page map in process configure  pte:ffff880299b1b748 pmd:299b1b067
messages-20110213:Feb 11 02:03:33 bs38 kernel: BUG: Bad page map in process configure  pte:ffff880299b1b748 pmd:299b1b067
messages-20110213:Feb 11 17:16:36 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88013efa9748 pmd:13efa9067
messages-20110213:Feb 11 17:16:37 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88013efa9748 pmd:13efa9067

> J. R. Okajima found a possible problem with the new RCU filename
> lookup, which could corrupt the filp_cache. I'd expect the normal
> result to be an oops, but maybe there could be memory corruption. And
> the easiest way to trigger it would probably be to have lots of
> concurrent fs activity with renames.

It does look like I have seen something like that.  I will update
shortly and hopefully I can see something tomorrow.

I still have about half a dozen unclassified failures of my tests under
-rc4 that I haven't been seen anywhere.  But at least I have them all
running

> Now, it's not new to -rc4: the whole rcu lookup thing was merged into
> -rc1. But since I still don't see anything that looks likely to be
> introduced after -rc3, it might not hurt to think that maybe it's just
> rare enough that you just thought -rc3 was ok, and then you were
> unlucky with -rc4.

I have some unexpected kernel crashes as well.
With 2.6.38-rc3 (something I think this was a git snapshot) I saw:

<1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
<1>IP: [<ffffffff81069008>] do_raw_spin_lock+0x9/0x1a
<4>PGD 0 
<0>Oops: 0002 [#1] SMP 
<0>last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
<4>CPU 5 
<4>Modules linked in: macvtap ipt_LOG xt_limit ipt_REJECT xt_hl xt_state dummy tulip xt_tcpudp iptable_filter inet_diag veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc dm_mirror dm_region_hash dm_log uinput bonding ipv6 kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q serio_raw sg shpchp pcspkr i5k_amb iTCO_wdt iTCO_vendor_support i2c_i801 i5400_edac ioatdma ghes microcode edac_core hed dca radeon ttm drm_kms_helper drm hwmon sr_mod i2c_algo_bit i2c_core uhci_hcd igb ehci_hcd cdrom netxen_nic dm_mod [last unloaded: mperf]
<4>
<4>Pid: 57, comm: kswapd0 Tainted: G    B       2.6.38-rc3-355347.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
<4>RIP: 0010:[<ffffffff81069008>]  [<ffffffff81069008>] do_raw_spin_lock+0x9/0x1a
<4>RSP: 0000:ffff880296ee5a90  EFLAGS: 00010246
<4>RAX: 0000000000000100 RBX: ffff880072d529b0 RCX: ffff880296ee5bf8
<4>RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000008
<4>RBP: ffff880296ee5a90 R08: dead000000200200 R09: dead000000100100
<4>R10: 0000000000014a0c R11: 00000000000149b8 R12: 0000000000000000
<4>R13: ffffea00060d7cc8 R14: ffff880296ee5c80 R15: 0000000000000001
<4>FS:  0000000000000000(0000) GS:ffff8800cfd40000(0000) knlGS:0000000000000000
<4>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>CR2: 0000000000000008 CR3: 0000000001803000 CR4: 00000000000006e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process kswapd0 (pid: 57, threadinfo ffff880296ee4000, task ffff88029adc6040)
<0>Stack:
<4> ffff880296ee5aa0 ffffffff813d0a0c ffff880296ee5ad0 ffffffff810d30cd
<4> ffffea00060bdcb8 ffffea00060d7cc8 0000000000000000 ffff880072d529b1
<4> ffff880296ee5b80 ffffffff810d3633 ffffea00060bdcb8 ffffffff8181ff70
<0>Call Trace:
<4> [<ffffffff813d0a0c>] _raw_spin_lock+0x9/0xb
<4> [<ffffffff810d30cd>] __page_lock_anon_vma+0x3a/0x54
<4> [<ffffffff810d3633>] page_referenced+0xaf/0x240
<4> [<ffffffff810bbbe4>] ? pageout+0x223/0x233
<4> [<ffffffff810bcfda>] shrink_page_list+0x154/0x49e
<4> [<ffffffff810bd762>] shrink_inactive_list+0x234/0x386
<4> [<ffffffff810b79da>] ? determine_dirtyable_memory+0x18/0x21
<4> [<ffffffff810bdede>] shrink_zone+0x356/0x418
<4> [<ffffffff810b3eef>] ? zone_watermark_ok_safe+0x9c/0xa9
<4> [<ffffffff810bed0e>] kswapd+0x4f6/0x84d
<4> [<ffffffff810be818>] ? kswapd+0x0/0x84d
<4> [<ffffffff81057de9>] kthread+0x7d/0x85
<4> [<ffffffff810037a4>] kernel_thread_helper+0x4/0x10
<4> [<ffffffff81057d6c>] ? kthread+0x0/0x85
<4> [<ffffffff810037a0>] ? kernel_thread_helper+0x0/0x10
<0>Code: 00 00 01 74 05 e8 49 be 18 00 c9 c3 55 48 89 e5 f0 ff 07 c9 c3 55 48 89 e5 f0 81 07 00 00 00 01 c9 c3 55 b8 00 01 00 00 48 89 e5 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 55 48 89 e5 
<1>RIP  [<ffffffff81069008>] do_raw_spin_lock+0x9/0x1a
<4> RSP <ffff880296ee5a90>
<0>CR2: 0000000000000008

With 2.6.38-rc4 I have seen:
<0>general protection fault: 0000 [#1] SMP 
<0>last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
<4>CPU 6 
<4>Modules linked in: dummy tulip xt_tcpudp iptable_filter inet_diag veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc dm_mirror dm_region_hash dm_log uinput bonding ipv6 kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q iTCO_wdt iTCO_vendor_support i5k_amb i5400_edac ioatdma edac_core dca i2c_i801 serio_raw shpchp sg pcspkr ghes microcode hed radeon ttm drm_kms_helper drm sr_mod hwmon i2c_algo_bit i2c_core igb netxen_nic cdrom ehci_hcd uhci_hcd dm_mod [last unloaded: mperf]
<4>
<4>Pid: 7643, comm: netnsd Not tainted 2.6.38-rc4-355739.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
<4>RIP: 0010:[<ffffffff810326b0>]  [<ffffffff810326b0>] post_schedule+0x7/0x4e
<4>RSP: 0000:ffff8802981c5bf8  EFLAGS: 00010287
<4>RAX: 0000000000000006 RBX: ffff100367f45c28 RCX: ffff8801a6af0dc0
<4>RDX: ffff8802981c5fd8 RSI: ffff8801a6af0dc0 RDI: ffff100367f45c28
<4>RBP: ffff8802981c5c08 R08: ffff8802981c4000 R09: 0000000000000000
<4>R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800036f2a00
<4>R13: ffff880296bc2a00 R14: ffff8801a6af1068 R15: 0000000000000006
<4>FS:  0000000000000000(0000) GS:ffff8800cfd80000(0063) knlGS:00000000f74e76d0
<4>CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
<4>CR2: 00000000ffd70f80 CR3: 0000000297dc9000 CR4: 00000000000006e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process netnsd (pid: 7643, threadinfo ffff8802981c4000, task ffff8801d2f1a260)
<0>Stack:
<4> ffff100367f45c28 ffff8800036f2a00 ffff8802981c5cb8 ffffffff813cf98c
<4> ffff8802981c5ca8 00000000000118c0 ffff8802981c5c28 ffff8802981c5c28
<4> 00000000000118c0 ffff8801d2f1a260 00000000000118c0 ffff8802981c5fd8
<0>Call Trace:
<4> [<ffffffff813cf98c>] schedule+0x544/0x577
<4> [<ffffffff813cfb4f>] schedule_timeout+0x22/0xbb
<4> [<ffffffff813d0a5f>] ? _raw_spin_unlock_irqrestore+0x11/0x13
<4> [<ffffffff81058427>] ? prepare_to_wait_exclusive+0x70/0x7b
<4> [<ffffffff813386e5>] __skb_recv_datagram+0x1ec/0x264
<4> [<ffffffff810e3da8>] ? arch_local_irq_save+0x16/0x1c
<4> [<ffffffff8133877e>] ? receiver_wake_function+0x0/0x1a
<4> [<ffffffff8133877c>] skb_recv_datagram+0x1f/0x21
<4> [<ffffffff813aefeb>] unix_accept+0x55/0x103
<4> [<ffffffff8132efcb>] sys_accept4+0xf3/0x1c3
<4> [<ffffffff81076155>] ? compat_sys_wait4+0x26/0xc3
<4> [<ffffffff813d0a4c>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff8104f34a>] ? do_sigaction+0x168/0x179
<4> [<ffffffff8102e15b>] ? ia32_restore_sigcontext+0x136/0x15c
<4> [<ffffffff81353b97>] compat_sys_socketcall+0x17d/0x186
<4> [<ffffffff8102cd90>] sysenter_dispatch+0x7/0x2e
<0>Code: 49 89 c4 8b 75 e8 48 89 df 31 c9 e8 a3 d4 ff ff 4c 89 e6 48 89 df e8 ae e3 39 00 48 83 c4 20 5b 41 5c c9 c3 55 48 89 e5 41 54 53 <83> bf 74 08 00 00 00 48 89 fb 74 36 e8 4d e3 39 00 49 89 c4 48 
<1>RIP  [<ffffffff810326b0>] post_schedule+0x7/0x4e
<4> RSP <ffff8802981c5bf8>


With 2.6.38-rc4 I have seen:
<1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
<1>IP: [<ffffffff811016cb>] shrink_dcache_parent+0x104/0x23c
<4>PGD 15a66d067 PUD 15a65a067 PMD 0 
<0>Oops: 0002 [#1] SMP 
<0>last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
<4>CPU 5 
<4>Modules linked in: macvtap ipt_LOG xt_limit ipt_REJECT xt_hl xt_state dummy tulip xt_tcpudp iptable_filter inet_diag veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc dm_mirror dm_region_hash dm_log uinput bonding ipv6 kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q i5k_amb i5400_edac edac_core iTCO_wdt iTCO_vendor_support ioatdma dca i2c_i801 shpchp sg ghes hed pcspkr serio_raw microcode radeon ttm drm_kms_helper drm sr_mod cdrom ehci_hcd hwmon i2c_algo_bit i2c_core netxen_nic uhci_hcd igb dm_mod [last unloaded: mperf]
<4>
<4>Pid: 24433, comm: netnsd Tainted: G    B       2.6.38-rc4-355739.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
<4>RIP: 0010:[<ffffffff811016cb>]  [<ffffffff811016cb>] shrink_dcache_parent+0x104/0x23c
<4>RSP: 0018:ffff8802633c9bb8  EFLAGS: 00010213
<4>RAX: ffffffff8141c100 RBX: ffff880128e3d600 RCX: ffff880128e3d738
<4>RDX: 0000000000000000 RSI: ffff880128e3d740 RDI: ffffffff818022c0
<4>RBP: ffff8802633c9c18 R08: 0000000000000004 R09: ffff880128e3d638
<4>R10: ffff8802633c9c65 R11: 0000000000000000 R12: ffff880128e3d748
<4>R13: 0000000000000004 R14: ffff880128e3d600 R15: ffff880128e3d6b8
<4>FS:  0000000000000000(0000) GS:ffff8800cfd40000(0063) knlGS:00000000f746b6d0
<4>CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
<4>CR2: 0000000000000008 CR3: 00000001e4181000 CR4: 00000000000006e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process netnsd (pid: 24433, threadinfo ffff8802633c8000, task ffff880296870000)
<0>Stack:
<4> ffff88004ec85000 00b2130a00000000 ffff8802633c8000 ffff880128e3d65c
<4> ffff8802633c9be8 ffff8801c6826cc0 ffff8802633c9c48 ffff8802633c9c58
<4> 0000000000000002 ffff88019d1f2500 00000000000013bf ffff8802633c9c48
<0>Call Trace:
<4> [<ffffffff8113c8bc>] proc_flush_task+0xae/0x1d2
<4> [<ffffffff8104061a>] release_task+0x35/0x3b9
<4> [<ffffffff81040f53>] wait_consider_task+0x5b5/0x911
<4> [<ffffffff810413a6>] do_wait+0xf7/0x222
<4> [<ffffffff8104266f>] sys_wait4+0x99/0xbc
<4> [<ffffffff8104038f>] ? child_wait_callback+0x0/0x53
<4> [<ffffffff81076155>] compat_sys_wait4+0x26/0xc3
<4> [<ffffffff813d0a4c>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff8104f34a>] ? do_sigaction+0x168/0x179
<4> [<ffffffff810024c1>] ? do_notify_resume+0x27/0x69
<4> [<ffffffff8102d9e0>] sys32_waitpid+0xb/0xd
<4> [<ffffffff8102cd90>] sysenter_dispatch+0x7/0x2e
<0>Code: 00 49 89 87 80 00 00 00 49 89 8f 88 00 00 00 48 89 11 49 8b 47 68 ff 05 28 04 72 00 ff 80 f0 00 00 00 eb 33 49 8b b7 88 00 00 00 <48> 89 72 08 48 89 16 48 8b 90 e8 00 00 00 48 89 88 e8 00 00 00 
<1>RIP  [<ffffffff811016cb>] shrink_dcache_parent+0x104/0x23c
<4> RSP <ffff8802633c9bb8>
<0>CR2: 0000000000000008

Eric
