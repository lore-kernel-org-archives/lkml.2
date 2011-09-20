Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1ITUGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:06:40 -0400
Received: from nef2.ens.fr ([129.199.96.40]:4836 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1ITUGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:06:39 -0400
From: =?iso-8859-1?q?=C9ric_Brunet?= <Eric.Brunet@lps.ens.fr>
Organization: UPMC LPS-ENS
To: linux-kernel@vger.kernel.org
Subject: Re: Regression between 2.6.35 and 2.6.38 (freeze at resume)
Date: Tue, 20 Sep 2011 22:06:35 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-rc3; KDE/4.6.5; x86_64; ; )
References: <201109170935.17777.Eric.Brunet@lps.ens.fr>
In-Reply-To: <201109170935.17777.Eric.Brunet@lps.ens.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109202206.35705.Eric.Brunet@lps.ens.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Tue, 20 Sep 2011 22:06:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reported a bug three days ago about my computer occasionaly not waking up 
(see below) and I have since compiled several kernels to see when the bug 
arrived.

Till now, I have seen the bug trigger on a vanilla 2.6.39-rc3. (Only once, in 
about ten suspend/resume) and I haven't seen it trigger in 2.6.38 nor 2.6.39-
rc1. I am now running 2.6.39-rc1 to see if the bug will eventualy trigger or 
not.

The WARNING with call trace on the fedora kernel that I reported in my 
previous message (see below) also happened in the vanilla kernel in exactly 
the same way. After that initial WARNING, I had four more WARNINGS and one BUG 
in rapid succession, and one final BUG 14 seconds later.

I'd like to know what I can do to help nail this annoying bug. I am not sure 
if I can git bisect it; it is hard to tell offhand if a kernel is good; it may 
resume correctly many times before crashing.

Thanks,

	Éric Brunet

Le samedi 17 septembre 2011 09:35:17, Éric Brunet a écrit :
> Hello,
> 
> Since I upgraded my Dell E4200 laptop to Fedora 15, I have had some problem
> with suspend/resume: occasionaly, the computer would freeze on resume.
> (I suspend by pressing fn-F1. My power manager is the kde plasmoid. I am
> not completely sure which program(s) get(s) launched with what options
> when I press fn-F1...)
> 
> Most of the times when it happens, it freezes before leaving anything
> interesting in the logs, and, on some rare occasion, there is a series of
> WARNING: and a BUG: in the log.
> 
> The computer was working fine with Fedora 14, and is working fine while
> running Fedora 15 with the latest Fedora 14 kernel (2.6.35.6), so the
> problem is kernel related. I have seen it with all the Fedora 15 kernels
> that I have installed from the first one (2.6.38.6) to the latest one
> (2.6.40.4). I have also seen it with a vanilla 3.0.4 kernel that I
> compiled, so it is not a problem specific to fedora.
> 
> The bug does not occur every time. The frequency of occurence depends on
> the kernel version (nearly always on 2.6.38 and 3.04, every 5 or 10 times
> on 2.6.38).
> 
> The full relevant logs are on
> https://bugzilla.redhat.com/show_bug.cgi?id=735404
> 
> but in short, the first warning is
> 
> WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
> Hardware name: Latitude E4200
> list_del corruption, ffff88008b410bb0->next is LIST_POISON1
> (dead000000100100) Modules linked in: ppdev parport_pc lp parport
> cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack arc4 dell_wmi
> sparse_keymap snd_hda_codec_hdmi snd_hda_codec_idt dell_laptop microcode
> dcdbas snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device iwlagn
> uvcvideo i2c_i801 snd_pcm videodev iTCO_wdt joydev iTCO_vendor_support
> media v4l2_compat_ioctl32 mac80211 e1000e cfg80211 snd_timer snd rfkill
> soundcore snd_page_alloc ipv6 firewire_ohci sdhci_pci sdhci mmc_core
> firewire_core crc_itu_t wmi i915 drm_kms_helper drm i2c_algo_bit i2c_core
> video [last unloaded: scsi_wait_scan]
> Pid: 8798, comm: pm-suspend Not tainted 2.6.40.3-0.fc15.x86_64 #1
> Call Trace:
>  [<ffffffff81054c8e>] warn_slowpath_common+0x83/0x9b
>  [<ffffffff81054d49>] warn_slowpath_fmt+0x46/0x48
>  [<ffffffff812457bd>] __list_del_entry+0x8d/0x98
>  [<ffffffff812457d6>] list_del+0xe/0x2d
>  [<ffffffff813b0b3d>] led_trigger_unregister+0x29/0x9c
>  [<ffffffff813b0bc9>] led_trigger_unregister_simple+0x19/0x26
>  [<ffffffff8138c69e>] power_supply_remove_triggers+0x21/0x8f
>  [<ffffffff8138bafe>] power_supply_unregister+0x1f/0x2c
>  [<ffffffff812af9b2>] sysfs_remove_battery+0x2f/0x3e
>  [<ffffffff812b0461>] battery_notify+0x21/0x2f
>  [<ffffffff8148ad8b>] notifier_call_chain+0x37/0x63
>  [<ffffffff810747a3>] __blocking_notifier_call_chain+0x4b/0x60
>  [<ffffffff810747cc>] blocking_notifier_call_chain+0x14/0x16
>  [<ffffffff81089023>] pm_notifier_call_chain+0x1a/0x33
>  [<ffffffff810898f1>] enter_state+0x10a/0x137
>  [<ffffffff81088f42>] state_store+0xaf/0xc5
>  [<ffffffff81237bd3>] kobj_attr_store+0x17/0x19
>  [<ffffffff8117fe80>] sysfs_write_file+0x111/0x14d
>  [<ffffffff811271ad>] vfs_write+0xac/0xf3
>  [<ffffffff8112739c>] sys_write+0x4a/0x6e
>  [<ffffffff8148e182>] system_call_fastpath+0x16/0x1b
> 
> and then all hell breaks loose.
> 
> The warning seems related to battery, and I just want to mention a point
> which is or is not relevant: when I wake up from the working kernel
> (2.6.35), the kde battery plasmoid shows the correct power level
> instantaneously. When I wake up from the non working kernel (2.6.40), the
> battery plasmoid first displays an empty battery for about one second
> before displaying the correct power level.
> 
> Does that ring a bell to someone ? What could I do to help debug this ?
> 
> Thanks
> 
> 	Eric Brunet
