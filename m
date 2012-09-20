Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2ITImH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:42:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58981 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2ITImC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:42:02 -0400
Message-ID: <505AD51F.7050709@gmail.com>
Date: Thu, 20 Sep 2012 01:34:39 -0700
From: Stephen Boyd <bebarino@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110911 Thunderbird/6.0
MIME-Version: 1.0
To: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org
Subject: rt73usb WARNING: at net/mac80211/driver-ops.h:12 check_sdata_in_driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed that if I suspend to disk and then resume with my usb wifi
adapter plugged in I get a spew of these warnings from what looks to be
the wifi driver and some warning from the usb layer. Are these known issues?

rt73usb 1-2:1.0: no reset_resume for driver rt73usb?

WARNING: at net/mac80211/driver-ops.h:12 check_sdata_in_driver+0x32/0x34()
Hardware name: MS-7094
wlan0:  Failed check-sdata-in-driver check, flags: 0x4
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
snd_seq_virmidi snd_seq_midi_emul snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss radeon snd_emu10k1
snd_rawmidi snd_ac97_codec ac97_bus ttm drm_kms_helper snd_pcm
snd_seq_device snd_timer drm snd_page_alloc snd_util_mem snd_hwdep snd
i2c_algo_bit rt73usb crc_itu_t rt2x00usb cfbcopyarea cfbimgblt rt2x00lib
cfbfillrect parport_pc edac_core via82cxxx edac_mce_amd floppy parport
soundcore k8temp powernow_k8 mperf r8169 mii
Pid: 2525, comm: kworker/u:14 Not tainted 3.6.0-rc6-00052-gc46de22 #126
Call Trace:
 [<ffffffff8102e13a>] warn_slowpath_common+0x85/0x9d
 [<ffffffff8102e1f5>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff81495f1f>] check_sdata_in_driver+0x32/0x34
 [<ffffffff81497f20>] drv_mgd_prepare_tx+0x33/0xda
 [<ffffffff81498099>] ieee80211_send_deauth_disassoc+0xd2/0xeb
 [<ffffffff81498db8>] ieee80211_set_disassoc+0x169/0x2ab
 [<ffffffff814990d8>] ieee80211_mgd_deauth+0xc0/0x155
 [<ffffffff81477f5e>] ieee80211_deauth+0x18/0x1a
 [<ffffffff8145ec09>] __cfg80211_mlme_deauth+0xd9/0xec
 [<ffffffff8146210a>] __cfg80211_disconnect+0x12d/0x1a5
 [<ffffffff8144b1a3>] ? cfg80211_netdev_notifier_call+0x2ba/0x559
 [<ffffffff8144b1d9>] cfg80211_netdev_notifier_call+0x2f0/0x559
 [<ffffffff814b54bf>] notifier_call_chain+0x68/0x9c
 [<ffffffff814afb9c>] ? __mutex_lock_common+0x322/0x34e
 [<ffffffff81052311>] raw_notifier_call_chain+0x14/0x16
 [<ffffffff813846ac>] call_netdevice_notifiers+0x4a/0x4f
 [<ffffffff81384710>] __dev_close_many+0x5f/0xbf
 [<ffffffff81384827>] dev_close_many+0x71/0xd9
 [<ffffffff813849a9>] rollback_registered_many+0xcf/0x29a
 [<ffffffff81384b8d>] unregister_netdevice_many+0x19/0x51
 [<ffffffff81473389>] ieee80211_remove_interfaces+0xa6/0xbd
 [<ffffffff81466236>] ieee80211_unregister_hw+0x53/0x101
 [<ffffffffa0087bea>] rt2x00lib_remove_dev+0xe4/0x16d [rt2x00lib]
 [<ffffffffa00a00cc>] rt2x00usb_disconnect+0x2e/0x61 [rt2x00usb]
 [<ffffffff8132c07d>] usb_unbind_interface+0x7f/0x160
 [<ffffffff812c5103>] __device_release_driver+0x86/0xd9
 [<ffffffff812c5237>] device_release_driver+0x25/0x32
 [<ffffffff8132c3dd>] usb_driver_release_interface+0x4c/0x82
 [<ffffffff8132c45b>] usb_forced_unbind_intf+0x48/0x51
 [<ffffffff8132c4db>] usb_resume+0x77/0xa1
 [<ffffffff8131e91d>] ? usb_disabled+0x12/0x12
 [<ffffffff8131e930>] usb_dev_restore+0x13/0x15
 [<ffffffff812cb460>] dpm_run_callback+0x4a/0x88
 [<ffffffff812cc4be>] device_resume+0x145/0x184
 [<ffffffff812cc735>] async_resume+0x21/0x48
 [<ffffffff81053768>] async_run_entry_fn+0x9a/0x152
 [<ffffffff81048a9b>] process_one_work+0x273/0x3f6
 [<ffffffff810489f7>] ? process_one_work+0x1cf/0x3f6
 [<ffffffff810536ce>] ? async_schedule+0x17/0x17
 [<ffffffff81049024>] worker_thread+0x226/0x2ea
 [<ffffffff81048dfe>] ? rescuer_thread+0x1e0/0x1e0
 [<ffffffff8104ccf6>] kthread+0xa4/0xac
 [<ffffffff81074ca1>] ? trace_hardirqs_on_caller+0x16/0x161
 [<ffffffff814b9e24>] kernel_thread_helper+0x4/0x10
 [<ffffffff814b2219>] ? retint_restore_args+0xe/0xe
 [<ffffffff8104cc52>] ? __init_kthread_worker+0x5b/0x5b
 [<ffffffff814b9e20>] ? gs_change+0xb/0xb
