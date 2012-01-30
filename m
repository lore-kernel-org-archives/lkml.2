Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2A3Uxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:53:34 -0500
Received: from nyu.romanrm.ru ([91.206.142.121]:39151 "EHLO nyu.romanrm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab2A3Uxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:53:32 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 15:53:31 EST
Date: Tue, 31 Jan 2012 02:53:29 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Roman Mamedov <rm@romanrm.ru>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Manuel Roeder <manuel_roeder@gmx.de>,
        Michael Ott <michael@king-coder.de>,
        Rodolfo Giometti <giometti@linux.it>,
        Mauro Barella <mbarella@vds-it.com>
Subject: Re: [2.6.37 -> 2.6.38 regression] "mv64xxx: I2C bus locked, block:
 1, time_left: 0" every few seconds
Message-ID: <20120131025329.30e73a3f@natsu>
In-Reply-To: <20120131024429.2affbd1c@natsu>
References: <20120101042401.4bef017e@natsu>
	<20120101073255.GA2402@elie.hsd1.il.comcast.net>
	<20120108004502.GA20549@ericsson.com>
	<20120131024429.2affbd1c@natsu>
Organization: http://version6.ru/
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HHMXivSGeXY7.O3THjI8M4e"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HHMXivSGeXY7.O3THjI8M4e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jan 2012 02:44:29 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> On Sat, 7 Jan 2012 16:45:02 -0800
> Guenter Roeck <guenter.roeck@ericsson.com> wrote:
>=20
> > >  - Michael Ott reported with Debian kernel 2.6.38-3 (which is closely
> > >    based on stable v2.6.38.2):
> > >=20
> > > 	syslog tell me every few seconds:
> > > 	i2c i2c-0: mv64xxx: I2C bus locked, block: 1, time_left: 0
> > >=20
> > >  - Manuel Roeder reported the same and found that upstream v2.6.38
> > >    triggers the problem and v2.6.37.6 does not.
> > >=20
> > >  - Roman Mamedov finds the bug present in Debian 3.1.6-1 (which
> > >    is closely based on stable v3.1.6) and Debian 2.6.37-2 (based on
> > >    stable v2.6.37.2) but not Debian 2.6.37-1 (based on mainline
> > >    v2.6.37).
> > >=20
> > > The regression range described above seems a little inconsistent to
> > > me, so maybe there's something more going on.
> > >=20
> > Points to commit eda6bee6c7e67b5bd17bdbced0926f5687f686d5 (i2c-mv64xxx:=
 send repeated START
> > between messages in xfer). Maybe you can back it out and see if it make=
s a difference.
>=20
> Hello,
>=20
> I have just confirmed that the problem still occurs in the current
> 3.2.2, and is indeed solved by rolling-back the referred commit.
>=20
> Should be noted that beside the "I2C bus locked" messages in dmesg, the d=
escribed problem
> manifested itself in the inability to read the temperature sensor value o=
r adjust the fan
> speed on the D-Link DNS-323. On all problematic kernels the built-in fan =
of DNS-323 does not
> rotate and this risks overheating the device and disks installed in it.

Also if anyone decides to further debug this, I should note that once a
'problematic' kernel has booted once on the device, a full power-off seems =
to
be required, before a 'good' kernel can work properly. Without this, even a
working kernel will manifest the same problem, it looks like something in t=
he
hardware gets locked-up hard and stays that way even across reboots. If
someone's unaware of this, it can completely foil any attempt at git bisect=
ing.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/HHMXivSGeXY7.O3THjI8M4e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8nA0kACgkQTLKSvz+PZwiwrACfVeXUL5wCGm2XsiOYC5DstB2c
ftAAn2Y4QFlNEYc5rRl9NF+I/XrkdNIn
=YJ91
-----END PGP SIGNATURE-----

--Sig_/HHMXivSGeXY7.O3THjI8M4e--
