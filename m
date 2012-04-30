Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2D3WWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:22:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab2D3WWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:22:12 -0400
Date: Tue, 1 May 2012 08:22:09 +1000
From: NeilBrown <neilb@suse.de>
To: linux-serial@vger.kernel.org, linux-pm@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Question:  How to power-manage UART-attached devices.
Message-ID: <20120501082209.0b560708@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ctRF/HtSS2O8siCR=DkRWlF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ctRF/HtSS2O8siCR=DkRWlF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Greetings.
 I have a conundrum that I am hoping someone could help me with.

 I have a mobile device (Openmoko successor: GTA04) which has two devices
 that are attached by UARTs - bluetooth and GPS.

 Each of these can usefully be power-managed:  The bluetooth shares a
 regulator with WIFI and if both are inactive the regulator can be turned o=
ff.
 GPS has a powered antenna which and be powered down when inactive, and also
 has an 'on/off' pin which, when pulsed, toggles the GPS between 'on' and
 'off.

 The question is how can user-space tell the kernel that these devices are
 'inactive'?

 I would like to integrate this into Linux in the most  "natural" way that I
 can but am having trouble.  My current approach involves using "rfkill" but
 that doesn't work very well for reasons that are probably not very relevant
 here.  It probably does make sense for powering the GPS antenna, but not
 much else.

 What I would really like is to integrate it closely with the state of the
 UART.  i.e. if the /dev/ttyO1 device is open, then the GPS is "on".  If not
 then it is "off".  Similarly if /dev/tty/O0 is open, bluetooth is "on", el=
se
 "off".
 However I cannot find any way to "plug in" to the tty or serial drivers to
 perform an arbitrary action on first-open or last-close.  Is something like
 that possible?=20
 If not, is it a reasonable thing to ask?=20
 Any suggests about where to put such a hook?


 It would be particularly useful if the hooked-in code could also find out
 about received characters when the device is thought to be "off".  This is
 because the only way to find out if the GPS is "on" is to see if it is
 sending data, so to turn it off you check if it is sending data and if it
 does, toggle the 'on/off' line.   I could manage this a different way by
 reprogramming the RX pin on the OMAP3 to be a GPIO and then taking a falli=
ng
 interrupt as an indication that the device is 'on', but I would rather
 something more integrated.

Thanks,
NeilBrown

--Sig_/ctRF/HtSS2O8siCR=DkRWlF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT58QkTnsnt1WYoG5AQLoJA//ValNGQBijBMx94EJ1jqQPW/dti2Hu0r0
ZNOgEhhVhX+yoDl7vrbVYM/aWmXrUqNqmtZEStf0Efc+zQ5kp4snZbvFH4gZJ21n
3KGvgTqCfLfdB6NIhXWJv9EWXURYI2e99GMp85rUj/R54wxfIVeP1pYJbVorOulc
PxPHiYwx3Y4WowAajzGsQ84kqEkAOM+fytbdrtIp3kjQ7scRZxOQgDfrNT1/x+Iz
J1Noos/Hf0OxFFqCsaaKVDuYo8nHchSimeODpFEiNTpKFDv0ePDLdVkZKiFzNPNP
bolgLqsO3XsQX1HSue17sIFUK38HBXYkleAXsCb5RWzREuCsIUog3Nvah/++RQpa
kLeUwlHvbhdbR3RTyyMkOCQ4MvPTrx7LGYgCC1LNqKDWt5UQxD0bV43tBxvQd7Ms
YaqpfisStK8s6apUx8Fi4ck/mL3d9m+pb0Hql2wBXcR3U8AFR2AtSEuE/60XiCih
WmNiI74K0M+6P0T1Aaq4/PDCk1EOdtuqBmVvHbB3o9b0JC69TW3d/N04ChGMjFUw
QiiCqpCE1q0qLxALyZoqgksXmNfIkCKHBUKGWuuYd+RWP5ChaiG2HBNV6L5MzU1N
MKX5VKU+RCC/oV4QZQzYz07z4QXmr4IGFzrThPFzs+Lp+QB6/w/TkJXM1ClutnvH
x+/4ZNa/J2k=
=yOju
-----END PGP SIGNATURE-----

--Sig_/ctRF/HtSS2O8siCR=DkRWlF--
