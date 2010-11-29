Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0K2Tku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:40:50 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37921 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0K2Tkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:40:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RTCIAJjH2HzADhTsy+qAgBJZqGHT3/lV94CmXg4cLF9cZvk4L6MAW1tJxfAgaLddZH
         IBZtoRSRPofallsCxbKxbyaKBvXZvwdAAscYKU86MIsILMZgz8j2YM8WcokWerEbZCii
         O15d8SCJtClneDDkP6kow7gkPblSKmNEDLX+U=
Date: Mon, 29 Nov 2010 14:40:41 -0500
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, tmhikaru@gmail.com,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101129194041.GA8280@roll>
References: <20101109185516.GQ8332@bombadil.infradead.org> <1289329348.2191.69.camel@laptop> <20101110034507.GV8332@bombadil.infradead.org> <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll> <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop> <1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette> <1291030726.32004.4.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1291030726.32004.4.camel@laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 29, 2010 at 12:38:46PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-11-28 at 12:40 +0100, Damien Wyart wrote:
> > Hi,
> >=20
> > * Peter Zijlstra <peterz@infradead.org> [2010-11-27 21:15]:
> > > How does this work for you? Its hideous but lets start simple.
> > > [...]
> >=20
> > Doesn't give wrong numbers like initial bug and tentative patches, but
> > feels a bit too slow when numbers go up and down. Correct values are
> > reached when waiting long enough, but it feels slow.
> >=20
> > As I've tested many combinations, maybe this is an impression because
> > I do not remember about "normal" delays for the load to rise and fall,
> > but this still feels slow.
>=20
> You can test this by either booting with nohz=3Doff, or builting with
> CONFIG_NO_HZ=3Dn and then comparing the result, something like
>=20
> make O=3Ddefconfig clean; while sleep 10; do uptime >> load.log; done &
> make -j32 O=3Ddefconfig; kill %1
>=20
> And comparing the curves between the NO_HZ and !NO_HZ kernels.
>=20
> I'll try and make the patch less hideous ;-)

I've tested this patch on my own use case, and it seems to work for the most
part - it's still not settling as low as the previous implementation used
to, nor is it settling as low as CONFIG_NO_HZ=3DN (that is to say, 0.00 acr=
oss
the board when not being used) however, this is definitely an improvement:

14:26:04 up  9:08,  5 users,  load average: 0.05, 0.01, 0.00

This is the result of running uptime on a checked out version of
[74f5187ac873042f502227701ed1727e7c5fbfa9] sched: Cure load average vs NO_H=
Z woes

with the patch applied, starting X, and simply letting the machine sit idle
for nine hours. For the brief period I spent watching it after boot, it
quickly began settling down to a reasonable value, I only let it sit idle
this long to verify the loadavg was consistently low. (the loadavg was
consistently erratic, anywhere from 0.6 to 1.2 with the machine idle without
this patch)

Thank you for the hard work,
Tim McGrath

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTPQBuZEncCrqzVruAQIJmQf7BKma307MkMeAe/y0rT+MJ+tVWmZh9s1k
LncUBt/VAfffuZeFHUaS84t7TrxT6kH5hxz+Gw4kZyIiweL1tp6sp2O3gC4FRfth
GVzONldz3oLhmPLn5rXXeYnc4ONwGL9f8t1rOtu5xVeRsCrLIqMc3nPQUIpkYM9E
D/xvUiyuSBLs6qPzV4ARJKKqiJ1QkSnJxyC4Ofkk4DodPi/2c2UvOxFy8xqrlPoH
OYoHw28+ZikhLXHPewnGGSiO/6p0Ri09dQ/yjFXpWSdlgfHmDBVNrNO6r/q/o3DH
enZC+nflPParBZpUfxfX9DU0pxn8txgnLs7UAaydCgTIw1/Pwp6I9g==
=eLKw
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
