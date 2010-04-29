Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166Ab0D3Sr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:47:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:41530 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758662Ab0D3Srj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:47:39 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19qBaRIycpqPU9aryVRkW1jxL9XjJ2NYxI0f8I0qR
	NB9USTKL6ncbFv
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ALSA: hda/realtek: quirk for D945GCLF2 mainboard
Date: Thu, 29 Apr 2010 23:00:42 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5-sidux-686; KDE/4.4.2; i686; ; )
MIME-Version: 1.0
Cc: David Santinoli <david@santinoli.com>, Takashi Iwai <tiwai@suse.de>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004292300.45564.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Since kernel 2.6.33 (and including 2.6.34-rc5-git10), sound output is 
broken on my Intel D945GCLF2 mainboard, while it did work well on earlier
kernels up to and including 2.6.32.12.

$ cat /sys/devices/virtual/dmi/id/board_vendor 
Intel Corporation
$ cat /sys/devices/virtual/dmi/id/board_name
D945GCLF2
$ cat /sys/devices/virtual/dmi/id/bios_vendor 
Intel Corp.
$ cat /sys/devices/virtual/dmi/id/bios_version 
LF94510J.86A.0229.2009.0729.0209
$ cat /sys/devices/virtual/dmi/id/bios_date 
07/29/2009

00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 01)
        Subsystem: Intel Corporation Device [8086:d604]
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 882a0000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 4199
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=80
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=0f ComponentID=00 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed1c000

[    9.343858] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    9.343980]   alloc irq_desc for 22 on node -1
[    9.343989]   alloc kstat_irqs on node -1
[    9.344009] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    9.344093]   alloc irq_desc for 28 on node -1
[    9.344097]   alloc kstat_irqs on node -1
[    9.344115] HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
[    9.344202] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.352069] hda-intel: spurious response 0x0:0x0, last cmd=0x000000
[    9.352224] hda-intel: spurious response 0x0:0x1, last cmd=0x000000
[    9.352351] hda-intel: spurious response 0x0:0x2, last cmd=0x200f0000
[   10.353265] hda-intel: spurious response 0x0:0x0, last cmd=0x000000
[   10.353386] hda-intel: spurious response 0x0:0x1, last cmd=0x000000
[...]
[   12.569270] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x200f0001
[   12.569281] hda-intel: spurious response 0x0:0x0, last cmd=0x000000
[   12.570258] hda-intel: spurious response 0x0:0x2, last cmd=0x200f0001
[   12.570258] hda-intel: spurious response 0x0:0x0, last cmd=0x000000
[...]
[   12.901144] hda-intel: spurious response 0x0:0x2, last cmd=0x200f0004
[   12.901968] hda-intel: no codecs initialized
[   12.902173] HDA Intel 0000:00:1b.0: PCI INT A disabled

$ cat /proc/asound/cards 
--- no soundcards ---

Experimenting with different module parameters for snd-hda-intel don't seem
to be successful, neither enable_msi=0, different model= or probe_mask= 
settings seem to have any effect.

Reverting just "ALSA: hda/realtek: quirk for D945GCLF2 mainboard" however 
fixes my problem on 2.6.33 and 2.6.34-rc5-git10.

On Thursday 29 April 2010, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/7aee67466536bbf8bb44a95712c848a61c5a0acd
> Commit:     7aee67466536bbf8bb44a95712c848a61c5a0acd
> Parent:     396087eaead95fcb29eb36f1e59517aeb58c545e
> Author:     David Santinoli <david@santinoli.com>
> AuthorDate: Wed, 9 Dec 2009 11:34:26 +0000 (12:34 +0100)
> Committer:  Takashi Iwai <tiwai@suse.de>
> CommitDate: Wed, 9 Dec 2009 11:34:26 +0000 (12:34 +0100)
> 
>     ALSA: hda/realtek: quirk for D945GCLF2 mainboard
>     
>     Quirk for the ALC662 found on the Intel D945GCLF2 (and possibly other)
>     mainboards.
>     
>     Signed-off-by: David Santinoli <david@santinoli.com>
>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_realtek.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index 2a96bc7..deecdd2 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -16970,6 +16970,7 @@ static struct snd_pci_quirk alc662_cfg_tbl[] = {
>  					ALC662_3ST_6ch_DIG),
>  	SND_PCI_QUIRK_MASK(0x1854, 0xf000, 0x2000, "ASUS H13-200x",
>  			   ALC663_ASUS_H13),
> +	SND_PCI_QUIRK(0x8086, 0xd604, "Intel mobo", ALC662_3ST_2ch_DIG),
>  	{}
>  };
>  

[    9.426165] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    9.426283]   alloc irq_desc for 22 on node -1
[    9.426295]   alloc kstat_irqs on node -1
[    9.426320] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    9.426414]   alloc irq_desc for 28 on node -1
[    9.426420]   alloc kstat_irqs on node -1
[    9.426443] HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
[    9.426517] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.438140] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x200f0002

$ cat /proc/asound/cards 
 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0x882a0000 irq 28
$ cat /proc/asound/hwdep 
00-02: HDA Codec 2
$ cat /proc/asound/modules 
 0 snd_hda_intel
$ cat /proc/asound/timers 
G0: system timer : 1000.000us (10000000 ticks)
P0-0-0: PCM playback 0-0-0 : SLAVE
P0-0-1: PCM capture 0-0-1 : SLAVE
P0-1-0: PCM playback 0-1-0 : SLAVE
P0-1-1: PCM capture 0-1-1 : SLAVE
$ cat /proc/asound/card0/codec#2 
Codec: Realtek ALC662 rev1
Address: 2
Function Id: 0x1
Vendor Id: 0x10ec0662
Subsystem Id: 0x8086d604
Revision Id: 0x100101
No Modem Function Group found
Default PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x1d: Stereo Amp-Out
  Control: name="Front Playback Volume", index=0, device=0
  Device: name="ALC662 rev1 Analog", type="Audio", device=0
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x40 0x40]
  Converter: stream=0, channel=0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x1d: Stereo Amp-Out
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x40 0x40]
  Converter: stream=0, channel=0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x04 [Audio Output] wcaps 0x1d: Stereo Amp-Out
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x40 0x40]
  Converter: stream=0, channel=0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
  Device: name="ALC662 rev1 Digital", type="SPDIF", device=1
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x89 0x89]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Device: name="ALC662 rev1 Analog", type="Audio", device=0
  Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x80 0x80]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x22
Node 0x0a [Vendor Defined Widget] wcaps 0xf00000: Mono
  Control: name="IEC958 Capture Switch", index=0, device=0
  Control: name="IEC958 Capture Default", index=0, device=0
  Device: name="ALC662 rev1 Digital", type="SPDIF", device=1
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="CD Playback Volume", index=0, device=0
  Control: name="CD Playback Switch", index=0, device=0
  Control: name="Line Playback Volume", index=0, device=0
  Control: name="Line Playback Switch", index=0, device=0
  Control: name="Mic Playback Volume", index=0, device=0
  Control: name="Mic Playback Switch", index=0, device=0
  Control: name="Front Mic Playback Volume", index=0, device=0
  Control: name="Front Mic Playback Switch", index=0, device=0
  Control: name="Beep Playback Volume", index=0, device=0
  Control: name="Beep Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x17 0x17] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16
Node 0x0c [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="Front Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x04 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0001003c: IN OUT HP EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x01014410: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0c
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00010034: IN OUT EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0d
Node 0x16 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000034: IN OUT Detect
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00001734: IN OUT Detect
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x01a19840: [Jack] Mic at Ext Rear
    Conn = 1/8, Color = Pink
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0e
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x02a19841: [Jack] Mic at Ext Front
    Conn = 1/8, Color = Pink
    DefAssociation = 0x4, Sequence = 0x1
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0e
Node 0x1a [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00000034: IN OUT Detect
  Pin Default 0x0181304f: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = Blue
    DefAssociation = 0x4, Sequence = 0xf
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Headphone Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000173c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x02214420: [Jack] HP Out at Ext Front
    Conn = 1/8, Color = Green
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0e
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x4015c603: [N/A] Speaker at Ext N/A
    Conn = Optical, Color = UNKNOWN
    DefAssociation = 0x0, Sequence = 0x3
  Pin-ctls: 0x20: IN
Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
  Pincap 0x00000010: OUT
  Pin Default 0x99430130: [Fixed] SPDIF Out at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0x3, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x06
Node 0x1f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=12
  Processing Coefficient: 0x00
  Coefficient Index: 0x06
Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 10
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 10
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x24 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x25 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x26 [Vendor Defined Widget] wcaps 0xf00000: Mono

Regards
	Stefan Lippers-Hollmann
-- 

Revert "ALSA: hda/realtek: quirk for D945GCLF2 mainboard"

This reverts the following commit:
7aee67466536bbf8bb44a95712c848a61c5a0acd

As it doesn't seem to be universally valid for all mainboard revisions of 
the D945GCLF2 and breaks snd-hda-intel/ snd-hda-codec-realtek on the Intel 
Corporation "D945GCLF2" (LF94510J.86A.0229.2009.0729.0209) mainboard.

00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 01)

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: stable@kernel.org [2.6.33]
---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -17871,7 +17871,6 @@ static struct snd_pci_quirk alc662_cfg_t
 					ALC662_3ST_6ch_DIG),
 	SND_PCI_QUIRK_MASK(0x1854, 0xf000, 0x2000, "ASUS H13-200x",
 			   ALC663_ASUS_H13),
-	SND_PCI_QUIRK(0x8086, 0xd604, "Intel mobo", ALC662_3ST_2ch_DIG),
 	{}
 };
 
