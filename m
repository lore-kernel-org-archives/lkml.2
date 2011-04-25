Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab1DYMgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 08:36:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50973 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab1DYMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 08:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=A4BDgzxYyN4xtHEUU6u28m0Ho/Hhhd52+Y+MlKdUvChIKpQoq5uSbQmgCRwrRcfSZk
         5PEIWl+oR0XMEzggpEkpzCV9H5hmLU4R2pfO7S+I4FhyKuLWtnstTUEqlBSa+1gK8394
         dpgwsEtPuqsxbiNHdO/uxGhuYrJGWVJIDBKgE=
MIME-Version: 1.0
Date: Mon, 25 Apr 2011 14:36:15 +0200
Message-ID: <BANLkTinSOZH=9uD_9uXcVnH-1Yw5K-K3yg@mail.gmail.com>
Subject: yenta cardbus problem
From: =?ISO-8859-1?Q?Germ=E1n_Sanchis?= <eaglecros@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In my old laptop I had a PCMCIA Creative SoundBlaster Audigy2 ZS
notebook card in order to get my external speakers working. When I
bought a new laptop, I found out that my old PCMCIA card did not fit
in any hole any more... damn! So, I decided to buy a PCMCIA to
ExpressCard adapter. Specifically, I bought DuelAdapter, but I don't
seem to be able to get it working. It does work properly in the Vista
installation my laptop has since I bought it, so a hardware problem is
out of question. I have been doing quite a lot of googleing, but I am
puzzled and don't know what the issue might be. Here a couple of
things which I think could be related.

lspci reports:
""
...
05:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI
Express-to-PCI Bridge (rev 03)
06:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
""

(no sound card!)

Note that the adapter has a switch, which is intended to be in
"position A" for MacOS, and in "position B" for Windows XP (although
my Vista system recognised it perfectly in position A). Under linux,
lspci reports the above devices with the switch in A position, and in
B the devices do not show up.

When googling, I read that the "pci=assign-busses" kernel option could
be the solution, but that didn't help either, and in fact specifying
such option results in the devices above not being listed by lspci.
Here more lspci info:

""
$ lspci -v | grep subordinate
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Bus: primary=00, secondary=04, subordinate=09, sec-latency=0
        Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
        Bus: primary=00, secondary=00, subordinate=00, sec-latency=0
""

In addition, yenta seems not to be very happy with the setup:

""
$ dmesg | grep yenta
[   21.098659] yenta_cardbus 0000:05:00.0: No cardbus resource!
""

And I have been unable to find anybody reporting such error in
google... only pages where this error is listed along with the kernel
code, and a couple of pages which do not seem to be related.

I also tried installing the sound card modules by hand via
/etc/modules and rebooting, but that doesn't help either, although the
modules get loaded correctly:

""
$ lsmod | grep yenta
yenta_socket           22901  0
rsrc_nonstatic          9830  1 yenta_socket
pcmcia_core            38176  2 yenta_socket,rsrc_nonstatic

$ lsmod | grep emu10k
snd_emu10k1_synth       6036  0
snd_emux_synth         37367  1 snd_emu10k1_synth
snd_emu10k1           148561  1 snd_emu10k1_synth
snd_ac97_codec        125394  1 snd_emu10k1
snd_pcm                87882  5
snd_emu10k1,snd_hda_intel,snd_hda_codec,snd_ac97_codec,snd_pcm_oss
snd_rawmidi            23420  3 snd_seq_virmidi,snd_emu10k1,snd_seq_midi
snd_util_mem            3818  2 snd_emux_synth,snd_emu10k1
snd_hwdep               6924  3 snd_emux_synth,snd_emu10k1,snd_hda_codec
snd_timer              23649  3 snd_emu10k1,snd_pcm,snd_seq
snd_seq_device          6888  8
snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    71187  20
snd_emux_synth,snd_seq_virmidi,snd_hda_codec_idt,snd_emu10k1,snd_hda_intel,snd_hda_codec,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_pcm,snd_rawmidi,snd_seq,snd_hwdep,snd_timer,snd_seq_device
snd_page_alloc          8500  3 snd_emu10k1,snd_hda_intel,snd_pcm
""

I would have thought that, simply, the adapter is not supported, but
then I also came accross
the following site:
http://fr.audiofanzine.com/carte-son-pcmcia/e-mu/1616M/forums/t.280979,emu-1616m-adaptateur-pcmcia-expresscard-linux.html

Although in french, the author reports that he got a similar sound
card working a PCMCIA-ExpressCard adapter wich reports the same chip
in lspci (the Texas Instruments XIO2000(A)/XIO2200(A) PCI
Express-to-PCI Bridge).

I am running Ubuntu 10.10 with a 2.6.35-28-generic kernel, on a x86_64
machine (an HP dv3000 series laptop).

Any ideas or hints towards where to get any help? ANY help at all is
appreciated, since I have run out of resources towards solving this
problem!! And if you need any further info, please do ask me!

Thanks!!

P.S.: I already posted this problem on the ubuntu forums in
http://ubuntuforums.org/showthread.php?t=1587221
but got no answer, which is why I am finally posting this here. Please
excuse me in the case this is not a kernel-related issue, and, since I
am not subscribed to the kernel-mailing list, please CC me in case of
an answer.
