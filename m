Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0FGMtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:49:19 -0400
Received: from borg.medozas.de ([188.40.89.202]:41265 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0FGMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:49:18 -0400
Date: Mon, 7 Jun 2010 14:49:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
In-Reply-To: <4BFE66CA.5070400@ladisch.de>
Message-ID: <alpine.LSU.2.01.1006071404210.11780@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr> <s5hmxvmzwwd.wl%tiwai@suse.de> <alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr> <4BFD2901.20800@ladisch.de> <alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr> <4BFE5AA1.7070103@ladisch.de>
 <4BFE66CA.5070400@ladisch.de>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2010-05-27 14:34, Clemens Ladisch wrote:
>Clemens Ladisch wrote:
>> Please do not assume that the "HDMI" device is the right one, since you
>> never got either one to work in Linux.
>
>Hmm, that computer is separate from the actual LCD, which has an HDMI
>input, so it's possible that the HDMI output would be correct.
>
>In that case, it's likely that you've run into this bug:
>https://bugs.freedesktop.org/show_bug.cgi?id=28030
>
>You might try the patch mentioned there, or radeonhd, or fglrx.

Cc'ing drm.

I conclude further tests.

* Linux 2.6.35-rc2
- fbcon:radeondrmfb using "modprobe radeon modeset=1"
  - sound ok
- Xorg (7.4) with 'radeonhd'
  - fbcon ok, no sound in Xorg - I figure radeonhd is obsolete
- Xorg with 'radeon'
  - fbcon ok, xorg ok.
    There is a small breakdown when switching between fbcon and xorg

* Linux 2.6.33.5
- like 2.6.35-rc2, but had a bug that prevented radeon.ko to go into 
  graphics mode when initially loaded; workaround: modprobe fglrx;
  rmmod fglrx; modprobe radeon modeset=1
- or fglrx, also makes sound work

- fglrx bug aside: switching from Xorg to console (either 80x25 or
  radeondrmfb) makes a fugly "pop" noise, and if the target is
  radeomdrmfb, display is garbled.


So I'm happy.
Conclusive questions however:

* Why is it that I am only allowed to have sound in graphics mode?

* The radeon.ko module does not have any PCI IDs defined, thus does not 
get autoloaded like i915.ko. Is this intentional? It also seems
to default to modeset=0.
