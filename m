Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0FGPD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:03:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0FGPD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u4hvpTMOapFGYSgHBcfYdsas60FDeUkMZdSyLDVzJiv847XCgbolmZXY2v4EcFORrv
         7+rpOWAPhu6ZWeq1gkG9jAJegTrFK9vpmYpPT5VJck8RPTv4lhFywsHNdxtjC9x4cUkE
         b/YLdPn2KOxY0GmA8uxzubmFxAzQK4lMeuBx0=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.1006071404210.11780@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr>
	<s5hmxvmzwwd.wl%tiwai@suse.de>
	<alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr>
	<4BFD2901.20800@ladisch.de>
	<alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr>
	<4BFE5AA1.7070103@ladisch.de>
	<4BFE66CA.5070400@ladisch.de>
	<alpine.LSU.2.01.1006071404210.11780@obet.zrqbmnf.qr>
Date: Mon, 7 Jun 2010 11:03:56 -0400
Message-ID: <AANLkTilqmEK7R26DmLg0_LZ4al4F0_bX4asCl1DVA6GH@mail.gmail.com>
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
From: Alex Deucher <alexdeucher@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
       Dave Airlie <airlied@redhat.com>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 8:49 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Thursday 2010-05-27 14:34, Clemens Ladisch wrote:
>>Clemens Ladisch wrote:
>>> Please do not assume that the "HDMI" device is the right one, since you
>>> never got either one to work in Linux.
>>
>>Hmm, that computer is separate from the actual LCD, which has an HDMI
>>input, so it's possible that the HDMI output would be correct.
>>
>>In that case, it's likely that you've run into this bug:
>>https://bugs.freedesktop.org/show_bug.cgi?id=28030
>>
>>You might try the patch mentioned there, or radeonhd, or fglrx.
>
> Cc'ing drm.
>
> I conclude further tests.
>
> * Linux 2.6.35-rc2
> - fbcon:radeondrmfb using "modprobe radeon modeset=1"
>  - sound ok
> - Xorg (7.4) with 'radeonhd'
>  - fbcon ok, no sound in Xorg - I figure radeonhd is obsolete
> - Xorg with 'radeon'
>  - fbcon ok, xorg ok.
>    There is a small breakdown when switching between fbcon and xorg
>
> * Linux 2.6.33.5
> - like 2.6.35-rc2, but had a bug that prevented radeon.ko to go into
>  graphics mode when initially loaded; workaround: modprobe fglrx;
>  rmmod fglrx; modprobe radeon modeset=1
> - or fglrx, also makes sound work
>
> - fglrx bug aside: switching from Xorg to console (either 80x25 or
>  radeondrmfb) makes a fugly "pop" noise, and if the target is
>  radeomdrmfb, display is garbled.
>
>
> So I'm happy.
> Conclusive questions however:
>
> * Why is it that I am only allowed to have sound in graphics mode?

HDMI audio is only enabled on active outputs during modeset.

>
> * The radeon.ko module does not have any PCI IDs defined, thus does not
> get autoloaded like i915.ko. Is this intentional? It also seems
> to default to modeset=0.

What kernel are you using?  It definitely has pci ids and autoloads just fine.

Alex
