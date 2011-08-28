Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1H1NPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 09:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab1H1NPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 09:15:06 -0400
Date: Sun, 28 Aug 2011 09:15:03 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
 [3.0]
Message-ID: <20110828131502.GA2580@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just saw this on a box that was recieving an rsync while I ssh'd in.
The ssh session hung.

(version says 2.6.40, it's 3.0 in all but name)

	Dave

WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
Hardware name:         
Modules linked in: nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc p4_clockmod freq_table speedstep_lib nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack microcode serio_raw snd_hda_codec_realtek i2c_i801 snd_hda_intel snd_hda_codec iTCO_wdt snd_hwdep iTCO_vendor_support snd_seq snd_seq_device snd_pcm snd_timer snd r8169 soundcore mii snd_page_alloc pata_sil680 i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: mperf]
Pid: 1381, comm: sshd Not tainted 2.6.40-4.fc15.x86_64.debug #1
Call Trace:
 [<ffffffff81058e74>] warn_slowpath_common+0x83/0x9b
 [<ffffffff81058ea6>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff812f8e18>] tty_ldisc_reinit+0x52/0x90
 [<ffffffff812f9415>] tty_ldisc_hangup+0x13f/0x1e1
 [<ffffffff812f21b6>] __tty_hangup+0x111/0x35f
 [<ffffffff812f2429>] tty_vhangup+0xe/0x10
 [<ffffffff812faade>] pty_close+0x128/0x132
 [<ffffffff812f3404>] tty_release+0x1d8/0x4dc
 [<ffffffff81087a2e>] ? lock_release_holdtime.part.8+0x6b/0x72
 [<ffffffff8100eebf>] ? native_sched_clock+0x34/0x36
 [<ffffffff8113cdb2>] fput+0x127/0x1f5
 [<ffffffff81139d90>] filp_close+0x70/0x7b
 [<ffffffff81139e91>] sys_close+0xf6/0x13b
 [<ffffffff814fdf02>] system_call_fastpath+0x16/0x1b
---[ end trace 639fa37f00e1dc5b ]---

