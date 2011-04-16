Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1DPPI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 11:08:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36346 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab1DPPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 11:08:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Francis Moreau <francis.moro@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the last build
In-Reply-To: Your message of "Sat, 16 Apr 2011 16:45:33 +0200."
             <BANLkTimSa7=HiSKET4FSR5zqa1mXf2xGFw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com> <BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com> <20110416135912.GA1044@merkur.ravnborg.org> <BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com> <61322.1302964434@localhost>
            <BANLkTimSa7=HiSKET4FSR5zqa1mXf2xGFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302966525_54890P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Apr 2011 11:08:45 -0400
Message-ID: <62853.1302966525@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4DA9B100.0107,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302966525_54890P
Content-Type: text/plain; charset=us-ascii

On Sat, 16 Apr 2011 16:45:33 +0200, Francis Moreau said:

> For example, user did:
>   $ make CC=distcc
> then call my script:
>   $ my-script
> which in its turn does:
>   $ make
> then the whole kernel is rebuilt..

You have two choices then:

1)  Allow them to pass stuff to your script:

$ make CC=distcc
then call my script:
$ my-script CC=distcc
which in its turn does:
$ make "$*"

2) Find out *why* they're doing a make of the kernel, and then calling your
script that *again* does a make of the kernel, instead of just calling your
script and being done with it.  This sounds like you have a poorly designed
build environment, and *that* needs fixing instead of kbuild.  There's really
an upper limit to how much kbuild is able to help a 3rd-party script writer who
has users who can't follow directions. There's just too many ways they can do
things that will cause a rebuild - they can do a make, then run a 'make
menuconfig' and change some important setting, then call your script and wham
you end up rebuilding the kernel anyhow.


--==_Exmh_1302966525_54890P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqbD9cC3lWbTT17ARAsQUAJ44EeqK4U60nreTfPa2Ojfb1+DafgCdFSXK
AG/jWbN2x9L9yFArzjLshWE=
=afAE
-----END PGP SIGNATURE-----

--==_Exmh_1302966525_54890P--

