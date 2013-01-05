Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3AEVYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 16:24:25 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:37719 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab3AEVYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 16:24:22 -0500
Message-ID: <1357421043.3912.13.camel@lamella>
Subject: Re: [3.6.9 -> 3.7.1 regression] sound: snd_hda_intel codec probing
 issue?
From: Vincent Blut <vincent.debian@free.fr>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sat, 05 Jan 2013 22:24:03 +0100
In-Reply-To: <s5hvcber5cz.wl%tiwai@suse.de>
References: <1356704740.3953.26.camel@lamella>
	 <s5hvcber5cz.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 janvier 2013 à 10:19 +0100, Takashi Iwai a écrit :
> At Fri, 28 Dec 2012 15:25:40 +0100,
> Vincent Blut wrote:
> > 
> > Hi,
> > 
> > Since I updated to Linux 3.7.1, listening to some audio/video bits
> > frequently cause the following:
> > 
> > [ 7896.166946] hda-intel: azx_get_response timeout, switching to polling
> > mode: last cmd=0x020c0000
> > [ 7897.173444] hda-intel: No response from codec, disabling MSI: last
> > cmd=0x020c0000
> > [ 7898.179932] hda_intel: azx_get_response timeout, switching to
> > single_cmd mode: last cmd=0x020c0000
> > [ 7898.179983] hda-codec: out of range cmd 0:0:20:400:fffff7ff
> > [ 9445.034371] plugin-containe[5873]: segfault at 7f44bb95e639 ip
> > 00007f44e454bca0 sp 00007f44c91165f8 error 4 in
> > libc-2.13.so[7f44e442c000+180000]
> > 
> > It seems to be a codec probing failure (?). This is really fatal because
> > the sound become very choppy and can't recover until I reboot.
> > I'll try to play with 'probe_mask' kernel parameter to see if I can
> > narrow the correct codec slots!
> > 
> > By the way I can't reproduce this on 3.6.9, so is there something that
> > changed in this area in 3.7.1?
> 
> If it's new in 3.7, this could be a regression by runtime D3.
> Try to pass power_save_controller=0 option to snd-hda-intel module
> (or change it via sysfs dynamically).
> 
> 
> thanks,
> 
> Takashi

Hi Takashi,

Well, power_save_controller=0 seems to do the trick but I get plenty of:


[   15.389270] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[   25.178725] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[   72.296536] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[ 2318.147505] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[ 6086.029839] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[ 7390.772818] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11


which I think is fixed in 3.8 by commit 6eb827d23577

So what's the next step? Adding a quirk for this sound card? Or is there
a way to fix the root cause? 

Cheers,
Vincent

