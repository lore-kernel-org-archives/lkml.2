Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2JOJ7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:59:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52769 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2JOJ7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:59:06 -0400
Date: Mon, 15 Oct 2012 15:30:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, pzijlstr@redhat.com, mingo@elte.hu,
        hughd@google.com, riel@redhat.com, hannes@cmpxchg.org,
        dhillf@gmail.com, drjones@redhat.com, tglx@linutronix.de,
        pjt@google.com, cl@linux.com, suresh.b.siddha@intel.com, efault@gmx.de,
        paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com,
        Lee.Schermerhorn@hp.com, alex.shi@intel.com, benh@kernel.crashing.org
Subject: Re: [PATCH 19/33] autonuma: memory follows CPU algorithm and
 task/mm_autonuma stats collection
Message-ID: <20121015100033.GE17364@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
 <1349308275-2174-20-git-send-email-aarcange@redhat.com>
 <20121013180618.GC31442@linux.vnet.ibm.com>
 <20121015082413.GD17364@linux.vnet.ibm.com>
 <20121015092044.GU3317@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121015092044.GU3317@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101509-7182-0000-0000-000002D36DF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mel Gorman <mel@csn.ul.ie> [2012-10-15 10:20:44]:

> On Mon, Oct 15, 2012 at 01:54:13PM +0530, Srikar Dronamraju wrote:
> > * Srikar Dronamraju <srikar@linux.vnet.ibm.com> [2012-10-13 23:36:18]:
> > 
> > > > +
> > > > +bool numa_hinting_fault(struct page *page, int numpages)
> > > > +{
> > > > +	bool migrated = false;
> > > > +
> > > > +	/*
> > > > +	 * "current->mm" could be different from the "mm" where the
> > > > +	 * NUMA hinting page fault happened, if get_user_pages()
> > > > +	 * triggered the fault on some other process "mm". That is ok,
> > > > +	 * all we care about is to count the "page_nid" access on the
> > > > +	 * current->task_autonuma, even if the page belongs to a
> > > > +	 * different "mm".
> > > > +	 */
> > > > +	WARN_ON_ONCE(!current->mm);
> > > 
> > > Given the above comment, Do we really need this warn_on?
> > > I think I have seen this warning when using autonuma.
> > > 
> > 
> > ------------[ cut here ]------------
> > WARNING: at ../mm/autonuma.c:359 numa_hinting_fault+0x60d/0x7c0()
> > Hardware name: BladeCenter HS22V -[7871AC1]-
> > Modules linked in: ebtable_nat ebtables autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf bridge stp llc iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii kvm_intel kvm microcode serio_raw lpc_ich mfd_core i2c_i801 i2c_core shpchp ioatdma i7core_edac edac_core bnx2 ixgbe dca mdio sg ext4 mbcache jbd2 sd_mod crc_t10dif mptsas mptscsih mptbase scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
> > Pid: 116, comm: ksmd Tainted: G      D      3.6.0-autonuma27+ #3
> 
> The kernel is tainted "D" which implies that it has already oopsed
> before this warning was triggered. What was the other oops?
> 

Yes, But this oops shows up even with v3.6 kernel and not related to autonuma changes.

BUG: unable to handle kernel NULL pointer dereference at 00000000000000dc
IP: [<ffffffffa0015543>] i7core_inject_show_col+0x13/0x50 [i7core_edac]
PGD 671ce4067 PUD 671257067 PMD 0 
Oops: 0000 [#3] SMP 
Modules linked in: ebtable_nat ebtables autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf bridge stp llc iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support cdc_ether usbnet mii kvm_intel kvm microcode serio_raw i2c_i801 i2c_core lpc_ich mfd_core shpchp ioatdma i7core_edac edac_core bnx2 sg ixgbe dca mdio ext4 mbcache jbd2 sd_mod crc_t10dif mptsas mptscsih mptbase scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
CPU 1 
Pid: 10833, comm: tar Tainted: G      D      3.6.0-autonuma27+ #2 IBM BladeCenter HS22V -[7871AC1]-/81Y5995     
RIP: 0010:[<ffffffffa0015543>]  [<ffffffffa0015543>] i7core_inject_show_col+0x13/0x50 [i7core_edac]
RSP: 0018:ffff88033a10fe68  EFLAGS: 00010286
RAX: ffff880371bd5000 RBX: ffffffffa0018880 RCX: ffffffffa0015530
RDX: 0000000000000000 RSI: ffffffffa0018880 RDI: ffff88036f0af000
RBP: ffff88033a10fe68 R08: ffff88036f0af010 R09: ffffffff8152a140
R10: 0000000000002de7 R11: 0000000000000246 R12: ffff88033a10ff48
R13: 0000000000001000 R14: 0000000000ccc600 R15: ffff88036f233e40
FS:  00007f57c07c47a0(0000) GS:ffff88037fc20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000dc CR3: 0000000671e12000 CR4: 00000000000027e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process tar (pid: 10833, threadinfo ffff88033a10e000, task ffff88036e45e7f0)
Stack:
 ffff88033a10fe98 ffffffff8132b1e7 ffff88033a10fe88 ffffffff81110b5e
 ffff88033a10fe98 ffff88036f233e60 ffff88033a10fef8 ffffffff811d2d1e
 0000000000001000 ffff88036f0af010 ffffffff8152a140 ffff88036d875e48
Call Trace:
 [<ffffffff8132b1e7>] dev_attr_show+0x27/0x50
 [<ffffffff81110b5e>] ? __get_free_pages+0xe/0x50
 [<ffffffff811d2d1e>] sysfs_read_file+0xce/0x1c0
 [<ffffffff81162ed5>] vfs_read+0xc5/0x190
 [<ffffffff811630a1>] sys_read+0x51/0x90
 [<ffffffff814e29e9>] system_call_fastpath+0x16/0x1b
Code: 89 c7 48 c7 c6 64 79 01 a0 31 c0 e8 18 8d 23 e1 c9 48 98 c3 0f 1f 40 00 55 48 89 e5 66 66 66 66 90 48 89 d0 48 8b 97 c0 03 00 00 <8b> 92 dc 00 00 00 85 d2 78 1b 48 89 c7 48 c7 c6 69 79 01 a0 31 
RIP  [<ffffffffa0015543>] i7core_inject_show_col+0x13/0x50 [i7core_edac]
 RSP <ffff88033a10fe68>
CR2: 00000000000000dc
---[ end trace f0a3a4c8c85ff69f ]---

-- 
Thanks and Regards
Srikar

