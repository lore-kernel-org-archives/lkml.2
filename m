Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0D1BWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:22:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54765 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0D1BWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:22:01 -0400
Subject: Re: 2.6.33.3-rt16: WARNING: at fs/namespace.c:1197
 umount_tree+0x127/0x175()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1004272252270.2951@localhost.localdomain>
References: <20100427202750.GC2679@uudg.org>
	 <alpine.LFD.2.00.1004272252270.2951@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 27 Apr 2010 18:21:55 -0700
Message-ID: <1272417715.2255.95.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 22:53 +0200, Thomas Gleixner wrote:
> On Tue, 27 Apr 2010, Luis Claudio R. Goncalves wrote:
> 
> CC'ed John

> > I see this warning during system boot and it hangs while loading X and even
> > though I can change from one VT to another (ctrl+alt+F<num>) no keys
> > pressed seem to have any effect.
> > 
> > ------------[ cut here ]------------
> > WARNING: at fs/namespace.c:1197 umount_tree+0x127/0x175()
> > Hardware name: KQ260AA-AC4 a6540br
> > Modules linked in: i915 drm_kms_helper drm video output ipt_MASQUERADE iptable_nat nf_nat bridge stp llc vfat fat sunrpc ipv6 xt_physdev ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_tables dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel kvm uinput tuner_simple tuner_types wm8775 tda9887 tda8290 tuner snd_hda_codec_realtek cx25840 snd_hda_intel snd_hda_codec snd_hwdep snd_seq usb_storage snd_seq_device ivtv snd_pcm i2c_algo_bit cx2341x v4l2_common videodev snd_timer firewire_ohci snd firewire_core v4l1_compat v4l2_compat_ioctl32 ir_common ir_core i2c_i801 soundcore crc_itu_t tveeprom i2c_core iTCO_wdt snd_page_alloc sr_mod intel_agp iTCO_vendor_support serio_raw pcspkr sg button r8169 mii cdrom ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> > Pid: 2267, comm: libvirtd Not tainted 2.6.33.3-rt16 #28
> > Call Trace:
> > [<ffffffff81040e3b>] warn_slowpath_common+0x7c/0x94
> > [<ffffffff81040e67>] warn_slowpath_null+0x14/0x16
> > [<ffffffff81115a7f>] umount_tree+0x127/0x175
> > [<ffffffff81116d1d>] put_mnt_ns+0xc2/0xf0
> > [<ffffffff81061a1d>] free_nsproxy+0x1f/0x86
> > [<ffffffff81061abc>] switch_task_namespaces+0x38/0x3c
> > [<ffffffff81061ad0>] exit_task_namespaces+0x10/0x12
> > [<ffffffff81044ae3>] do_exit+0x595/0x738
> > [<ffffffff81360626>] ? rt_mutex_unlock+0xe/0x10
> > [<ffffffff81360db8>] ? lockdep_sys_exit_thunk+0x35/0x67
> > [<ffffffff81044d10>] do_group_exit+0x8a/0xb9
> > [<ffffffff81044d56>] sys_exit_group+0x17/0x1b
> > [<ffffffff81002d32>] system_call_fastpath+0x16/0x1b
> > ---[ end trace 348d259112b3e793 ]---
> > 
> > 
> > The warning comes from:
> > 
> > 	WARN_ON(!(p->mnt_flags & MNT_MOUNTED));


Hmmm.. Ok. Looks like an issue with unshare. 

Thanks to Dave Hansen, I managed to reproduce it.

Still haven't narrowed down the exact cause but I'll send you a patch to
test once I have something.

thanks for the testing and the bug submission!
-john


