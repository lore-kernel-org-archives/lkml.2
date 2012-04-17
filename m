Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2DQPY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:24:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53183 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752661Ab2DQPY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:24:56 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18TWEQIPtITWAMEjZn2qM17r/nz7kYa2p0QHZPBU6
	/s9fCQEy88ma4E
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel panic after suspend/resume (was: Linux 3.4-rc3)
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
Date: Tue, 17 Apr 2012 17:24:49 +0200
In-Reply-To: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 15 Apr 2012 18:49:16 -0700")
Message-ID: <87pqb6fkji.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Linux 3.4-rc3, I'm experiencing crashes after resuming from
suspend, not immediately but after a few minutes.  This has happened
three times so far, note that 3.4-rc2 worked fine.

[29747.810224] BUG: unable to handle kernel NULL pointer dereference at           (null)
[29747.810359] IP: [<          (null)>]           (null)
[29747.810359] PGD c71d9067 PUD c7217067 PMD 0 
[29747.810359] Oops: 0010 [#1] SMP 
[29747.810359] CPU 0 
[29747.810359] Modules linked in: netconsole ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables x_tables nfsd exportfs nfs_acl auth_rpcgss lockd sunrpc binfmt_misc aes_generic ipv6 cryptomgr aead arc4 crypto_algapi rt73usb rt2x00usb rt2x00lib mac80211 cfg80211 crc_itu_t snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_oss snd_seq_midi_event 8250_pnp snd_seq coretemp pcspkr snd_seq_device snd_timer 8250 serial_core parport_pc acpi_cpufreq i2c_i801 mperf parport intel_agp snd evdev intel_gtt processor microcode soundcore nouveau uhci_hcd video mxm_wmi fan thermal button sr_mod cdrom ehci_hcd wmi hwmon drm_kms_helper ttm drm sky2 usbcore usb_common [last unloaded: netconsole]
[29747.810359] 
[29747.810359] Pid: 0, comm: swapper/0 Not tainted 3.4.0-rc3-nouveau #1 . ./I-45C(Intel i945GC-ICH7)
[29747.810359] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[29747.810359] RSP: 0018:ffff8800cfc03ee0  EFLAGS: 00010046
[29747.810359] RAX: ffffffff813a6780 RBX: ffffffff813a2600 RCX: ffffffffffffffcf
[29747.810359] RDX: 0000000000000066 RSI: 0000000000000000 RDI: ffffffff813a6780
[29747.810359] RBP: ffff8800cf006080 R08: ffff8800cf006080 R09: 0000000000000002
[29747.810359] R10: 000000000000000c R11: ffff8800caf0d790 R12: 0000000000000000
[29747.810359] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[29747.810359] FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
[29747.810359] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[29747.810359] CR2: 0000000000000000 CR3: 00000000c7308000 CR4: 00000000000007f0
[29747.810359] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[29747.810359] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[29747.810359] Process swapper/0 (pid: 0, threadinfo ffffffff8138e000, task ffffffff813a1020)
[29747.810359] Stack:
[29747.810359]  ffffffff81003951 ffffffff81019593 ffffffff8106a8c7 ffff8800cf006080
[29747.810359]  ffff8800cf006080 ffff8800cf00610c 0000000000000000 ffffffff8138fed8
[29747.810359]  0000000000000000 0000000000000000 ffffffff8106a9eb ffffffffffffffcf
[29747.810359] Call Trace:
[29747.810359]  <IRQ> 
[29747.810359]  [<ffffffff81003951>] ? timer_interrupt+0xd/0x14
[29747.810359]  [<ffffffff81019593>] ? default_inquire_remote_apic+0xf/0xf
[29747.810359]  [<ffffffff8106a8c7>] ? handle_irq_event_percpu+0x24/0x11a
[29747.810359]  [<ffffffff8106a9eb>] ? handle_irq_event+0x2e/0x4f
[29747.810359]  [<ffffffff8106cd39>] ? handle_edge_irq+0xbb/0xdc
[29747.810359]  [<ffffffff81003356>] ? handle_irq+0x1a/0x1e
[29747.810359]  [<ffffffff8100308d>] ? do_IRQ+0x42/0xa7
[29747.810359]  [<ffffffff8128eb27>] ? common_interrupt+0x67/0x67
[29747.810359]  <EOI> 
[29747.810359]  [<ffffffff8100838b>] ? mwait_idle+0x5a/0x5d
[29747.810359]  [<ffffffff81008b15>] ? cpu_idle+0x55/0x8f
[29747.810359]  [<ffffffff813e3a74>] ? start_kernel+0x32f/0x33a
[29747.810359]  [<ffffffff813e348f>] ? loglevel+0x34/0x34
[29747.810359] Code:  Bad RIP value.
[29747.810359] RIP  [<          (null)>]           (null)
[29747.810359]  RSP <ffff8800cfc03ee0>
[29747.810359] CR2: 0000000000000000
[29747.810359] ---[ end trace ed1a30f4a6c65235 ]---
[29747.810359] Kernel panic - not syncing: Fatal exception in interrupt
[29747.810359] panic occurred, switching back to text console

