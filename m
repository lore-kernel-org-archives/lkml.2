Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0FGVE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:04:29 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57008 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0FGVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:04:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EXT3 File System Corruption 2.6.34
In-Reply-To: Your message of "Mon, 07 Jun 2010 14:45:38 MDT."
             <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275944666_5370P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jun 2010 17:04:26 -0400
Message-ID: <21412.1275944666@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4C0D5EDA.028E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275944666_5370P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 07 Jun 2010 14:45:38 MDT, Jeffrey Merkey said:
> Still seeing file system corruption after journal recovery in EXT3.

Are you getting bit by one of these mount options? (from 'man mount')
There were changes a few releases ago, might want to check what
your kernel build defaulted it to in your 2.6.34.

       data=3D=7Bjournal=7Cordered=7Cwriteback=7D
              Specifies  the  journalling  mode  for  file  data.  Metada=
ta is
              always journaled.  To use modes other than ordered on  the =
 root
              filesystem,  pass the mode to the kernel as boot parameter,=
 e.g.
              rootflags=3Ddata=3Djournal.

              journal
                     All data is committed into the  journal  prior  to  =
being
                     written into the main filesystem.

              ordered
                     This  is  the  default mode.  All data is forced dir=
ectly
                     out to the main file system prior to its  metadata  =
being
                     committed to the journal.

              writeback
                     Data ordering is not preserved - data may be written=
 into
                     the main filesystem after its metadata has been comm=
itted
                     to  the  journal.   This  is  rumoured to be the hig=
hest-
                     throughput option.   It  guarantees  internal  files=
ystem
                     integrity,  however  it  can  allow old data to appe=
ar in
                     files after a crash and journal recovery.

       barrier=3D0 / barrier=3D1
              This enables/disables barriers.   barrier=3D0  disables  it=
,  bar=E2=80=90
              rier=3D1 enables it.  Write barriers enforce proper on-disk=
 order=E2=80=90
              ing of journal commits, making volatile disk write  caches =
 safe
              to  use,  at some performance penalty.  The ext3 filesystem=
 does
              not enable write barriers by default.  Be sure to enable  b=
arri=E2=80=90
              ers  unless  your  disks  are battery-backed one way or ano=
ther.
              Otherwise you risk filesystem corruption in case of power  =
fail=E2=80=90
              ure.


--==_Exmh_1275944666_5370P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMDV7acC3lWbTT17ARAi7pAKD8PS/DVQPJ2LiGv1ixmWO8epvDTwCgukzz
qXrOMM4A3JBFI0qQ7NKK/2w=
=ch8S
-----END PGP SIGNATURE-----

--==_Exmh_1275944666_5370P--

