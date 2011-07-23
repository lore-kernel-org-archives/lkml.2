Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1GWPI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 11:08:26 -0400
Received: from ltw.loris.tv ([85.14.220.160]:37138 "EHLO ltw.loris.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab1GWPIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 11:08:19 -0400
Message-ID: <4E2AE3C9.8060509@drcomp.erfurt.thur.de>
Date: Sat, 23 Jul 2011 17:07:53 +0200
From: Adrian Knoth <adi@drcomp.erfurt.thur.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Fons Adriaensen <fons@linuxaudio.org>
CC: Tom Gundersen <teg@jklm.no>,
        General Discussion about Arch Linux 
	<arch-general@archlinux.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [arch-general] Panic - no sound devices after upgrade
References: <20110720163844.GB16901@linuxaudio.org> <CAG-2HqWqATSJ=oJTTvULXwPEG82yN+8e6GJFs759hPA-=krAOQ@mail.gmail.com> <20110721100944.GA13971@linuxaudio.org> <CAG-2HqX23C79vfccnu0tMqx+6K9Z5pS0_HekaLizQx7XfkPQ1Q@mail.gmail.com> <20110721112331.GA15059@linuxaudio.org> <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com> <4E28313E.60900@drcomp.erfurt.thur.de> <CAG-2HqVew75LE68fObz7e3WwcT-5Gwu1ka9Zr4vb1JdbSUOYEQ@mail.gmail.com> <20110722193710.GA8452@linuxaudio.org> <20110722231430.GN3771@ltw.loris.tv> <20110723142117.GA21836@linuxaudio.org>
In-Reply-To: <20110723142117.GA21836@linuxaudio.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/11 16:21, Fons Adriaensen wrote:

Note: I suggest to narrow the CC list a bit and better move the
discussion to alsa-devel. At least, let's drop LKML and arch.

>>> Seems to have solved the problem :-) :-)
>> Good to know. I'll wait for your final confirmation and then commit it.
> 
> One problem: the gain settings have changed, now having a range of 0..64.
> How do these values map to the internal ones (0..0xffff) ? I *hope* there
> is value corresponding to EXACTLY 0x8000 (gain = 1) !!!

For the simple ALSA mixer, the driver does

   gain = ucontrol->value.integer.value[0]*UNITY_GAIN/64;

UNITY_GAIN is 32768 (0x8000), so if you select 64 on the ALSA side, it
gives you exactly what you need. Or in other words: faders to 100% in
alsamixer, that's it.

With hdspmixer or any other software that's using the full mixer, you
can still use the fine-grained 65k steps.


> BTW, why was this change made?

No idea. I reckon faberman was tired of stepping through 65k mixer
levels in alsamixer. ;) (disclaimer: I never used the old driver, so I
don't know how it was before)


Cheers

