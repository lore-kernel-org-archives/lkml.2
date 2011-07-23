Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1GWRed (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 13:34:33 -0400
Received: from mail001.aei.ca ([206.123.6.130]:57955 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1GWReZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 13:34:25 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt2
Date: Sat, 23 Jul 2011 13:34:22 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rt2-crc+; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1107231706380.2702@ionos> <201107231317.05234.edt@aei.ca>
In-Reply-To: <201107231317.05234.edt@aei.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107231334.23216.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 July 2011 13:17:04 Ed Tomlinson wrote:
> On Saturday 23 July 2011 11:13:30 Thomas Gleixner wrote:
> > I'm pleased to announce the 3.0-rt2 release.
> > 
> > Changes versus 3.0-rt1:
> > 
> >   * mqueue fix (Yoshitake Kobayashi)
> > 
> >   * dca locking fix (Mike Galbraith)
> > 
> >   * trace updates (Carsten Emde)
> > 
> >   * Fixed vprintk wreckage and rcutorture (tglx)
> > 
> > Known issues:
> > 
> >   * Some weird "console=..." commandline + config dependent
> >     interactions which have been not yet investigated down to their
> >     root cause. Result in a boot hang. YMMV

Got this warning too.  Was a change was missed?

[  364.392603] NOHZ: local_softirq_pending 08
[  369.320859] NOHZ: local_softirq_pending 08
[  382.126867] NOHZ: local_softirq_pending 08
[  388.525880] NOHZ: local_softirq_pending 08
[  388.526510] NOHZ: local_softirq_pending 08
[  412.148451] NOHZ: local_softirq_pending 08
[  418.550136] NOHZ: local_softirq_pending 08
[  418.550290] NOHZ: local_softirq_pending 08
[  429.870609] NOHZ: local_softirq_pending 08
[  453.992649] NOHZ: local_softirq_pending 08
[  905.155424] ------------[ cut here ]------------
[  905.155441] WARNING: at kernel/trace/trace.c:2729 tracing_ctrl_write+0x203/0x220()
[  905.155447] Hardware name: System Product Name
[  905.155452] tracing_enabled is deprecated. Use tracing_on
[  905.155456] Modules linked in: hidp loop acpi_pad video pci_slot container fan tun sit tunnel4 ipv6 bnep rfcomm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss microcode af_packet kvm_amd kvm pciehp pci_hotplug powernow_k8 mperf sr_mod cdrom btusb bluetooth ath3k pl2303 usbserial uas usb_storage joydev hid_microsoft usbhid gspca_ov519 gspca_main videodev v4l2_compat_ioctl32 usblp ata_generic amd64_edac_mod pcspkr k10temp edac_mce_amd pata_atiixp ohci_hcd ehci_hcd snd_hda_codec_hdmi evdev snd_hda_codec_realtek asus_atk0110 snd_hda_intel snd_hda_codec snd_pcm snd_timer snd sky2 soundcore snd_page_alloc wmi button processor unix
[  905.155555] Pid: 4263, comm: latencytop Not tainted 3.0.0-rt2-crc+ #351
[  905.155561] Call Trace:
[  905.155573]  [<ffffffff8104b82f>] warn_slowpath_common+0x7f/0xc0
[  905.155582]  [<ffffffff8104b926>] warn_slowpath_fmt+0x46/0x50
[  905.155593]  [<ffffffff81582ecc>] ? _mutex_lock+0x3c/0x50
[  905.155601]  [<ffffffff810d122e>] ? tracing_ctrl_write+0xce/0x220
[  905.155609]  [<ffffffff810d1363>] tracing_ctrl_write+0x203/0x220
[  905.155618]  [<ffffffff811531dc>] ? rw_verify_area+0xec/0x190
[  905.155625]  [<ffffffff8115368c>] vfs_write+0x11c/0x1c0
[  905.155632]  [<ffffffff81153824>] sys_write+0x54/0x90
[  905.155641]  [<ffffffff8158afab>] system_call_fastpath+0x16/0x1b
[  905.155647] ---[ end trace 0000000000000002 ]---

I've also not seen the "NOHZ: local_softirq_pending 08" messages before.

Thanks
Ed
