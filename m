Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0GLRD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:03:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24971 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0GLRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:03:57 -0400
Date: Mon, 12 Jul 2010 10:03:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Modpost error after changing CONFIG_SOUND from m to y
Message-Id: <20100712100301.db1d3980.randy.dunlap@oracle.com>
In-Reply-To: <201007120554.16459.vda.linux@googlemail.com>
References: <201007120554.16459.vda.linux@googlemail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3B4AFA.022C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 05:54:16 +0200 Denys Vlasenko wrote:

> Hi,
> 
> I was using the same .config for my home machine for a long time,
> updating it using "make oldconfig" every time I moved to newer kernel.
> It worked fine for many kernels.
> 
> In this .config I had CONFIG_SOUND=m.
> 
> Starting witn 2.6.34, build fails with
> 
> sound/core/sound_oss.c:25:2: error: #error "Enable the OSS soundcore multiplexer (CONFIG_SOUND) in the kernel."
> 
> Ok. I changed CONFIG_SOUND to y. Now the build fails at modpost:

Hi,
I can't get the build to fail (2.6.34 or 2.6.35-rc4-git4).
Please provide a full/complete .config file (and that will include a
kernel version number :).


> Kernel: arch/x86/boot/bzImage is ready  (#3)
>   Building modules, stage 2.
>   MODPOST 609 modules
> ERROR: "snd_hda_build_controls" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_resume" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_suspend" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_codec_configure" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_calc_stream_format" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_queue_unsol_event" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_bus_reboot_notify" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_codec_new" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_build_pcms" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_bus_new" [sound/pci/hda/snd-hda-intel.ko] undefined!
> ERROR: "snd_hda_multi_out_dig_prepare" [sound/pci/hda/snd-hda-codec-via.ko] undefined!
> ERROR: "snd_hda_input_mux_info" [sound/pci/hda/snd-hda-codec-via.ko] undefined!
> 
> ... lots and lots of similar messages...
> 
> ERROR: "snd_hda_set_vmaster_tlv" [sound/pci/hda/snd-hda-codec-analog.ko] undefined!
> ERROR: "snd_hda_bind_vol" [sound/pci/hda/snd-hda-codec-analog.ko] undefined!
> ERROR: "snd_hda_codec_read" [sound/pci/hda/snd-hda-codec-analog.ko] undefined!
> ERROR: "snd_hda_codec_amp_read" [sound/pci/hda/snd-hda-codec-analog.ko] undefined!
> ERROR: "snd_hda_add_new_ctls" [sound/pci/hda/snd-hda-codec-analog.ko] undefined!
> ERROR: "snd_hda_codec_amp_update" [sound/pci/hda/snd-hda-codec-analog.ko] undefined!
> ERROR: "snd_hda_shutup_pins" [sound/pci/hda/snd-hda-codec-analog.ko] undefined!
> WARNING: modpost: Found 4 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> I tried switching some other things to y but the error
> proves pretty resilient...
> 
> Result of "grep ^CONFIG .config" is below:

[snip]

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
