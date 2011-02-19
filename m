Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab1BSGWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 01:22:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52621 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1BSGWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 01:22:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
	<20110216193700.GA6377@elte.hu>
	<AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
	<AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
	<20110217090910.GA3781@tiehlicka.suse.cz>
	<AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	<20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
	<AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	<20110218122938.GB26779@tiehlicka.suse.cz>
	<20110218162623.GD4862@tiehlicka.suse.cz>
	<AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
Date: Fri, 18 Feb 2011 22:22:32 -0800
In-Reply-To: <AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 18 Feb 2011 08:39:02 -0800")
Message-ID: <m1oc68ilw7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+vg9tx4SoBpmTmvxYfuJIGydeuFsKvo7o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Feb 18, 2011 at 8:26 AM, Michal Hocko <mhocko@suse.cz> wrote:
>>> Now, I will try with the 2 patches patches in this thread. I will also
>>> turn on DEBUG_LIST and DEBUG_PAGEALLOC.
>>
>> I am not able to reproduce with those 2 patches applied.
>
> Thanks for verifying. Davem/EricD - you can add Michal's tested-by to
> the patches too.
>
> And I think we can consider this whole thing solved. It hopefully also
> explains all the other random crashes that EricB saw - just random
> memory corruption in other datastructures.
>
> EricB - do all your stress-testers run ok now?
>
>                     Linus

It looks like the same problematic dellink pattern made it into net_namespace.c,
and your new LIST_DEBUG changes caught it.

I will cook up a patch after I get some sleep.

Eric


------------[ cut here ]------------
WARNING: at lib/list_debug.c:53 __list_del_entry+0xa1/0xd0()
Hardware name: X7DWU
list_del corruption. prev->next should be ffff88005fc12140, but was           (null)
Modules linked in: macvtap ipt_LOG xt_limit ipt_REJECT xt_hl xt_state dummy tulip xt_tcpudp iptable_filter inet_diag veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc dm_mirror dm_region_hash dm_log uinput bonding ipv6 kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q iTCO_wdt microcode iTCO_vendor_support ghes hed sg i5k_amb i5400_edac ioatdma edac_core i2c_i801 serio_raw pcspkr dca shpchp radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core sr_mod ehci_hcd cdrom netxen_nic uhci_hcd igb dm_mod [last unloaded: mperf]
Pid: 4865, comm: kworker/u:0 Tainted: G        W   2.6.38-rc4-359399.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 [<ffffffff8104d6ba>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104d791>] ? warn_slowpath_fmt+0x41/0x50
 [<ffffffff81430b02>] ? rtnl_lock+0x12/0x20
 [<ffffffff814328a0>] ? __rtnl_unlock+0x10/0x20
 [<ffffffff8129ab31>] ? __list_del_entry+0xa1/0xd0
 [<ffffffff81423644>] ? unregister_netdevice_queue+0x34/0xa0
 [<ffffffffa0427200>] ? veth_dellink+0x20/0x40 [veth]
 [<ffffffff81423711>] ? default_device_exit_batch+0x61/0xe0
 [<ffffffff8141c1d3>] ? ops_exit_list.clone.0+0x53/0x60
 [<ffffffff8141c520>] ? cleanup_net+0x100/0x1b0
 [<ffffffff81068c47>] ? process_one_work+0x187/0x4b0
 [<ffffffff81068be1>] ? process_one_work+0x121/0x4b0
 [<ffffffff8141c420>] ? cleanup_net+0x0/0x1b0
 [<ffffffff8106a65c>] ? worker_thread+0x15c/0x330
 [<ffffffff8106a500>] ? worker_thread+0x0/0x330
 [<ffffffff8106f226>] ? kthread+0xb6/0xc0
 [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff814df02b>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff814df854>] ? restore_args+0x0/0x30
 [<ffffffff8106f170>] ? kthread+0x0/0xc0
 [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
---[ end trace bcdbebbab42b1e76 ]---
