Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0JVIxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:53:34 -0400
Received: from brent.tribalogic.net ([78.86.109.144]:44916 "EHLO
	summit.brent.tribalogic.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751985Ab0JVIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:53:33 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 04:53:33 EDT
Message-ID: <4CC14F4E.4090509@colin.guthr.ie>
Date: Fri, 22 Oct 2010 09:46:06 +0100
From: Colin Guthrie <gmane@colin.guthr.ie>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, clemens@ladisch.de,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com>	<s5hfww0c6oj.wl%tiwai@suse.de>	<4CC085F5.9070905@gmail.com>	<s5heibjxsi4.wl%tiwai@suse.de>	<4CC092BC.9060504@gmail.com>	<s5h8w1rxrl3.wl%tiwai@suse.de>	<5220.1287692957@localhost>	<s5h39rzclx3.wl%tiwai@suse.de>	<8089.1287696264@localhost> <s5hsjzzb5cf.wl%tiwai@suse.de> <4CC0B3C1.9010106@gmail.com>
In-Reply-To: <4CC0B3C1.9010106@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'Twas brillig, and Jiri Slaby at 21/10/10 22:42 did gyre and gimble:
> On 10/21/2010 11:31 PM, Takashi Iwai wrote:
>> OK.  Maybe someone else can check it meanwhile.
> 
> Someone else rebooted the 13th time today and checked :):
> $ rpm -q `rpmqpack |egrep 'alsa|asound'|sort`
> alsa-1.0.22.git20101018-1.1.x86_64
> alsa-firmware-1.0.23-3.7.noarch
> alsa-oss-1.0.17-31.4.x86_64
> alsa-plugins-1.0.23-4.5.x86_64
> alsa-plugins-pulse-1.0.23-4.5.x86_64
> alsa-plugins-pulse-32bit-1.0.23-4.5.x86_64
> alsa-plugins-32bit-1.0.23-4.5.x86_64
> alsa-utils-1.0.23-4.5.x86_64
> libasound2-1.0.22.git20101018-1.1.x86_64
> libasound2-32bit-1.0.23-6.5.x86_64
> 
> No success. I still need the revert.
> 
> regards,

Just tested the latest kernel patch in a "proper" (i.e. patched in
kernel) build (as opposed to my previous out-of-tree builds).

It's working great for me (stac9200)

I tried without the userspace patch and things still work fine for me
under this setup - it's just that PAs flat volumes do not properly
control the Master+PCM pipeline (they both go to mute when master hits 0).

But it doesn't seem to cause any other problems for me.

I'm no expert at the kernel side, but can't see much in the code that
would cause this.

However, from Jiri's alsa-info, this looks a bit suspicious:

Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 64
  Mono: Playback 40 [62%] [1620.40dB] [on]

1620.40dB?? Really?

Is perhaps the TLV fix for min-is-mute conflicting with a db range fix?

Col


-- 

Colin Guthrie
gmane(at)colin.guthr.ie
http://colin.guthr.ie/

Day Job:
  Tribalogic Limited [http://www.tribalogic.net/]
Open Source:
  Mageia Contributor [http://www.mageia.org/]
  PulseAudio Hacker [http://www.pulseaudio.org/]
  Trac Hacker [http://trac.edgewall.org/]
