Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0FAN0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:26:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36026 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0FAN0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:26:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: uwaysi.bin.kareem@paradoxuncreated.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Psychovisually-optimized HZ setting (2.6.33.3)
In-Reply-To: Your message of "Tue, 01 Jun 2010 12:47:15 +0200."
             <E1OJP07-00029Z-Cb@webmail02.domeneshop.no>
From: Valdis.Kletnieks@vt.edu
References: <E1OJP07-00029Z-Cb@webmail02.domeneshop.no>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275398746_12858P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 01 Jun 2010 09:25:46 -0400
Message-ID: <16283.1275398746@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4C050A5B.0071,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275398746_12858P
Content-Type: text/plain; charset=us-ascii

On Tue, 01 Jun 2010 12:47:15 +0200, uwaysi.bin.kareem@paradoxuncreated.com said:

> I do not really have any numbers Valdis, other than simple glxgears benchmarks.

I suspect that glxgears isn't telling you what you think it's telling you.
For starters, the distinction between a glxgears wank-o-meter reading of
4,000 FPS and 8,000 FPS doesn't actually *matter* when your screen is only
actually able to do 60 or 72 or 120FPS.  What it *really* tells you is that
the card that can do 8,000FPS can probably handle a more complicated scene
before the FPS drops below the refresh rate and you miss a frame, which
*will* be noticeable.

Repeat after me: Graphics cards are locked to the refresh rate, and you can't
see jitter or low frame rates unless it causes tearing, missed frames, or
other screen artifacts.  And to maximize your chances of not missing a screen
update, you want a *lower* HZ value so you don't waste precious time handling
timer interrupts.

> However I have a lot of experience with jitter, and I am looking for sporadic
> jitter, jitter related to application-startup, jitter that is more or less
> constant.

"Constant jitter" - talking like that will get you mocked mercilessly by
some people.

> Ofcourse I do not need any numbers either. If you think 1000 is better than
> 50, then there is a difference between 1000 and 4000 aswell.

OK, so why not go straight to 8,00 or 10,000 instead? Did you try values in that
range?

Hate to tell you this, but around here, you *do* need numbers to justify
making changes.  It used to be that HZ=100 was the only choice - 250 and
1000 were added because somebody showed that those options made noticeable
differences in the latency/overhead tradeoff (interestingly enough, HZ=1000
mattered more to audio processing than video, because most video cards are
locked to a relatively low refresh rate while audio cards will produce
a noticable transient if you miss a timeout by even 1ms).  HZ=300 was added
specifically to play nice with 60-hz video processing.

But to swallow the added overhead of setting HZ=4000, you'll have to show
some remarkable benefits (especially when you're pulling out a magic number
like 3956 rather than 4000).

> Put it simply one might state "If you feel that your computer is a bit
> stoopid, try increasing the value, and maybe you will be more satisfied." This
> because the computer now, is more like the human senses.

And maybe you won't be, unless you're the type of person who buys the
special $1,000 HDMI cables and $600 wooden volume controls.  Unfortunately,
we aren't building kernels for those type of people.

> And for those who would like to understand some of the methology behind this,
> again www.paradoxuncreated.com .Try the meditation-techinque, which purifies
> the mind from spirits.

Unfortunately, that's unlikely to get your changes into the kernel.

> Any answers related to this post, critisising or wasting my time, will be ignored.

Nor is this likely to help...

--==_Exmh_1275398746_12858P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMBQpacC3lWbTT17ARAvtiAJ0aBJ3zqTPYLWMBSymiVS9YG90taQCfUPr1
kQ3bYxUh87+YvPWLChsF2sw=
=SJrl
-----END PGP SIGNATURE-----

--==_Exmh_1275398746_12858P--

