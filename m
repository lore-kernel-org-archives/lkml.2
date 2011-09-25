Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1IYOTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 10:19:41 -0400
Received: from shutemov.name ([188.40.19.243]:52158 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1IYOTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 10:19:38 -0400
Date: Sun, 25 Sep 2011 17:19:37 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110925141937.GA28062@shutemov.name>
References: <20110925002409.GA24220@shutemov.name>
 <20110925050826.GC2995@linux.vnet.ibm.com>
 <20110925112637.GA19298@shutemov.name>
 <20110925130622.GA9205@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110925130622.GA9205@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 25, 2011 at 03:06:25PM +0200, Frederic Weisbecker wrote:
> On Sun, Sep 25, 2011 at 02:26:37PM +0300, Kirill A. Shutemov wrote:
> > On Sat, Sep 24, 2011 at 10:08:26PM -0700, Paul E. McKenney wrote:
> > > On Sun, Sep 25, 2011 at 03:24:09AM +0300, Kirill A. Shutemov wrote:
> > > > [   29.974288] ------------[ cut here ]------------
> > > > [   29.974308] WARNING: at /home/kas/git/public/linux-next/kernel/rcutree.c:1833 rcu_needs_cpu+0xff
> > > > [   29.974316] Hardware name: HP EliteBook 8440p
> > > > [   29.974321] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iple_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc rfcomm bnep acpi_cpufreq mperfckd fscache auth_rpcgss nfs_acl sunrpc ext2 loop kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_idtideodev media v4l2_compat_ioctl32 snd_seq bluetooth drm_kms_helper snd_timer tpm_infineon snd_seq_drt tpm_tis hp_accel intel_ips soundcore lis3lv02d tpm rfkill i2c_algo_bit snd_page_alloc i2c_core c16 sha256_generic aesni_intel cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod sg sr_mod sd_mod cd thermal_sys [last unloaded: scsi_wait_scan]
> > > > [   29.974517] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0-rc7-next-20110923 #2
> > > > [   29.974521] Call Trace:
> > > > [   29.974525]  <IRQ>  [<ffffffff8104d72a>] warn_slowpath_common+0x7a/0xb0
> > > > [   29.974540]  [<ffffffff8104d775>] warn_slowpath_null+0x15/0x20
> > > > [   29.974546]  [<ffffffff810bffdf>] rcu_needs_cpu+0xff/0x110
> > > > [   29.974555]  [<ffffffff8108396f>] tick_nohz_stop_sched_tick+0x13f/0x3d0
> > > > [   29.974563]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > [   29.974571]  [<ffffffff81055622>] irq_exit+0xa2/0xd0
> > > > [   29.974578]  [<ffffffff8101ee75>] smp_apic_timer_interrupt+0x85/0x1c0
> > > > [   29.974585]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > [   29.974592]  [<ffffffff81436e1e>] apic_timer_interrupt+0x6e/0x80
> > > > [   29.974596]  <EOI>  [<ffffffff81297abd>] ? acpi_hw_read+0x4a/0x51
> > > > [   29.974609]  [<ffffffff81087a07>] ? lock_acquire+0xa7/0x160
> > > > [   29.974615]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > [   29.974622]  [<ffffffff81432a16>] __atomic_notifier_call_chain+0x56/0xb0
> > > > [   29.974631]  [<ffffffff814329c0>] ? notifier_call_chain+0x70/0x70
> > > > [   29.974642]  [<ffffffff8130ebb6>] ? cpuidle_idle_call+0x106/0x350
> > > > [   29.974651]  [<ffffffff81432a81>] atomic_notifier_call_chain+0x11/0x20
> > > > [   29.974661]  [<ffffffff81001233>] cpu_idle+0xe3/0x120
> > > > [   29.974672]  [<ffffffff8141e34b>] start_secondary+0x1fd/0x204
> > > > [   29.974681] ---[ end trace 6c1d44095a3bb7c5 ]---
> > > 
> > > Do the following help?
> > > 
> > > 	https://lkml.org/lkml/2011/9/17/47
> > > 	https://lkml.org/lkml/2011/9/17/45
> > > 	https://lkml.org/lkml/2011/9/17/43
> > 
> > Yes. Thanks.
> 
> I believe that doesn't really fix the issue. But the warning is not
> easy to trigger. You simply haven't hit it by chance after applying
> the patches.

Triggered a bit later:

[  154.617416] ------------[ cut here ]------------
[  154.617437] WARNING: at /home/kas/git/public/linux-next/kernel/rcutree.c:1833 rcu_needs_cpu+0xff/0x110()
[  154.617444] Hardware name: HP EliteBook 8440p
[  154.617449] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc acpi_cpufreq mperf rfcomm bnep cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats binfmt_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext2 loop kvm_intel kvm i915 arc4 iwlagn mac80211 snd_hda_codec_hdmi snd_hda_codec_idt drm_kms_helper snd_hda_intel pcmcia drm snd_hda_codec uvcvideo snd_hwdep ecb snd_pcm videodev tpm_infineon btusb snd_seq media bluetooth v4l2_compat_ioctl32 cfg80211 snd_timer snd_seq_device yenta_socket evdev pcmcia_rsrc psmouse snd parport_pc pcmcia_core parport serio_raw hp_accel intel_ips rfkill i2c_algo_bit tpm_tis lis3lv02d i2c_core soundcore tpm container tpm_bios snd_page_alloc input_polldev video battery ac power_supply processor button ext4 mbcache jbd2 crc16 sha256_generic aesni_intel cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod sg sd_mod sr_mod cdrom crc_t10dif sdhci_pci sdhci mmc_core ahci libahci libata scsi_mod ehci_hcd e1000e usbcore thermal thermal_sys [last unloaded: scsi_wait_scan]
[  154.617681] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-rc7-next-20110923+ #3
[  154.617685] Call Trace:
[  154.617688]  <IRQ>  [<ffffffff8104d72a>] warn_slowpath_common+0x7a/0xb0
[  154.617704]  [<ffffffff8104d775>] warn_slowpath_null+0x15/0x20
[  154.617711]  [<ffffffff810c00df>] rcu_needs_cpu+0xff/0x110
[  154.617719]  [<ffffffff81083855>] tick_nohz_stop_sched_tick.isra.9+0x105/0x3c0
[  154.617726]  [<ffffffff81083cae>] tick_nohz_irq_exit+0x2e/0x40
[  154.617732]  [<ffffffff81055620>] irq_exit+0xa0/0xd0
[  154.617740]  [<ffffffff8100412e>] do_IRQ+0x5e/0xd0
[  154.617748]  [<ffffffff81432ac0>] ? notifier_call_chain+0x70/0x70
[  154.617756]  [<ffffffff8142f66e>] common_interrupt+0x6e/0x6e
[  154.617759]  <EOI>  [<ffffffff81297bbd>] ? acpi_hw_read+0x4a/0x51
[  154.617772]  [<ffffffff81087b07>] ? lock_acquire+0xa7/0x160
[  154.617777]  [<ffffffff81432ac0>] ? notifier_call_chain+0x70/0x70
[  154.617784]  [<ffffffff81432b16>] __atomic_notifier_call_chain+0x56/0xb0
[  154.617789]  [<ffffffff81432ac0>] ? notifier_call_chain+0x70/0x70
[  154.617797]  [<ffffffff8130ecb6>] ? cpuidle_idle_call+0x106/0x350
[  154.617803]  [<ffffffff81432b81>] atomic_notifier_call_chain+0x11/0x20
[  154.617809]  [<ffffffff81001233>] cpu_idle+0xe3/0x120
[  154.617818]  [<ffffffff8141e44b>] start_secondary+0x1fd/0x204
[  154.617823] ---[ end trace 64c64a258e1aa463 ]---

-- 
 Kirill A. Shutemov
