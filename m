Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2ARSZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:25:31 -0500
Received: from mailout01.t-online.de ([194.25.134.80]:35102 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2ARSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:25:29 -0500
Message-ID: <4F170E93.5070604@t-online.de>
Date: Wed, 18 Jan 2012 19:25:23 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
        Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [BUG] v3.2.1: circular locking dvb_device_open / videobuf_dvb_find_frontend
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: rfvPjZZ1ghY2TcuGFFtVfawAyLn+IBszsf8fUx3IUAvVuXk33OS0jfyVs-iOyXQguV
X-TOI-MSGID: 20519675-396b-43aa-8afc-a852b22deeaf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System
======
AOpen i915GMm-hfs mobo with Pentium-M (Dothan) and 2GB
distribution: openSuSE 12.1
kernel: v3.2.1 (commit b8ed9e5b8c34dc9...)
xorg: current git master
kaffeine: 1.2.2
reproducibility: 100%

After installation of a Hauppauge WinTV Nova HD-S2
I see the following kernel info:

[ 11.528283] udevd[390]: starting version 173
[ 12.493113] Linux video capture interface: v2.00
[ 12.897710] IR NEC protocol handler initialized
[ 13.018103] IR RC5(x) protocol handler initialized
[ 13.119275] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[ 13.131005] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[ 13.137251] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
[ 13.141210] cx88[0]: TV tuner type -1, Radio tuner type -1
[ 13.201058] IR RC6 protocol handler initialized
[ 13.261732] IR JVC protocol handler initialized
[ 13.393637] i2c-core: driver [tuner] using legacy suspend method
[ 13.409331] IR Sony protocol handler initialized
[ 13.420037] i2c-core: driver [tuner] using legacy resume method
[ 13.450185] IR MCE Keyboard/mouse protocol handler initialized
[ 13.540261] tveeprom 17-0050: Hauppauge model 69100, rev B4C3, serial# 7900937
[ 13.543914] tveeprom 17-0050: MAC address is 00:0d:fe:78:8f:09
[ 13.547637] tveeprom 17-0050: tuner model is Conexant CX24118A (idx 123, type 4)
[ 13.551355] tveeprom 17-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
[ 13.554965] tveeprom 17-0050: audio processor is None (idx 0)
[ 13.558488] tveeprom 17-0050: decoder processor is CX880 (idx 20)
[ 13.561975] tveeprom 17-0050: has no radio, has IR receiver, has no IR transmitter
[ 13.565472] cx88[0]: hauppauge eeprom: model=69100
[ 13.587102] cx2388x alsa driver version 0.0.9 loaded
[ 13.608928] lirc_dev: IR Remote Control driver registered, major 251
[ 13.694230] IR LIRC bridge handler initialized
[ 13.709152] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 13.716593] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[ 13.716655] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[ 13.724033] Registered IR keymap rc-hauppauge
[ 13.742601] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0/input5
[ 13.751082] rc0: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0
[ 13.774993] input: MCE IR Keyboard/Mouse (cx88xx) as /devices/virtual/input/input6
[ 13.782063] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
[ 13.787629] cx88[0]/2: cx2388x 8802 Driver Manager
[ 13.793692] cx88-mpeg driver manager 0000:05:05.2: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 13.800770] cx88[0]/2: found at 0000:05:05.2, rev: 5, irq: 17, latency: 32, mmio: 0xd3000000
[ 13.818585] cx8800 0000:05:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 13.828935] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[ 13.834870] cx88[0]/0: found at 0000:05:05.0, rev: 5, irq: 17, latency: 32, mmio: 0xd1000000
[ 13.844582] cx88[0]/0: registered device video0 [v4l2]
[ 13.861254] cx88[0]/0: registered device vbi0
[ 13.883504] snd_rme96 0000:05:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 13.891201] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[ 13.896111] cx88/2: registering cx8802 driver, type: dvb access: shared
[ 13.899622] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[ 13.910340] cx88_audio 0000:05:05.1: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 13.914069] cx88[0]/2: cx2388x based DVB/ATSC card
[ 13.917646] cx8802_alloc_frontends() allocating 1 frontend(s)
[ 13.924218] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[ 13.999524] DVB: registering new adapter (cx88[0])
[ 14.004892] DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
[...]
[ 143.850012]
[ 143.850019] ======================================================
[ 143.850027] [ INFO: possible circular locking dependency detected ]
[ 143.850036] 3.2.1-main #19
[ 143.850040] -------------------------------------------------------
[ 143.850048] kaffeine/3749 is trying to acquire lock:
[ 143.850055] (&fe->lock){+.+.+.}, at: [<f86ba0cf>] videobuf_dvb_find_frontend+0x16/0x3e [videobuf_dvb]
[ 143.850074]
[ 143.850075] but task is already holding lock:
[ 143.850082] (minor_rwsem#2){++++..}, at: [<f9de10c8>] dvb_device_open+0x24/0x185 [dvb_core]
[ 143.850102]
[ 143.850103] which lock already depends on the new lock.
[ 143.850105]
[ 143.850113]
[ 143.850114] the existing dependency chain (in reverse order) is:
[ 143.850123]
[ 143.850124] -> #2 (minor_rwsem#2){++++..}:
[ 143.850135] [<c0148809>] lock_acquire+0x45/0x5c
[ 143.850148] [<c043850b>] down_write+0x1b/0x36
[ 143.850158] [<f9de151c>] dvb_register_device+0x10e/0x1e8 [dvb_core]
[ 143.850173] [<f9de777d>] dvb_register_frontend+0x168/0x17f [dvb_core]
[ 143.850190] [<f86ba266>] videobuf_dvb_register_bus+0xbe/0x2ca [videobuf_dvb]
[ 143.850202] [<f9d59be3>] cx8802_dvb_probe+0x1df5/0x1e6a [cx88_dvb]
[ 143.850215] [<f85e4420>] cx8802_register_driver+0x116/0x1cc [cx8802]
[ 143.850231] [<f85ea01c>] 0xf85ea01c
[ 143.850241] [<c0101070>] do_one_initcall+0x70/0x118
[ 143.850250] [<c014f702>] sys_init_module+0x1346/0x15ab
[ 143.850260] [<c043961d>] syscall_call+0x7/0xb
[ 143.850269]
[ 143.850270] -> #1 (dvbdev_register_lock){+.+.+.}:
[ 143.850281] [<c0148809>] lock_acquire+0x45/0x5c
[ 143.850290] [<c0437fd2>] mutex_lock_nested+0x35/0x275
[ 143.850300] [<f9de142d>] dvb_register_device+0x1f/0x1e8 [dvb_core]
[ 143.850314] [<f9de19a1>] dvb_dmxdev_init+0xc0/0xf0 [dvb_core]
[ 143.850328] [<f86ba311>] videobuf_dvb_register_bus+0x169/0x2ca [videobuf_dvb]
[ 143.850340] [<f9d59be3>] cx8802_dvb_probe+0x1df5/0x1e6a [cx88_dvb]
[ 143.850351] [<f85e4420>] cx8802_register_driver+0x116/0x1cc [cx8802]
[ 143.850363] [<f85ea01c>] 0xf85ea01c
[ 143.850371] [<c0101070>] do_one_initcall+0x70/0x118
[ 143.850379] [<c014f702>] sys_init_module+0x1346/0x15ab
[ 143.850388] [<c043961d>] syscall_call+0x7/0xb
[ 143.850397]
[ 143.850398] -> #0 (&fe->lock){+.+.+.}:
[ 143.850407] [<c0147f54>] __lock_acquire+0xd88/0x12b8
[ 143.850416] [<c0148809>] lock_acquire+0x45/0x5c
[ 143.850425] [<c0437fd2>] mutex_lock_nested+0x35/0x275
[ 143.850434] [<f86ba0cf>] videobuf_dvb_find_frontend+0x16/0x3e [videobuf_dvb]
[ 143.850446] [<f9d57d76>] cx88_dvb_bus_ctrl+0x22/0x9a [cx88_dvb]
[ 143.850457] [<f9de7472>] dvb_frontend_open+0x14b/0x2ee [dvb_core]
[ 143.850472] [<f9de1173>] dvb_device_open+0xcf/0x185 [dvb_core]
[ 143.850486] [<c0192fad>] chrdev_open+0x14e/0x16c
[ 143.850504] [<c018e694>] __dentry_open+0x193/0x288
[ 143.850518] [<c018f4d6>] nameidata_to_filp+0x42/0x50
[ 143.850530] [<c019a927>] do_last+0x6da/0x6ec
[ 143.850543] [<c019a9fe>] path_openat+0xa0/0x2c1
[ 143.850555] [<c019accb>] do_filp_open+0x21/0x5d
[ 143.850567] [<c018f5d0>] do_sys_open+0xec/0x165
[ 143.850580] [<c018f667>] sys_open+0x1e/0x26
[ 143.850591] [<c043961d>] syscall_call+0x7/0xb
[ 143.850603]
[ 143.850604] other info that might help us debug this:
[ 143.850606]
[ 143.850625] Chain exists of:
[ 143.850626] &fe->lock --> dvbdev_register_lock --> minor_rwsem
[ 143.850643]
[ 143.850654] Possible unsafe locking scenario:
[ 143.850655]
[ 143.850669] CPU0 CPU1
[ 143.850678] ---- ----
[ 143.850687] lock(minor_rwsem);
[ 143.850697] lock(dvbdev_register_lock);
[ 143.850710] lock(minor_rwsem);
[ 143.850722] lock(&fe->lock);
[ 143.850732]
[ 143.850733] *** DEADLOCK ***
[ 143.850734]
[ 143.850752] 2 locks held by kaffeine/3749:
[ 143.850761] #0: (dvbdev_mutex){+.+...}, at: [<f9de10be>] dvb_device_open+0x1a/0x185 [dvb_core]
[ 143.850784] #1: (minor_rwsem#2){++++..}, at: [<f9de10c8>] dvb_device_open+0x24/0x185 [dvb_core]
[ 143.850808]
[ 143.850809] stack backtrace:
[ 143.850823] Pid: 3749, comm: kaffeine Not tainted 3.2.1-main #19
[ 143.850834] Call Trace:
[ 143.850846] [<c0124a2d>] ? console_unlock+0x1ad/0x1d3
[ 143.850859] [<c0432dad>] print_circular_bug+0x215/0x222
[ 143.850872] [<c0147f54>] __lock_acquire+0xd88/0x12b8
[ 143.850884] [<c0103cc3>] ? print_context_stack+0x7a/0x8d
[ 143.850896] [<c01031c4>] ? dump_trace+0x78/0xa5
[ 143.850909] [<c0148809>] lock_acquire+0x45/0x5c
[ 143.850922] [<f86ba0cf>] ? videobuf_dvb_find_frontend+0x16/0x3e [videobuf_dvb]
[ 143.850938] [<f86ba0cf>] ? videobuf_dvb_find_frontend+0x16/0x3e [videobuf_dvb]
[ 143.850952] [<c0437fd2>] mutex_lock_nested+0x35/0x275
[ 143.850966] [<f86ba0cf>] ? videobuf_dvb_find_frontend+0x16/0x3e [videobuf_dvb]
[ 143.850981] [<f86ba0cf>] videobuf_dvb_find_frontend+0x16/0x3e [videobuf_dvb]
[ 143.850998] [<f9d57d76>] cx88_dvb_bus_ctrl+0x22/0x9a [cx88_dvb]
[ 143.851017] [<f9de7472>] dvb_frontend_open+0x14b/0x2ee [dvb_core]
[ 143.851037] [<f9de1173>] dvb_device_open+0xcf/0x185 [dvb_core]
[ 143.851051] [<c0192fad>] chrdev_open+0x14e/0x16c
[ 143.851064] [<c018e694>] __dentry_open+0x193/0x288
[ 143.851077] [<c043b91c>] ? sub_preempt_count+0x81/0x8e
[ 143.851089] [<c018f4d6>] nameidata_to_filp+0x42/0x50
[ 143.851101] [<c0192e5f>] ? cdev_put+0x1a/0x1a
[ 143.851112] [<c019a927>] do_last+0x6da/0x6ec
[ 143.851124] [<c019a9fe>] path_openat+0xa0/0x2c1
[ 143.851136] [<c019accb>] do_filp_open+0x21/0x5d
[ 143.851149] [<c043b91c>] ? sub_preempt_count+0x81/0x8e
[ 143.851161] [<c04392e2>] ? _raw_spin_unlock+0x27/0x3d
[ 143.851174] [<c01a3a4f>] ? alloc_fd+0xb3/0xbe
[ 143.851186] [<c018f5d0>] do_sys_open+0xec/0x165
[ 143.851198] [<c018f667>] sys_open+0x1e/0x26
[ 143.851209] [<c043961d>] syscall_call+0x7/0xb
[ 143.851220] [<c0430000>] ? w83627hf_probe+0x25b/0x7e2

It´s the first time I use DVB-S card with linux, so I don´t know when
this bug was introduced. If necessary I could bisect.

BTW: maybe it would be a good idea to enable a few more
kernel debug options by default ...

cu,
Knut
