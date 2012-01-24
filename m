Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2AXB0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:26:36 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34676 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2AXB0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:26:35 -0500
Date: Tue, 24 Jan 2012 10:26:33 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: Regression 3.2 -> 3.3-rc1 sound hda-intel broken
Message-ID: <20120124012633.GA18436@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please Cc)

in 3.3-rc1 it seems that snd-hda-intel is broken. 

3.2:
[   22.517541] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   22.519252] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   22.519280] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   22.805373] hda_codec: ALC262: SKU not ready 0x411111f0
[   22.806931] hda_codec: ALC262: BIOS auto-probing.
[   22.810408] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input11
[   22.814098] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   22.815716] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13


3.3-rc1:
[   39.588007] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x100f0000
[   40.592006] hda-intel: No response from codec, disabling MSI: last cmd=0x100f0000
[   41.596006] hda-intel: Codec #1 probe error; disabling it...
[   43.012006] hda_intel: azx_get_response timeout, switching to single_cmd mode: last cmd=0x100f0000
[   43.013382] hda-intel: no codecs initialized

Loaded modules on 3.3-rc1:
snd_hda_intel          21137  0 
snd_hda_codec          75176  1 snd_hda_intel
snd_hwdep               5426  1 snd_hda_codec
snd_pcm_oss            31689  0 
snd_mixer_oss          12376  1 snd_pcm_oss
snd_pcm                60828  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           1295  0 
snd_seq_oss            23984  0 
snd_seq_midi            4320  0 
snd_rawmidi            15671  1 snd_seq_midi
snd_seq_midi_event      4788  2 snd_seq_oss,snd_seq_midi
snd_seq                41627  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              15798  2 snd_pcm,snd_seq
snd_seq_device          4504  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    48701  11 snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore               4713  1 snd
snd_page_alloc          5995  2 snd_hda_intel,snd_pcm


Please let me know if you need more information.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SLUGGAN (n.)
A lurid facial bruise which everyone politely omits to mention because
it's obvious that you had a punch-up with your spouse last night - but
which into a door. It is useless to volunteer the true explanation
because nobody will believe it.
			--- Douglas Adams, The Meaning of Liff
