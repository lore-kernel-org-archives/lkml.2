Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2BEWTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:19:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2BEWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:19:23 -0500
Message-ID: <4F2F0065.9040909@lwfinger.net>
Date: Sun, 05 Feb 2012 16:19:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0x1f2/0x200()
References: <20120205134050.7e135bb231b613806a2e0b70@gmail.com>
In-Reply-To: <20120205134050.7e135bb231b613806a2e0b70@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 03:40 PM, Justin P. Mattock wrote:
>
> this showed up as I woke the machine up from suspend. machine is connected
> I just see networkmanager constantly spinning trying to connect then telling me
> the wired network is not connected(even though its just wireless that I have).
>
>
> [ 1584.693284] wlan0: authenticate with 00:1e:2a:62:6b:1e (try 1)
> [ 1584.695279] wlan0: authenticated
> [ 1584.699289] wlan0: associate with 00:1e:2a:62:6b:1e (try 1)
> [ 1584.703037] wlan0: RX AssocResp from 00:1e:2a:62:6b:1e (capab=0x31 status=0 aid=5)
> [ 1584.703043] wlan0: associated
> [ 1584.703054] wlan0: moving STA 00:1e:2a:62:6b:1e to state 1
> [ 1584.703058] wlan0: moving STA 00:1e:2a:62:6b:1e to state 2
> [ 1584.722127] wlan0: moving STA 00:1e:2a:62:6b:1e to state 3
> [ 2270.546555] ------------[ cut here ]------------
> [ 2270.546572] WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0x1f2/0x200()
> [ 2270.546576] Hardware name: 0914
> [ 2270.546580] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> [ 2270.546584] Modules linked in: parport_pc ppdev ipt_REJECT ipt_LOG xt_limit xt_tcpudp dm_crypt joydev xt_addrtype arc4 ath9k snd_hda_codec_hdmi snd_hda_codec_conexant mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm xt_state snd_seq_midi snd_rawmidi nf_conntrack_netbios_ns snd_seq_midi_event nf_conntrack_broadcast snd_seq nf_nat_ftp nf_nat ath9k_common ath9k_hw nf_conntrack_ipv4 nf_defrag_ipv4 uvcvideo ath snd_timer snd_seq_device snd nf_conntrack_ftp videobuf2_core cfg80211 nf_conntrack iptable_filter mei(C) ip_tables intel_ips ideapad_laptop sparse_keymap psmouse lp parport soundcore snd_page_alloc videodev videobuf2_vmalloc x_tables wmi serio_raw videobuf2_memops i915 drm_kms_helper r8169 drm i2c_algo_bit usbhid hid video
> [ 2270.546701] Pid: 0, comm: swapper/1 Tainted: G         C   3.3.0-rc2-00172-g23783f8 #1
> [ 2270.546705] Call Trace:
> [ 2270.546716]  [<c1042d02>] warn_slowpath_common+0x72/0xa0
> [ 2270.546724]  [<c14d59d2>] ? dev_watchdog+0x1f2/0x200
> [ 2270.546730]  [<c14d59d2>] ? dev_watchdog+0x1f2/0x200
> [ 2270.546735]  [<c1042dd3>] warn_slowpath_fmt+0x33/0x40
> [ 2270.546742]  [<c14d59d2>] dev_watchdog+0x1f2/0x200
> [ 2270.546760]  [<c1053c52>] run_timer_softirq+0x132/0x520
> [ 2270.546766]  [<c1053bd8>] ? run_timer_softirq+0xb8/0x520
> [ 2270.546774]  [<c10d0f5c>] ? __rcu_process_callbacks+0x4c/0x3c0
> [ 2270.546780]  [<c14d57e0>] ? pfifo_fast_init+0x60/0x60
> [ 2270.546789]  [<c104ace7>] __do_softirq+0x97/0x340
> [ 2270.546796]  [<c104ac50>] ? __tasklet_hi_schedule_first+0x120/0x120
> [ 2270.546799]<IRQ>   [<c104b236>] ? irq_exit+0x86/0xb0
> [ 2270.546813]  [<c158fef9>] ? smp_apic_timer_interrupt+0x59/0x88
> [ 2270.546822]  [<c12c1028>] ? trace_hardirqs_off_thunk+0xc/0x14
> [ 2270.546828]  [<c1588662>] ? apic_timer_interrupt+0x36/0x3c
> [ 2270.546836]  [<c10a007b>] ? print_kernel_ident+0x4b/0x50
> [ 2270.546844]  [<c1308987>] ? intel_idle+0xd7/0x130
> [ 2270.546853]  [<c14773f0>] ? cpuidle_idle_call+0xb0/0x500
> [ 2270.546859]  [<c10a48f4>] ? trace_hardirqs_on_caller+0xf4/0x180
> [ 2270.546868]  [<c1014a85>] ? cpu_idle+0xa5/0xf0
> [ 2270.546874]  [<c1579545>] ? start_secondary+0x21c/0x222
> [ 2270.546879] ---[ end trace 22be394e4d8a72e0 ]---
> [ 2270.617566] r8169 0000:06:00.0: eth0: link up693284] wlan0: authenticate with 00:1e:2a:62:6b:1e (try 1)
> [ 1584.695279] wlan0: authenticated
> [ 1584.699289] wlan0: associate with 00:1e:2a:62:6b:1e (try 1)
> [ 1584.703037] wlan0: RX AssocResp from 00:1e:2a:62:6b:1e (capab=0x31 status=0 aid=5)
> [ 1584.703043] wlan0: associated
> [ 1584.703054] wlan0: moving STA 00:1e:2a:62:6b:1e to state 1
> [ 1584.703058] wlan0: moving STA 00:1e:2a:62:6b:1e to state 2
> [ 1584.722127] wlan0: moving STA 00:1e:2a:62:6b:1e to state 3
> [ 2270.546555] ------------[ cut here ]------------
> [ 2270.546572] WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0x1f2/0x200()
> [ 2270.546576] Hardware name: 0914
> [ 2270.546580] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> [ 2270.546584] Modules linked in: parport_pc ppdev ipt_REJECT ipt_LOG xt_limit xt_tcpudp dm_crypt joydev xt_addrtype arc4 ath9k snd_hda_codec_hdmi snd_hda_codec_conexant mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm xt_state snd_seq_midi snd_rawmidi nf_conntrack_netbios_ns snd_seq_midi_event nf_conntrack_broadcast snd_seq nf_nat_ftp nf_nat ath9k_common ath9k_hw nf_conntrack_ipv4 nf_defrag_ipv4 uvcvideo ath snd_timer snd_seq_device snd nf_conntrack_ftp videobuf2_core cfg80211 nf_conntrack iptable_filter mei(C) ip_tables intel_ips ideapad_laptop sparse_keymap psmouse lp parport soundcore snd_page_alloc videodev videobuf2_vmalloc x_tables wmi serio_raw videobuf2_memops i915 drm_kms_helper r8169 drm i2c_algo_bit usbhid hid video
> [ 2270.546701] Pid: 0, comm: swapper/1 Tainted: G         C   3.3.0-rc2-00172-g23783f8 #1
> [ 2270.546705] Call Trace:
> [ 2270.546716]  [<c1042d02>] warn_slowpath_common+0x72/0xa0
> [ 2270.546724]  [<c14d59d2>] ? dev_watchdog+0x1f2/0x200
> [ 2270.546730]  [<c14d59d2>] ? dev_watchdog+0x1f2/0x200
> [ 2270.546735]  [<c1042dd3>] warn_slowpath_fmt+0x33/0x40
> [ 2270.546742]  [<c14d59d2>] dev_watchdog+0x1f2/0x200
> [ 2270.546760]  [<c1053c52>] run_timer_softirq+0x132/0x520
> [ 2270.546766]  [<c1053bd8>] ? run_timer_softirq+0xb8/0x520
> [ 2270.546774]  [<c10d0f5c>] ? __rcu_process_callbacks+0x4c/0x3c0
> [ 2270.546780]  [<c14d57e0>] ? pfifo_fast_init+0x60/0x60
> [ 2270.546789]  [<c104ace7>] __do_softirq+0x97/0x340
> [ 2270.546796]  [<c104ac50>] ? __tasklet_hi_schedule_first+0x120/0x120
> [ 2270.546799]<IRQ>   [<c104b236>] ? irq_exit+0x86/0xb0
> [ 2270.546813]  [<c158fef9>] ? smp_apic_timer_interrupt+0x59/0x88
> [ 2270.546822]  [<c12c1028>] ? trace_hardirqs_off_thunk+0xc/0x14
> [ 2270.546828]  [<c1588662>] ? apic_timer_interrupt+0x36/0x3c
> [ 2270.546836]  [<c10a007b>] ? print_kernel_ident+0x4b/0x50
> [ 2270.546844]  [<c1308987>] ? intel_idle+0xd7/0x130
> [ 2270.546853]  [<c14773f0>] ? cpuidle_idle_call+0xb0/0x500
> [ 2270.546859]  [<c10a48f4>] ? trace_hardirqs_on_caller+0xf4/0x180
> [ 2270.546868]  [<c1014a85>] ? cpu_idle+0xa5/0xf0
> [ 2270.546874]  [<c1579545>] ? start_secondary+0x21c/0x222
> [ 2270.546879] ---[ end trace 22be394e4d8a72e0 ]---
> [ 2270.617566] r8169 0000:06:00.0: eth0: link up
>
> full dmesg is here..:
> http://fpaste.org/007p/

The error clearly comes from r8169, not from ath9k. If you unload r8169 before 
suspending, does this still happen? My suspicion is that NM is getting confused.

Larry

P.S. Unless it happens with just the ath9k active, this ML is likely not the 
correct one.
