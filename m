Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2AXKen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:34:43 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1484 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab2AXKel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:34:41 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4F1E8931.8070605@broadcom.com>
Date: Tue, 24 Jan 2012 11:34:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.3.0-rc1 kernel becomes unresponsive
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 630054EE3DS18726827-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I moved my development work to 3.3.0-rc1 from wireless-testing
repository. After loading the brcmfmac driver (12 sec.) I suddenly see
the BUG message 'scheduling while atomic' and it fills up the entire log
with the machine becoming totally unresponsive.

Any suggestions on where to start looking. What type of problems could
cause this?

Gr. AvS
----------------------------------------------------------------------------------------

Jan 24 04:53:07 lb-bun-10 kernel: [63122.211870] usbcore: registered new
interface driver brcmfmac
Jan 24 04:53:08 lb-bun-10 kernel: [63122.300516] udev[7158]: renamed
network interface wlan0 to wlan1
Jan 24 04:53:08 lb-bun-10 kernel: [63122.325482] ERROR @brcmf_run_iscan
: error (-3)
Jan 24 04:53:09 lb-bun-10 kernel: [63123.695387] cfg80211: Found new
beacon on frequency: 5745 MHz (Ch 149) on
 phy0
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106731] BUG: scheduling while
atomic: swapper/0/0/0x10000100
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106737] Modules linked in:
brcmfmac(O) brcmutil(O) cfg80211(O) sdhci_pci sdhci mmc_core aes_generic
arc4 binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel
snd_hda_codec intel_agp nouveau snd_hwdep snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
soundcore snd_page_alloc dell_laptop psmouse intel_gtt dell_wmi ttm
drm_kms_helper drm serio_raw intel_ips mxm_wmi dcdbas agpgart
sparse_keymap video firewire_ohci ahci libahci firewire_core crc_itu_t
e1000e [last unloaded: mmc_core]
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106794] Modules linked in:
brcmfmac(O) brcmutil(O) cfg80211(O) sdhci_pci sdhci mmc_core aes_generic
arc4 binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel
snd_hda_codec intel_agp nouveau snd_hwdep snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
soundcore snd_page_alloc dell_laptop psmouse intel_gtt dell_wmi ttm
drm_kms_helper drm serio_raw intel_ips mxm_wmi dcdbas agpgart
sparse_keymap video firewire_ohci ahci libahci firewire_core crc_itu_t
e1000e [last unloaded: mmc_core]
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106840]
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106845] Pid: 0, comm: swapper/0
Tainted: G           O 3.3.0-rc1-wl-testing #2 Dell Inc. Latitude
E6410/07XJP9
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106853] EIP: 0060:[<c12be284>]
EFLAGS: 00000202 CPU: 0
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106863] EIP is at
intel_idle+0xb4/0x110
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106867] EAX: 00000000 EBX:
000018ec ECX: 00000000 EDX: 000018ec
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106870] ESI: 00000000 EDI:
00000008 EBP: c169df70 ESP: c169df54
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106874]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106878] Process swapper/0 (pid:
0, ti=f500c000 task=c16a1de0 task.ti=
c169c000)
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106882] Stack:
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106884]  00000020 f5409e5c
00000003 00000000 000000cc c16d2000 f5409e
5c c169df94
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106892]  c13beb8b 00000000
00000000 00000003 c169f000 c16f1010 000000
00 c169f000
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106900]  c169dfb4 c1001d84
0dc4807d 0000000f 39547204 0c134087 c172d0
60 0008d800
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106909] Call Trace:
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106919]  [<c13beb8b>]
cpuidle_idle_call+0xab/0x1d0
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106926]  [<c1001d84>]
cpu_idle+0xa4/0xf0
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106933]  [<c149d2cd>]
rest_init+0x5d/0x70
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106942]  [<c16f5853>]
start_kernel+0x38a/0x390
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106947]  [<c16f52f3>] ?
kernel_init+0x145/0x145
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106953]  [<c16f5075>]
i386_start_kernel+0x75/0x79
Jan 24 04:53:20 lb-bun-10 kernel: [63135.106955] Code: f6 89 e0 25 00 e0
ff ff 8b 40 08 a8 08 75 08 b1 01 8b 4
5 e4 0f 01 c9 e8 7b 85 db ff 29 d8 19 f2 e8 d2 86 d7 ff 89 c6 89 d3 fb
90 <8d> 74 26 00 85 3d a0 28 6d c1 75 0
d 8d 55 f0 b8 05 00 00 00 e8
Jan 24 04:53:20 lb-bun-10 kernel: [63135.107009] Call Trace:
Jan 24 04:53:20 lb-bun-10 kernel: [63135.107014]  [<c13beb8b>]
cpuidle_idle_call+0xab/0x1d0
Jan 24 04:53:20 lb-bun-10 kernel: [63135.107018]  [<c1001d84>]
cpu_idle+0xa4/0xf0
Jan 24 04:53:20 lb-bun-10 kernel: [63135.107023]  [<c149d2cd>]
rest_init+0x5d/0x70
Jan 24 04:53:20 lb-bun-10 kernel: [63135.107028]  [<c16f5853>]
start_kernel+0x38a/0x390
Jan 24 04:53:20 lb-bun-10 kernel: [63135.107033]  [<c16f52f3>] ?
kernel_init+0x145/0x145
Jan 24 04:53:20 lb-bun-10 kernel: [63135.107038]  [<c16f5075>]
i386_start_kernel+0x75/0x79

