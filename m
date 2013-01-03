Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3ACNke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:40:34 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:46442 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3ACNkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:40:31 -0500
Message-ID: <1357220382.3737.5.camel@lamella>
Subject: Re: [3.6.9 -> 3.7.1 regression] sound: snd_hda_intel codec probing
 issue?
From: Vincent Blut <vincent.debian@free.fr>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Jan 2013 14:39:42 +0100
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

Hi,

That makes sense, however I can't reliably reproduce this so I'll report
back later.

Thanks and happy new year!

Vincent

