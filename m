Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061Ab2CFSrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:47:21 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43588 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964947Ab2CFSrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:47:20 -0500
Message-ID: <4F565BC0.9010302@xenotime.net>
Date: Tue, 06 Mar 2012 10:47:28 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: drm: i915 hangcheck/GPU errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My Toshiba Portege (Intel Core i5) hangs every few days.
Sometimes I can see no log messages/reasons for it.
Sometimes there are messages about X receiving potentially
fatal signals.

Today's hang appears to have some useful info (maybe).

Mar  6 09:01:45 dragon kernel: [137308.704424] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Mar  6 09:01:45 dragon kernel: [137308.704552] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
Mar  6 09:01:45 dragon kernel: [137308.718950] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 16513584 at 16513581, next 16513585)
Mar  6 09:02:13 dragon kernel: [137336.754647] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Mar  6 09:02:13 dragon kernel: [137336.754698] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 16517081 at 16517078, next 16517082)

...

Mar  6 09:05:44 dragon kernel: [137548.071904] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Mar  6 09:05:44 dragon kernel: [137548.071951] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 16550939 at 16550936, next 16550940)
Mar  6 09:05:57 dragon kernel: [137560.924459] X/1399: potentially unexpected fatal signal 6.
Mar  6 09:05:57 dragon kernel: [137560.924463] 
Mar  6 09:05:57 dragon kernel: [137560.924466] CPU 1 
Mar  6 09:05:57 dragon kernel: [137560.924468] Modules linked in: usblp snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 af_packet acpi_cpufreq mperf lp ppdev parport_pc parport snd_hda_codec_hdmi snd_hda_codec_realtek uvcvideo videobuf2_core videobuf2_vmalloc videobuf2_memops usbhid hid mousedev snd_hda_codec arc4 snd_hwdep iwlwifi toshiba_acpi psmouse snd_pcm snd_timer sparse_keymap ehci_hcd battery serio_raw mac80211 evdev thermal ac xhci_hcd snd_page_alloc wmi power_supply e1000e mei(C) sdhci_pci sdhci mmc_core firmware_class cfg80211 rfkill processor sg rtc_cmos loop unix [last unloaded: snd_hda_intel]
Mar  6 09:05:57 dragon kernel: [137560.924560] 
Mar  6 09:05:58 dragon kernel: [137560.924564] Pid: 1399, comm: X Tainted: G         C   3.3.0-rc5 #2 TOSHIBA PORTEGE R835/Portable PC
Mar  6 09:05:58 dragon kernel: [137560.924572] RIP: 0033:[<00007f57463c7035>]  [<00007f57463c7035>] 0x7f57463c7034
Mar  6 09:05:58 dragon kernel: [137560.924581] RSP: 002b:00007fff0ac33758  EFLAGS: 00003206
Mar  6 09:05:58 dragon kernel: [137560.924585] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffffffffff
Mar  6 09:05:58 dragon kernel: [137560.924589] RDX: 0000000000000006 RSI: 0000000000000577 RDI: 0000000000000577
Mar  6 09:05:58 dragon kernel: [137560.924593] RBP: 00007fff0ac341a0 R08: 00007f57464ee8e0 R09: 0000000000411e40
Mar  6 09:05:59 dragon kernel: [137560.924597] R10: 0000000000000008 R11: 0000000000003206 R12: 0000000000000037
Mar  6 09:06:00 dragon kernel: [137560.924600] R13: 00007fff0ac33a80 R14: 000000000000004f R15: 0000000000000007
Mar  6 09:06:00 dragon kernel: [137560.924604] FS:  00007f57487a18a0(0000) GS:ffff88014a600000(0000) knlGS:0000000000000000
Mar  6 09:06:02 dragon kernel: [137560.924609] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar  6 09:06:02 dragon kernel: [137560.924612] CR2: 0000000000418ff0 CR3: 000000013d059000 CR4: 00000000000406e0
Mar  6 09:06:02 dragon kernel: [137560.924616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  6 09:06:02 dragon kernel: [137560.924620] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  6 09:06:03 dragon kernel: [137560.924624] Process X (pid: 1399, threadinfo ffff88013e9cc000, task ffff880124120000)
Mar  6 09:06:03 dragon kernel: [137560.924627] 
Mar  6 09:06:03 dragon kernel: [137560.924630] Call Trace:

</end>


Any ideas/suggestions?



"look for more information in /debug/dri/0/i915_error_state"

Where is that file?  in debugfs or somewhere else?

thanks,
-- 
~Randy
