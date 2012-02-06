Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2BFAcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 19:32:10 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34068 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2BFAcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 19:32:08 -0500
Date: Mon, 6 Feb 2012 00:29:07 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        ath9k-devel@venema.h4ckr.net
Subject: [3.3-rc2+] Thousands of ath9k warnings on dmesg before laptop froze
Message-ID: <20120206002907.GA1899@Pilar.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm testing the latest kernel 3.3.0-rc2+ I pulled from git 
this morning.

My laptop just froze, and when I rebooted I noticed that /var/log/messages
contained 48 thousand (!) warnings coming from ath9k since a few hours 
ago. I'm pasting the first one:


 ------------[ cut here ]------------
 WARNING: at /home/mafra/linux-2.6/drivers/net/wireless/ath/ath9k/rc.c:697 ath_rc_get_highest_rix+0x156/0x210 [ath9k]()
 Hardware name: VPCEB4X1E
 Modules linked in: dvb_usb_dib0700 dib0090 dib7000p dib7000m dib0070 dib8000 dib3000mc dibx000_common af_packet snd_pcm_oss snd_mixer_oss microcode arc4 sr_mod cdrom sg ath9k mac80211 uvcvideo ath9k_common ath9k_hw videobuf2_core videobuf2_vmalloc videobuf2_memops ath i2c_i801 cfg80211 sony_laptop rfkill radeon ttm drm_kms_helper drm i2c_algo_bit
 Pid: 48, comm: kworker/u:6 Not tainted 3.3.0-rc2+ #6
 Call Trace:
  [<ffffffff81032f2a>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff81032f75>] warn_slowpath_null+0x15/0x20
  [<ffffffffa0298eb6>] ath_rc_get_highest_rix+0x156/0x210 [ath9k]
  [<ffffffffa0298ff3>] ath_get_rate+0x83/0x480 [ath9k]
  [<ffffffffa024f006>] rate_control_get_rate+0x86/0x160 [mac80211]
  [<ffffffffa025a112>] invoke_tx_handlers+0x7b2/0x1420 [mac80211]
  [<ffffffff81061a00>] ? load_balance+0x90/0x8a0
  [<ffffffffa025af22>] ieee80211_tx+0x82/0xf0 [mac80211]
  [<ffffffffa025b030>] ieee80211_xmit+0xa0/0x100 [mac80211]
  [<ffffffffa025c23a>] ieee80211_tx_skb_tid+0x5a/0x70 [mac80211]
  [<ffffffffa0246f56>] ieee80211_send_nullfunc+0x56/0x70 [mac80211]
  [<ffffffffa0248460>] ieee80211_dynamic_ps_enable_work+0x240/0x310 [mac80211]
  [<ffffffffa0248220>] ? ieee80211_dynamic_ps_disable_work+0x50/0x50 [mac80211]
  [<ffffffff81048d67>] process_one_work+0x117/0x390
  [<ffffffff81049899>] worker_thread+0x169/0x350
  [<ffffffff81049730>] ? manage_workers+0x240/0x240
  [<ffffffff8104f096>] kthread+0x96/0xa0
  [<ffffffff814f7714>] kernel_thread_helper+0x4/0x10
  [<ffffffff8104f000>] ? flush_kthread_worker+0xb0/0xb0
  [<ffffffff814f7710>] ? gs_change+0xb/0xb
 ---[ end trace 7a4892c93f508f3a ]---
 ------------[ cut here ]------------


I must say that until the laptop froze, I didn't notice anything unusual
to the point of checking my dmesg. Sometimes the internet was slow,
but I thought it was unrelated to the kernel.

Is there any other info I should provide or the above warning is enough?


