Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2BUGAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 01:00:48 -0500
Received: from gherkin.frus.com ([192.158.254.49]:59087 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab2BUGAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 01:00:47 -0500
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 01:00:46 EST
Date: Mon, 20 Feb 2012 23:41:59 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 3.3.0-rcX: kjournald
Message-ID: <20120221054159.GA1919@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if I caught a complete instance of this in "syslog", but
here's what I've been seeing with 3.3.0-rc[1-3] kernels.  Shortly after
booting multi-user, logging in, and attempting a package build, the
"fun" starts: the following message scrolls repeatedly (possibly with
different details) across the console.  To date, I've had to hit the
reset switch to recover, which is why I'm not sure whether I caught a
complete syslog entry.

BUG: scheduling while atomic: kjournald/943/0x00000002
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd soundcore af_packet ipv6 bsd_comp ppp_generic slhc usbhid uhci_hcd ehci_hcd usbcore usb_common binfmt_misc
Pid: 943, comm: kjournald Not tainted 3.3.0-rc3 #1
Call Trace:
 [<c1269968>] ? __schedule+0x57/0x3df
 [<c113e0de>] ? cfq_exit_icq+0x2f/0x39
 [<c126a0be>] ? io_schedule+0x2f/0x3e
 [<c10a72b4>] ? sleep_on_buffer+0x5/0x8
 [<c1268acb>] ? __wait_on_bit+0x33/0x58
 [<c10a72af>] ? unmap_underlying_metadata+0x29/0x29
 [<c1268ba2>] ? out_of_line_wait_on_bit+0xb2/0xba
 [<c10a72af>] ? unmap_underlying_metadata+0x29/0x29
 [<c1036655>] ? autoremove_wake_function+0x2d/0x2d
 [<c10a7283>] ? __wait_on_buffer+0x1c/0x1f
 [<c10e9800>] ? journal_commit_transaction+0x9cf/0xf5f
 [<c100309c>] ? do_IRQ+0x5c/0x6c
 [<c103d2ec>] ? __wake_up+0x2f/0x5b
 [<c103d2fa>] ? __wake_up+0x3d/0x5b
 [<c1036817>] ? prepare_to_wait+0x44/0x60
 [<c10ebe34>] ? kjournald+0xd1/0x206
 [<c1036628>] ? wake_up_bit+0x5c/0x5c

Processor is an AMD K6-III/450.  Disks are SCSI.  Controller is an
Adaptec AHA-2930U2.

--Bob Tracy
