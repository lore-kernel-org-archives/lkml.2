Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab2LVNBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 08:01:55 -0500
Received: from mout.gmx.net ([212.227.15.19]:60860 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab2LVNBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 08:01:53 -0500
X-Greylist: delayed 756 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2012 08:01:53 EST
X-Authenticated: #2269360
X-Provags-ID: V01U2FsdGVkX189abon5gw9WZv601b/fF2gKHstjiY9Qug4EWFSsA
	Uo6W6yZbBN6Bej
From: Heinz Wiesinger <HMWiesinger@gmx.at>
To: John Stultz <john.stultz@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jonathan Nieder <jrnieder@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rabin Vincent <rabin.vincent@stericsson.com>,
        Janne Boman <janne.m.boman@gmail.com>, rtc-linux@googlegroups.com
Subject: Re: [regression] Re: [ 049/149] rtc: Disable the alarm in the hardware (v2)
Date: Sat, 22 Dec 2012 13:48:21 +0100
Message-ID: <2455959.DC51b1mVvG@callisto>
User-Agent: KMail/4.9.2 (Linux/3.2.32; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50C692B2.3010602@linaro.org>
References: <20120330195823.GA31857@kroah.com> <3675504.Gue7S6K4ie@callisto> <50C692B2.3010602@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart169526117.rYGHXgFNB4"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart169526117.rYGHXgFNB4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 10 December 2012 17:56:02 John Stultz wrote:
> On 12/08/2012 03:10 AM, Heinz Wiesinger wrote:
> > On Tuesday 04 December 2012 10:34:39 John Stultz wrote:
> >> On 12/04/2012 02:34 AM, Heinz Wiesinger wrote:
> >>> On Monday 03 December 2012 15:14:12 you wrote:
> >>>> On 11/05/2012 02:55 PM, Heinz Wiesinger wrote:
> >>>>> On Monday 05 November 2012 11:13:31 Greg KH wrote:
> >>>>>> On Mon, Nov 05, 2012 at 01:11:18AM -0800, Jonathan Nieder wrote:
> >>>>>>> Hi,
> >>>>>>> 
> >>>>>>> In March, Greg KH wrote:
> >>>>>>>> 3.2-stable review patch.  If anyone has any objections, please let
> >>>>>>>> me
> >>>>>>>> know.
> >>>>>>> 
> >>>>>>> Sorry, I'm a little late.  This seems to be causing spurious wakeups
> >>>>>>> after shutdown on some systems just like v1 did. :/
> >>>>>>> 
> >>>>>>> Janne Boman reports[1], using an HP EliteBook 8530w:
> >>>>>>> | I'm unable to shutdown my system via normal means. The system
> >>>>>>> | completes the shutdown process, all hardware lights are off, but
> >>>>>>> | then
> >>>>>>> | somehow it restarts.
> >>>>>>> 
> >>>>>>> Based on a quick web search, Heinz Wiesinger, using the same model,
> >>>>>>> 
> >>>>>>> ran into the same problem and bisected it to this patch:
> >>>>>>>      https://bugzilla.kernel.org/show_bug.cgi?id=44261
> >>>>>>> 
> >>>>>>> Janne confirmed the same by testing kernels closely based on 3.2.13
> >>>>>>> and 3.2.14 --- 3.2.13 shut down fine, while on 3.2.14 "shutdown -h
> >>>>>>> now" behaved roughly speaking like "reboot".  A kernel close to
> >>>>>>> 3.6.4
> >>>>>>> was also affected.
> >>>>>> 
> >>>>>> So is 3.6.6 still and issue?  How about 3.7-rc4?  3.4.18?  Figuring
> >>>>>> out
> >>>>>> if this is still an issue in Linus's tree would be the best thing to
> >>>>>> do
> >>>>>> first.
> >>>>> 
> >>>>> I checked 3.7-rc4 and the issue is still there. Should I still test
> >>>>> the
> >>>>> other versions as well? I can do so but it might take a bit.
> >>>>> 
> >>>>> If you need anything else, I'll be happy to help wherever I can.
> >>>> 
> >>>> Hey Heinz,
> >>>> 
> >>>>      Sorry for being slow to respond to this, I was on leave when it
> >>>> 
> >>>> arrived, and it got buried under other items.
> >>>> 
> >>>> This is peculiar.  I'm guessing something quirky with your hardware is
> >>>> causing the alarm irq to trigger shortly after we supposedly disable
> >>>> it.
> >>>> Could you send me your dmesg and kernel config?
> >>>> 
> >>>> After that I'll likely have to send you some debugging instructions
> >>>> (commenting out various lines) to try to figure out what exactly is
> >>>> triggering it.
> >>>> 
> >>>> Sorry for the trouble!
> >>> 
> >>> Hey John,
> >>> 
> >>> Don't worry, I know how it is to be busy.
> >>> 
> >>> For the dmesg/kernel config is it fine if I send you the one from
> >>> 3.7-rc4
> >>> or should I update to a more recent version?
> >> 
> >> 3.7-rc4 is fine.
> >> 
> >>> I've also now seen this behaviour on another notebook with completely
> >>> different hardware (Asus VX1). I can send you dmesg output from that one
> >>> too if you want. Kernel config should be almost identical, but it's
> >>> running 3.2.29 still.
> >> 
> >> Yea, dmesg there would be good as well.
> > 
> > Hey John,
> > 
> > Sorry for the delay. I was quite busy this week myself.
> > Please find the kernel config and dmesg output attached.
> 
> Thanks for the details!
> 
> Quick test: Does the issue persist if you boot with hpet=disable?

Sorry, took a while longer. Issue persists if I boot with hpet=disable.

Grs,
Heinz
--nextPart169526117.rYGHXgFNB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iF4EABEIAAYFAlDVrBUACgkQjjMixa08Y5SGjgD9HFdS/IwtTPu6VJYZwXGRFXsb
968PXGTD8jcHnqChxzEA/1bDQqoa6eNDHi96zR6AETecSG7/F0eAGgI4y8c4T3oN
=yUAT
-----END PGP SIGNATURE-----

--nextPart169526117.rYGHXgFNB4--

