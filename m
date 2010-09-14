Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0INBq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 21:46:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47230 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0INBqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 21:46:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Cc: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
In-Reply-To: Your message of "Mon, 13 Sep 2010 17:22:49 +0200."
             <20100913152249.GC5364@const.bordeaux.inria.fr>
From: Valdis.Kletnieks@vt.edu
References: <20100825094925.GA3632@pema> <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain> <20100826210815.GA18131@pema> <4C76D9A0.2010907@zytor.com> <20100829205929.GA3309@pema> <20100913100719.GA3903@pema> <54870.1284390647@localhost>
            <20100913152249.GC5364@const.bordeaux.inria.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284428749_4377P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Sep 2010 21:45:49 -0400
Message-ID: <7925.1284428749@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C8ED3CE.01AF,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284428749_4377P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Sep 2010 17:22:49 +0200, Samuel Thibault said:

> Again, I'm not sure we really should try hard to make it automatically
> detected (and thus always enabled).  Having to pass a kernel parameter
> to enable the functionality is completely fine, since installing Linux
> on this device requires quite some tinkering already.

I'm agreeing that if iris_init() checks that the user passed 'irisinit.fo=
rce=3D1'
on the command line or as a module parameter, and bailed immediately if i=
t
wasn't passed, then doing the inb() and testing it should be safe enough.=
 Doing
stuff that's only known safe on an Iris is no great sin if the user has s=
aid
=22Yes, you're on a Iris=22 - at that point it's the user's fault.

static int iris_init(void)
=7B
	unsigned char status;

	if (=21irisinit.force) return; /* or whatever the appropriate test is */=


	status =3D inb(IRIS_GIO_INPUT);
	if (status =3D=3D IRIS_GIO_NODEV) =7B
		printk(KERN_ERR =22This machine does not seem to be an Iris. Power_off =
handler not installed.=5Cn=22);
		return -ENODEV;
	=7D

That look safe enough to everybody?  That way, even if a distro turns on =
every
CONFIG_FOO that compiles (you guys know who you are ;), it should still D=
TRT on
all platforms.


--==_Exmh_1284428749_4377P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMjtPNcC3lWbTT17ARAvRiAJ0ZNxWJWGaCi3qMPjDWHmrmkukNowCgna8b
ek0eVzET9gXFCzQtOu9n3Yw=
=Y67R
-----END PGP SIGNATURE-----

--==_Exmh_1284428749_4377P--

