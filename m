Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1CPUJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:09:50 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49955 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab1CPUJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:09:45 -0400
Message-ID: <4D8118EB.2070209@fastmail.fm>
Date: Wed, 16 Mar 2011 21:09:15 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, xorg-driver-ati@lists.x.org
Subject: Re: Radeon jittery post 2.6.35
References: <4D7CCFC3.7030906@fastmail.fm>	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>	<AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>	<4D7FD2FB.9090505@fastmail.fm> <AANLkTimboMAFkqTUOwP9m2z361TM_EgthQO07T5Y_az1@mail.gmail.com>
In-Reply-To: <AANLkTimboMAFkqTUOwP9m2z361TM_EgthQO07T5Y_az1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.238.16
X-Scan-Result: No virus found in message 1Pzx2C-0006xC-3v.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Pzx2C-0006xC-3v 05821f60c876658c7c703530372582cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 03/15/11 22:46, Alex Deucher wrote:
>  Try booting with radeon.audio=0 on 2.6.38rc, some TVs have problems
> with the hdmi packets we send by default.  disabling audio will treat
> the hdmi like dvi.
>
> Alex
You seem to be on to something there. radeon.audio=0 removes
what appears to be all of the jitter. I say "appear", because during
my many test runs today, I've come across moments where my brain
goes "wasn't what I just noticed on the TV something abnormal?" Both
in fb mode (post KMS), and in X11. It's definetly improved from useless
for family use, to perfectly ok though.

Back when the radeonhd and radeon X drivers where on par, HDMIAudio
where first introduced in the radeonhd driver. I recall testing HDMIAudio
sucessfully then, but haven't used HDMUAudio since, and have switched to
the radeon driver. Now when I check for HDMIAudio (with and without that
command line option), I come up blank (all I see is an S/PDIF output). Isn't
HDMIAudio supported on this card? I googled up a post suggesting that it
was ported to R600+ cards in the radeon driver which would suggest that
the RS690 driver doesn't support it(?).

If at all possible, I'd like to have HDMIAudio operational as the HW
supports it.

A couple of data points:
* Disabling HDMIAudio in the BIOS does not change anything (GRUB bad,
KMS fixes it, etc..)
* A pm-suspend cycle with the TV powered on is enough to turn a
jitter-free session jittery (if I don't use radeon.audio=0)

Any patches I can try (either to add support, or fixup what's currently
broken w/ HDMIAudio?)

-Anders

