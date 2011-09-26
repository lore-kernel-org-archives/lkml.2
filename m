Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1IZIsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:48:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52961 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1IZIsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:48:12 -0400
Date: Mon, 26 Sep 2011 10:48:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110926084800.GB18553@somewhere>
References: <20110925002409.GA24220@shutemov.name>
 <20110925050826.GC2995@linux.vnet.ibm.com>
 <20110925112637.GA19298@shutemov.name>
 <20110925130622.GA9205@somewhere.redhat.com>
 <20110925164804.GD2995@linux.vnet.ibm.com>
 <20110926010418.GA18553@somewhere>
 <20110926012501.GI2995@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926012501.GI2995@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 25, 2011 at 06:25:01PM -0700, Paul E. McKenney wrote:
> On Mon, Sep 26, 2011 at 03:04:21AM +0200, Frederic Weisbecker wrote:
> > On Sun, Sep 25, 2011 at 09:48:04AM -0700, Paul E. McKenney wrote:
> > > On Sun, Sep 25, 2011 at 03:06:25PM +0200, Frederic Weisbecker wrote:
> > > > On Sun, Sep 25, 2011 at 02:26:37PM +0300, Kirill A. Shutemov wrote:
> > > > > On Sat, Sep 24, 2011 at 10:08:26PM -0700, Paul E. McKenney wrote:
> > > > > > On Sun, Sep 25, 2011 at 03:24:09AM +0300, Kirill A. Shutemov wrote:
> > > > > > > [   29.974288] ------------[ cut here ]------------
> > > > > > > [   29.974308] WARNING: at /home/kas/git/public/linux-next/kernel/rcutree.c:1833 rcu_needs_cpu+0xff
> > > > > > > [   29.974316] Hardware name: HP EliteBook 8440p
> > > > > > > [   29.974321] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iple_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc rfcomm bnep acpi_cpufreq mperfckd fscache auth_rpcgss nfs_acl sunrpc ext2 loop kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_idtideodev media v4l2_compat_ioctl32 snd_seq bluetooth drm_kms_helper snd_timer tpm_infineon snd_seq_drt tpm_tis hp_accel intel_ips soundcore lis3lv02d tpm rfkill i2c_algo_bit snd_page_alloc i2c_core c16 sha256_generic aesni_intel cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod sg sr_mod sd_mod cd thermal_sys [last unloaded: scsi_wait_scan]
> > > > > > > [   29.974517] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0-rc7-next-20110923 #2
> > > > > > > [   29.974521] Call Trace:
> > > > > > > [   29.974525]  <IRQ>  [<ffffffff8104d72a>] warn_slowpath_common+0x7a/0xb0
> > > > > > > [   29.974540]  [<ffffffff8104d775>] warn_slowpath_null+0x15/0x20
> > > > > > > [   29.974546]  [<ffffffff810bffdf>] rcu_needs_cpu+0xff/0x110
> > > > > > > [   29.974555]  [<ffffffff8108396f>] tick_nohz_stop_sched_tick+0x13f/0x3d0
> > > > > > > [   29.974563]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > > > > [   29.974571]  [<ffffffff81055622>] irq_exit+0xa2/0xd0
> > > > > > > [   29.974578]  [<ffffffff8101ee75>] smp_apic_timer_interrupt+0x85/0x1c0
> > > > > > > [   29.974585]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > > > > [   29.974592]  [<ffffffff81436e1e>] apic_timer_interrupt+0x6e/0x80
> > > > > > > [   29.974596]  <EOI>  [<ffffffff81297abd>] ? acpi_hw_read+0x4a/0x51
> > > > > > > [   29.974609]  [<ffffffff81087a07>] ? lock_acquire+0xa7/0x160
> > > > > > > [   29.974615]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > > > > [   29.974622]  [<ffffffff81432a16>] __atomic_notifier_call_chain+0x56/0xb0
> > > > > > > [   29.974631]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > > > > [   29.974642]  [<ffffffff8130ebb6>] ? cpuidle_idle_call+0x106/0x350
> > > > > > > [   29.974651]  [<ffffffff81432a81>] atomic_notifier_call_chain+0x11/0x20
> > > > > > > [   29.974661]  [<ffffffff81001233>] cpu_idle+0xe3/0x120
> > > > > > > [   29.974672]  [<ffffffff8141e34b>] start_secondary+0x1fd/0x204
> > > > > > > [   29.974681] ---[ end trace 6c1d44095a3bb7c5 ]---
> > > > > > 
> > > > > > Do the following help?
> > > > > > 
> > > > > > 	https://lkml.org/lkml/2011/9/17/47
> > > > > > 	https://lkml.org/lkml/2011/9/17/45
> > > > > > 	https://lkml.org/lkml/2011/9/17/43
> > > > > 
> > > > > Yes. Thanks.
> > > > 
> > > > I believe that doesn't really fix the issue. But the warning is not
> > > > easy to trigger. You simply haven't hit it by chance after applying
> > > > the patches.
> > > > 
> > > > This happens when the idle notifier callchain is called in idle
> > > > and is interrupted in the middle. So we have called rcu_read_lock()
> > > > but haven't yet released with rcu_read_unlock(), and in the end
> > > > of the interrupt we call tick_nohz_stop_sched_tick() -> rcu_needs_cpu()
> > > > which is illegal while in an rcu read side critical section.
> > > > 
> > > > No idea how to solve that. Any use of RCU after the tick gets stopped
> > > > is concerned here. If it is really required that rcu_needs_cpu() can't
> > > > be called in an rcu read side critical sectionn then it's not going
> > > > to be easy to fix.
> > > > 
> > > > But I don't really understand that requirement. rcu_needs_cpu() simply
> > > > checks if we don't have callbacks to handle. So I don't understand how
> > > > read side is concerned. It's rather the write side.
> > > > The rule I can imagine instead is: don't call __call_rcu() once the tick is
> > > > stopped.
> > > > 
> > > > But I'm certainly missing something.
> > > > 
> > > > Paul?
> > > 
> > > This is required for RCU_FAST_NO_HZ, which checks to see whether the
> > > current CPU can accelerate the current grace period so as to enter
> > > dyntick-idle mode sooner than it would otherwise.  This takes effect
> > > in the situation where rcu_needs_cpu() sees that there are callbacks.
> > > It then notes a quiescent state (which is illegal in an RCU read-side
> > > critical section), calls force_quiescent_state(), and so on.  For this
> > > to work, the current CPU must be in an RCU read-side critical section.
> > 
> > You mean it must *not* be in an RCU read-side critical section (ie: in a
> > quiescent state)?
> 
> Yes, you are right, it must -not- be in an RCU read-side critical section.
> 
> > That assumption at least fails anytime in idle for the RCU
> > sched flavour given that preemption is disabled in the idle loop.
> 
> Except that the idle loop is a quiescent state.

Oh right. That seem to exclude any tracing in idle.

> > So if I understand correctly we would check if we are in an rcu read side
> > critical section when we call rcu_needs_cpu(). If so then we keep
> > the tick alive. Afterward when we exit the rcu read side critical section
> > (rcu_read_unlock/local_bh_enable), we notice that specific state and
> > we try to accelerate the rcu callbacks processing from there to switch
> > to dynticks idle mode, right?
> > 
> > So that requires some specific counter in rcu_read_lock() for the
> > !CONFIG_PREEMPT case so that we know if we are interrupting an
> > rcu read side critical section from rcu_needs_cpu(). For the
> > bh case we probably can just check in_softirq().
> > 
> > Also if we know we are interrupting a read side section, why not just
> > keep the tick alive and retry the next tick? Interrupting such
> > section looks rare enough that it wouldn't have much impact
> > and that avoids specific hooks in rcu_read_unlock() and local_bh_enable().
> 
> Good point.  Perhaps only bother with this if returning to idle, then?

Looks good.
