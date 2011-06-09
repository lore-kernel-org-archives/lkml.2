Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1FIJ2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:28:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1FIJ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:28:33 -0400
Date: Thu, 9 Jun 2011 11:28:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Headphone output doesn't work with 3.0.0-rc* anymore
Message-ID: <20110609092826.GC4207@tiehlicka.suse.cz>
References: <20110607180522.GA4004@tiehlicka.suse.cz>
 <s5hy61cxqcz.wl%tiwai@suse.de>
 <20110608174855.GA4138@tiehlicka.suse.cz>
 <s5hr573y1rl.wl%tiwai@suse.de>
 <20110609085616.GA4207@tiehlicka.suse.cz>
 <20110609090607.GB4207@tiehlicka.suse.cz>
 <s5hei33xsxn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <s5hei33xsxn.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 09-06-11 11:20:04, Takashi Iwai wrote:
> At Thu, 9 Jun 2011 11:06:07 +0200,
> Michal Hocko wrote:
> > 
> > On Thu 09-06-11 10:56:16, Michal Hocko wrote:
> > > On Thu 09-06-11 08:09:18, Takashi Iwai wrote:
> > > > At Wed, 8 Jun 2011 19:48:55 +0200,
> > [...]
> > > > Thanks, that's helpful.
> > > > As a quirk solution, could you try to pass model=auto option to
> > > > snd-hda-intel module?
> > > 
> > > Headphones work now but speakers are quite... I have tried to play
> > > with Headphone and Speaker controls in alsamixer but no changes.
> > > 
> > > Here is what I get in logs when the module is loaded:
> > > [ 5320.360277] HDA Intel 0000:00:1b.0: PCI INT A disabled
> > > [ 5326.920247] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
> > > [ 5326.920262] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
> > > [ 5326.920279] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > > [ 5326.920375] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
> > > [ 5326.920405] HDA Intel 0000:00:1b.0: setting latency timer to 64
> > > [ 5326.981085] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
> > > [ 5326.981262] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
> > > [ 5326.987934] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input20
> > > 
> > > [maybe not important but input numbers are increasing for every new load]
> > > 
> > > There is another strange thing. After I stop mplayer and wait for some
> > > time (~1min) I can hear a "click" sound and then there is no sound at
> > > all... If I start mplayer in the meantime it just works...
> > > If I try to remove the module and load it again then things work and stop
> > > working after first playback again.
> > 
> > And I have just found out that I do not have to start any playback to
> > see this. It is sufficient to load the module and wait a minute and
> > there is no sound at all (both from speakers or headphones).
> 
> OK, could you give alsa-info.sh outputs at both working and
> non-working states?

Sure. Attached. The only change seems to be:
 Node 0x02 [Audio Output] wcaps 0x11: Stereo
   Device: name="ALC262 Analog", type="Audio", device=0
-  Converter: stream=5, channel=0
+  Converter: stream=0, channel=0

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alsa-info.txt-working"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.60
!!################################

!!Script ran on: Thu Jun  9 09:25:11 UTC 2011


!!Linux Distribution
!!------------------

Debian GNU/Linux wheezy/sid \n \l


!!DMI Information
!!---------------

Manufacturer:      FUJITSU SIEMENS
Product Name:      LIFEBOOK S7110
Product Version:    


!!Kernel Information
!!------------------

Kernel release:    3.0.0-rc2
Operating System:  GNU/Linux
Architecture:      i686
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.24
Library version:    1.0.23
Utilities version:  1.0.23


!!Loaded ALSA modules
!!-------------------

snd_hda_intel


!!Sound Servers on this system
!!----------------------------

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xf0640000 irq 42


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 02)
	Subsystem: 10cf:1397


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2
snd-usb-audio: index=-2
snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : auto,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	power_save : 60
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Realtek ALC262
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0262
Subsystem Id: 0x10cf0000
Revision Id: 0x100002
No Modem Function Group found
Default PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x11: Stereo
  Device: name="ALC262 Analog", type="Audio", device=0
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x04 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
Node 0x07 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=0, device=0
  Control: name="Capture Volume", index=0, device=0
  Device: name="ALC262 Analog", type="Audio", device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x24
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=1, device=0
  Control: name="Capture Volume", index=1, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=2, device=0
  Control: name="Capture Volume", index=2, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x22
Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x1f
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Internal Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Internal Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Dock Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=2, ofs=0
  Control: name="Dock Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=2, ofs=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x87 0x87] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 6
     0x18 0x19 0x1a 0x1b 0x1c 0x1d
Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Control: name="Master Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x1c 0x1c]
  Connection: 2
     0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 2
     0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010e: Mono Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00] [0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x00]
  Connection: 2
     0x02 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="PCM Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x03211020: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=01, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Speaker Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x16 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80]
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x03a11040: [Jack] Mic at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x21: IN VREF_50
  Unsolicited: tag=08, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Internal Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x90a70150: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x5, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Dock Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x23a11030: [Jack] Mic at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Headphone Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x2321101f: [Jack] HP Out at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=04, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x593301f0: [N/A] CD at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x9097013f: [Fixed] Aux at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x3, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1e [Pin Complex] wcaps 0x400380: Mono Digital
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x06
Node 0x1f [Pin Complex] wcaps 0x400280: Mono Digital
  Pincap 0x00000020: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=17
Node 0x21 [Volume Knob Widget] wcaps 0x600080: Mono
  Volume-Knob: delta=0, steps=32, direct=0, val=64
  Unsolicited: tag=00, enabled=0
  Connection: 0
Node 0x22 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x24 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Codec: LSI ID 1040
Address: 1
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x11c11040
Subsystem Id: 0x11c10001
Revision Id: 0x100200
Modem Function Group: 0x1
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  4 Jun  9 11:24 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  3 Jun  9 11:24 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  2 Jun  9 11:24 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116, 33 Jun  9 09:49 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jun  9 11:24 .
drwxr-xr-x 3 root root 140 Jun  9 11:24 ..
lrwxrwxrwx 1 root root  12 Jun  9 11:24 pci-0000:00:1b.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xf0640000 irq 42'
  Mixer name	: 'Realtek ALC262'
  Components	: 'HDA:10ec0262,10cf0000,00100002 HDA:11c11040,11c10001,00100200'
  Controls      : 23
  Simple ctrls  : 15
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 28 [90%] [-4.50dB] [on]
  Front Right: Playback 28 [90%] [-4.50dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'Speaker',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 180 [71%] [-15.00dB] [on]
  Front Right: Playback 180 [71%] [-15.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 7 [23%] [-24.00dB] [off]
  Front Right: Playback 7 [23%] [-24.00dB] [off]
Simple mixer control 'Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 3 [100%] [30.00dB]
  Front Right: 3 [100%] [30.00dB]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',2
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Auto-Mute Mode',0
  Capabilities: enum
  Items: 'Disabled' 'Speaker Only' 'Line-Out+Speaker'
  Item0: 'Line-Out+Speaker'
Simple mixer control 'Digital',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 89 [74%] [14.50dB]
  Front Right: Capture 89 [74%] [14.50dB]
Simple mixer control 'Dock Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Dock Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]
Simple mixer control 'Internal Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [on]
  Front Right: Playback 0 [0%] [-34.50dB] [on]
Simple mixer control 'Internal Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'PCM Playback Switch'
		value.0 true
		value.1 true
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Speaker Playback Switch'
		value.0 true
		value.1 true
	}
	control.3 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 true
		value.1 true
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value.0 28
		value.1 28
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Mic Playback Volume'
		value.0 7
		value.1 7
	}
	control.6 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.7 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Internal Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Internal Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Dock Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Dock Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.11 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost Volume'
		value.0 3
		value.1 3
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Internal Mic Boost Volume'
		value.0 0
		value.1 0
	}
	control.13 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Dock Mic Boost Volume'
		value.0 0
		value.1 0
	}
	control.14 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Disabled
		comment.item.1 'Speaker Only'
		comment.item.2 Line-Out+Speaker
		iface MIXER
		name 'Auto-Mute Mode'
		value Line-Out+Speaker
	}
	control.15 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 true
		value.1 true
	}
	control.17 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 2
		value.0 true
		value.1 true
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		value.0 19
		value.1 19
	}
	control.19 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 19
		value.1 19
	}
	control.20 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 2
		value.0 19
		value.1 19
	}
	control.21 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.22 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 180
		value.1 180
	}
	control.23 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 120'
		comment.tlv '0000000100000008fffff44800000032'
		comment.dbmin -3000
		comment.dbmax 3000
		iface MIXER
		name 'Digital Capture Volume'
		value.0 89
		value.1 89
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
snd_hda_intel
snd_hda_codec_realtek
snd_hda_codec
snd_pcm_oss
snd_mixer_oss
snd_pcm
snd_timer
snd
snd_page_alloc
i915
fbcon
font
bitblit
softcursor
drm_kms_helper
drm
fb
fbdev
i2c_algo_bit
cfbcopyarea
i2c_core
cfbimgblt
cfbfillrect
fuse
tun
coretemp
hwmon
arc4
iwl3945
iwl_legacy
mac80211
cfg80211
video
fujitsu_laptop
backlight


!!ALSA/HDA dmesg
!!------------------

[   11.572407] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   11.878181] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.878337] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.878485] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.878748] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[   11.878787] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.982679] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   13.383057] Adding 979928k swap on /dev/sda8.  Priority:-1 extents:1 across:979928k 
--
[  349.712071] CE: hpet increased min_delta_ns to 20113 nsec
[ 2806.556260] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 2828.718010] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 2828.718021] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 2828.718032] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 2828.718103] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 2828.718133] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 2828.772713] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[ 2828.783280] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[ 2828.783602] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[ 3555.888288] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 5222.832079] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5222.832094] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5222.832111] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 5222.832203] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 5222.832244] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 5222.895011] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[ 5222.896312] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[ 5222.896743] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[ 5320.360277] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 5326.920247] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5326.920262] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5326.920279] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 5326.920375] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 5326.920405] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 5326.981085] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[ 5326.981262] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
[ 5326.987934] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input20
[ 5664.124262] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 5667.545458] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5667.545473] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5667.545490] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 5667.545583] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 5667.545624] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 5667.593485] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input21
[ 5667.593659] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input22
[ 5667.596656] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input23
[ 6393.276294] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 6395.132535] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6395.132551] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6395.132568] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 6395.132659] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 6395.132700] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 6395.184481] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input24
[ 6395.184647] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input25
[ 6395.189345] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input26
[ 6765.252274] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 6766.441384] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6766.441400] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6766.441418] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 6766.441509] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 6766.441550] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 6766.488573] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input27
[ 6766.488743] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input28
[ 6766.493011] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input29
[ 7102.896260] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 7104.777024] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7104.777039] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7104.777056] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 7104.777148] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 7104.777189] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 7104.828129] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input30
[ 7104.828230] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input31
[ 7104.828318] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input32
[ 7182.820294] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 7184.142601] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7184.142617] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7184.142634] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 7184.142726] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 7184.142767] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 7184.192086] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input33
[ 7308.828280] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 7310.651575] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7310.651592] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7310.651609] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 7310.651702] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 7310.651743] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 7310.695247] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input34
[ 8550.056277] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 8553.582344] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 8553.582356] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 8553.582370] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 8553.582451] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 8553.582487] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 8554.631958] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input35
[ 8554.632195] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input36
[ 8554.632365] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input37



--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alsa-info.txt-not-working"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.60
!!################################

!!Script ran on: Thu Jun  9 09:26:22 UTC 2011


!!Linux Distribution
!!------------------

Debian GNU/Linux wheezy/sid \n \l


!!DMI Information
!!---------------

Manufacturer:      FUJITSU SIEMENS
Product Name:      LIFEBOOK S7110
Product Version:    


!!Kernel Information
!!------------------

Kernel release:    3.0.0-rc2
Operating System:  GNU/Linux
Architecture:      i686
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.24
Library version:    1.0.23
Utilities version:  1.0.23


!!Loaded ALSA modules
!!-------------------

snd_hda_intel


!!Sound Servers on this system
!!----------------------------

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xf0640000 irq 42


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 02)
	Subsystem: 10cf:1397


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2
snd-usb-audio: index=-2
snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : auto,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	power_save : 60
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Realtek ALC262
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0262
Subsystem Id: 0x10cf0000
Revision Id: 0x100002
No Modem Function Group found
Default PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x11: Stereo
  Device: name="ALC262 Analog", type="Audio", device=0
  Converter: stream=5, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x04 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
Node 0x07 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=0, device=0
  Control: name="Capture Volume", index=0, device=0
  Device: name="ALC262 Analog", type="Audio", device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x24
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=1, device=0
  Control: name="Capture Volume", index=1, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=2, device=0
  Control: name="Capture Volume", index=2, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x22
Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x1f
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Internal Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Internal Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Dock Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=2, ofs=0
  Control: name="Dock Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=2, ofs=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x87 0x87] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 6
     0x18 0x19 0x1a 0x1b 0x1c 0x1d
Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Control: name="Master Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x1c 0x1c]
  Connection: 2
     0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 2
     0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010e: Mono Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00] [0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x00]
  Connection: 2
     0x02 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="PCM Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x03211020: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=01, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Speaker Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x16 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80]
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x03a11040: [Jack] Mic at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x21: IN VREF_50
  Unsolicited: tag=08, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Internal Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x90a70150: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x5, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Dock Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x23a11030: [Jack] Mic at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Headphone Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x2321101f: [Jack] HP Out at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=04, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x593301f0: [N/A] CD at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x9097013f: [Fixed] Aux at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x3, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1e [Pin Complex] wcaps 0x400380: Mono Digital
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x06
Node 0x1f [Pin Complex] wcaps 0x400280: Mono Digital
  Pincap 0x00000020: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=17
Node 0x21 [Volume Knob Widget] wcaps 0x600080: Mono
  Volume-Knob: delta=0, steps=32, direct=0, val=64
  Unsolicited: tag=00, enabled=0
  Connection: 0
Node 0x22 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x24 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Codec: LSI ID 1040
Address: 1
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x11c11040
Subsystem Id: 0x11c10001
Revision Id: 0x100200
Modem Function Group: 0x1
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  4 Jun  9 11:24 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  3 Jun  9 11:24 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  2 Jun  9 11:26 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116, 33 Jun  9 09:49 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jun  9 11:24 .
drwxr-xr-x 3 root root 140 Jun  9 11:24 ..
lrwxrwxrwx 1 root root  12 Jun  9 11:24 pci-0000:00:1b.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xf0640000 irq 42'
  Mixer name	: 'Realtek ALC262'
  Components	: 'HDA:10ec0262,10cf0000,00100002 HDA:11c11040,11c10001,00100200'
  Controls      : 23
  Simple ctrls  : 15
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 28 [90%] [-4.50dB] [on]
  Front Right: Playback 28 [90%] [-4.50dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'Speaker',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 180 [71%] [-15.00dB] [on]
  Front Right: Playback 180 [71%] [-15.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 7 [23%] [-24.00dB] [off]
  Front Right: Playback 7 [23%] [-24.00dB] [off]
Simple mixer control 'Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 3 [100%] [30.00dB]
  Front Right: 3 [100%] [30.00dB]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',2
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Auto-Mute Mode',0
  Capabilities: enum
  Items: 'Disabled' 'Speaker Only' 'Line-Out+Speaker'
  Item0: 'Line-Out+Speaker'
Simple mixer control 'Digital',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 89 [74%] [14.50dB]
  Front Right: Capture 89 [74%] [14.50dB]
Simple mixer control 'Dock Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Dock Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]
Simple mixer control 'Internal Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [on]
  Front Right: Playback 0 [0%] [-34.50dB] [on]
Simple mixer control 'Internal Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'PCM Playback Switch'
		value.0 true
		value.1 true
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Speaker Playback Switch'
		value.0 true
		value.1 true
	}
	control.3 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 true
		value.1 true
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value.0 28
		value.1 28
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Mic Playback Volume'
		value.0 7
		value.1 7
	}
	control.6 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.7 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Internal Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Internal Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Dock Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Dock Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.11 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost Volume'
		value.0 3
		value.1 3
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Internal Mic Boost Volume'
		value.0 0
		value.1 0
	}
	control.13 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Dock Mic Boost Volume'
		value.0 0
		value.1 0
	}
	control.14 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Disabled
		comment.item.1 'Speaker Only'
		comment.item.2 Line-Out+Speaker
		iface MIXER
		name 'Auto-Mute Mode'
		value Line-Out+Speaker
	}
	control.15 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 true
		value.1 true
	}
	control.17 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 2
		value.0 true
		value.1 true
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		value.0 19
		value.1 19
	}
	control.19 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 19
		value.1 19
	}
	control.20 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 2
		value.0 19
		value.1 19
	}
	control.21 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.22 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 180
		value.1 180
	}
	control.23 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 120'
		comment.tlv '0000000100000008fffff44800000032'
		comment.dbmin -3000
		comment.dbmax 3000
		iface MIXER
		name 'Digital Capture Volume'
		value.0 89
		value.1 89
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
snd_hda_intel
snd_hda_codec_realtek
snd_hda_codec
snd_pcm_oss
snd_mixer_oss
snd_pcm
snd_timer
snd
snd_page_alloc
i915
fbcon
font
bitblit
softcursor
drm_kms_helper
drm
fb
fbdev
i2c_algo_bit
cfbcopyarea
i2c_core
cfbimgblt
cfbfillrect
fuse
tun
coretemp
hwmon
arc4
iwl3945
iwl_legacy
mac80211
cfg80211
video
fujitsu_laptop
backlight


!!ALSA/HDA dmesg
!!------------------

[   11.572407] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   11.878181] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.878337] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.878485] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.878748] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[   11.878787] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.982679] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   13.383057] Adding 979928k swap on /dev/sda8.  Priority:-1 extents:1 across:979928k 
--
[  349.712071] CE: hpet increased min_delta_ns to 20113 nsec
[ 2806.556260] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 2828.718010] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 2828.718021] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 2828.718032] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 2828.718103] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 2828.718133] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 2828.772713] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[ 2828.783280] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[ 2828.783602] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[ 3555.888288] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 5222.832079] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5222.832094] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5222.832111] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 5222.832203] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 5222.832244] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 5222.895011] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[ 5222.896312] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[ 5222.896743] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[ 5320.360277] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 5326.920247] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5326.920262] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5326.920279] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 5326.920375] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 5326.920405] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 5326.981085] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[ 5326.981262] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
[ 5326.987934] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input20
[ 5664.124262] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 5667.545458] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5667.545473] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 5667.545490] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 5667.545583] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 5667.545624] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 5667.593485] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input21
[ 5667.593659] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input22
[ 5667.596656] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input23
[ 6393.276294] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 6395.132535] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6395.132551] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6395.132568] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 6395.132659] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 6395.132700] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 6395.184481] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input24
[ 6395.184647] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input25
[ 6395.189345] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input26
[ 6765.252274] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 6766.441384] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6766.441400] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 6766.441418] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 6766.441509] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 6766.441550] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 6766.488573] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input27
[ 6766.488743] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input28
[ 6766.493011] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input29
[ 7102.896260] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 7104.777024] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7104.777039] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7104.777056] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 7104.777148] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 7104.777189] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 7104.828129] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input30
[ 7104.828230] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input31
[ 7104.828318] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input32
[ 7182.820294] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 7184.142601] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7184.142617] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7184.142634] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 7184.142726] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 7184.142767] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 7184.192086] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input33
[ 7308.828280] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 7310.651575] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7310.651592] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 7310.651609] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 7310.651702] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 7310.651743] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 7310.695247] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input34
[ 8550.056277] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 8553.582344] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 8553.582356] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 8553.582370] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 8553.582451] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[ 8553.582487] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 8554.631958] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input35
[ 8554.632195] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input36
[ 8554.632365] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input37



--qDbXVdCdHGoSgWSk--
