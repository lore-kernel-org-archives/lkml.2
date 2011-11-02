Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1KBKd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:33:29 -0400
Received: from avasout01.plus.net ([84.93.230.227]:52433 "EHLO
	avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1KBKd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:33:28 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 06:33:27 EDT
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.0 cv=W/G6pGqk c=1 sm=1 a=F8hxLa1Qgym6LBeQ3hiSHg==:17
 a=mvLQeQ6CTWEA:10 a=kj9zAlcOel0A:10 a=KxecwjDhI5vF0fzB-BsA:9
 a=CjuIK1q_8ugA:10 a=F8hxLa1Qgym6LBeQ3hiSHg==:117
Date: Wed, 2 Nov 2011 10:25:54 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: HDA Intel microphone regression in 3.1.0
Message-ID: <20111102102554.1f443b9c@laptop.homenet>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Lenovo S12 IdeaPad netbook uses a HDA Intel sound card with Realtek
ALC269 chip.  With the 3.1.0 kernel, all microphone input (both with the
internal microphone and any external microphone) is permanently
muted, although sound output works OK.  Microphone input works correctly
with the 3.0 and earlier kernels.

The only obvious difference between the 3.0 and 3.1 kernels is that
with kernel 3.0.7, 'dmesg | grep HDA' gives this:

 HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
 HDA Intel 0000:00:1b.0: setting latency timer to 64
 input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
 input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
 input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12

whereas with kernel 3.1.0 it just gives:

 input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
 input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
 input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11

lspci -v gives the following audio hardware information:

 00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)
	Subsystem: Lenovo Device 3be9
	Flags: bus master, fast devsel, latency 0, IRQ 22
	Memory at fc140000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

lsmod | egrep "snd|sound" gives:

 snd_seq_dummy           1023  0 
 snd_seq_oss            23792  0 
 snd_seq_midi_event      4408  1 snd_seq_oss
 snd_seq                39673  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
 snd_seq_device          4121  3 snd_seq_dummy,snd_seq_oss,snd_seq
 snd_pcm_oss            33087  0 
 snd_mixer_oss          12647  1 snd_pcm_oss
 snd_hda_codec_realtek   205307  1 
 snd_hda_intel          18347  2 
 snd_hda_codec          64459  2 snd_hda_codec_realtek,snd_hda_intel
 snd_hwdep               4420  1 snd_hda_codec
 snd_pcm                57725  3 snd_pcm_oss,snd_hda_intel,snd_hda_codec
 snd_timer              14567  2 snd_seq,snd_pcm
 snd                    40539  15 snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
 soundcore               4129  1 snd
 snd_page_alloc          5445  2 snd_hda_intel,snd_pcm

Chris
