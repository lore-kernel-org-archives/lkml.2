Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1KNVwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:52:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42999 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab1KNVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:52:28 -0500
Message-ID: <4EC18D9E.5070108@gmail.com>
Date: Mon, 14 Nov 2011 22:52:30 +0100
From: Natanji <natanji@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Regression in thinkpad-acpi events
References: <4EBAC3B5.5060405@gmail.com> <201111142031.06663.maciej.rutecki@gmail.com> <4EC16F8E.7060601@gmail.com> <20111114203021.GC31918@khazad-dum.debian.net>
In-Reply-To: <20111114203021.GC31918@khazad-dum.debian.net>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thinkpad-acpi is definitely loaded:
$ lsmod | grep think
thinkpad_acpi          54704  0
snd                    43817  11
snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,thinkpad_acpi,snd_timer
rfkill                 12470  3 bluetooth,thinkpad_acpi,cfg80211
nvram                   4765  1 thinkpad_acpi

I also noticed that removing or replacing the tablet pen in its slot
still yields an ibm/hotkey acpi event. This is the output of $
acpi_listen when I do this:
ibm/hotkey IBM0068:00 00000080 0000500c
processor LNXCPU:00 00000081 00000000
processor LNXCPU:01 00000081 00000000
ibm/hotkey IBM0068:00 00000080 0000500b
processor LNXCPU:00 00000081 00000000
processor LNXCPU:01 00000081 00000000

thinkpad-acpi also shows up in kernel log:
# cat /var/log/kernel.log | grep thinkpad_acpi
Nov 14 10:00:13 localhost kernel: [   14.207399] thinkpad_acpi: ThinkPad
ACPI Extras v0.24
Nov 14 10:00:13 localhost kernel: [   14.207403] thinkpad_acpi:
http://ibm-acpi.sf.net/
Nov 14 10:00:13 localhost kernel: [   14.207406] thinkpad_acpi: ThinkPad
BIOS 7JET30WW (1.15 ), EC 7JHT13WW-1.04
Nov 14 10:00:13 localhost kernel: [   14.207409] thinkpad_acpi: Lenovo
ThinkPad X60 Tablet, model 6363WDK
Nov 14 10:00:13 localhost kernel: [   14.224471] thinkpad_acpi: detected
a 8-level brightness capable ThinkPad
Nov 14 10:00:13 localhost kernel: [   14.231577] thinkpad_acpi: ACPI
backlight control delay disabled
Nov 14 10:00:13 localhost kernel: [   14.232156] thinkpad_acpi: radio
switch found; radios are enabled
Nov 14 10:00:13 localhost kernel: [   14.232897] thinkpad_acpi: possible
tablet mode switch found; ThinkPad in laptop mode
Nov 14 10:00:13 localhost kernel: [   14.257007] thinkpad_acpi: rfkill
switch tpacpi_bluetooth_sw: radio is blocked
Nov 14 10:00:13 localhost kernel: [   14.263972] thinkpad_acpi: Standard
ACPI backlight interface available, not loading native one
Nov 14 10:00:13 localhost kernel: [   14.264099] thinkpad_acpi: Console
audio control enabled, mode: monitor (read only)
Nov 14 10:00:13 localhost kernel: [   14.265628] input: ThinkPad Extra
Buttons as /devices/platform/thinkpad_acpi/input/input5
Nov 14 10:00:16 localhost kernel: [   19.996929] thinkpad_acpi:
deprecated sysfs attribute: access by process with PID 1076
Nov 14 10:00:16 localhost kernel: [   19.996934] thinkpad_acpi: WARNING:
sysfs attribute bluetooth_enable is deprecated and will be removed.
Please switch to generic rfkill before year 2010
Nov 14 12:58:34 localhost kernel: [ 5453.928107] thinkpad_acpi: ACPI
backlight control delay disabled
Nov 14 19:30:16 localhost kernel: [23290.557775] Modules linked in: fuse
hidp hid cpufreq_ondemand ext3 jbd ecb btusb bluetooth pcmcia arc4
snd_hda_codec_analog iwlagn sdhci_pci firewire_ohci sdhci mmc_core
firewire_core yenta_socket pcmcia_rsrc pcmcia_core uhci_hcd mac80211
crc_itu_t snd_hda_intel ehci_hcd snd_hda_codec psmouse thinkpad_acpi
snd_hwdep cfg80211 e1000e serio_raw iTCO_wdt snd_pcm iTCO_vendor_support
snd_timer i2c_i801 snd usbcore snd_page_alloc soundcore rfkill ac nvram
battery evdev thermal ipv6 acpi_cpufreq freq_table processor mperf ext4
mbcache jbd2 crc16 cryptd aes_i586 aes_generic xts gf128mul dm_crypt
dm_mod ata_piix sd_mod ahci libahci libata scsi_mod i915 drm_kms_helper
drm i2c_algo_bit button i2c_core video intel_agp intel_gtt agpgart
Nov 14 19:30:16 localhost kernel: [23292.952019] thinkpad_acpi: ACPI
backlight control delay disabled

So I suppose it is loaded alright, but just some of the events don't
work anymore at all (like for my physical rfkill switch) and/or get
overridden by other "standard" events (like with the sleep button).

On 11/14/2011 09:30 PM, Henrique de Moraes Holschuh wrote:
> On Mon, 14 Nov 2011, Natanji wrote:
>> With 3.0 it was still fine, that much is for sure. The problem came 
>> with the upgrade to 3.1. I've never even compiled my own kernel so I 
>> cannot bisect. Sorry...
> 
> Well, please keep me in the CC.  I'm the thinkpad-acpi maintainer.
> 
>>>> This can be observed by using the acpi_listen command. For instance, no
>>>> ACPI events happen when swiveling the display, and the sleep button returns
>>>> 	button/sleep SBTN 00000080 00000000
>>>> instead of the previous
>>>> 	ibm/hotkey HKEY 00000080 00001004
> 
> That usually happens when you don't have thinkpad-acpi loaded at all.
> 
> Does lsmod report that thinkpad-acpi is loaded?  Are there any messages from
> thinkpad-acpi in the kernel log?
> 
