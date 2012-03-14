Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318Ab2CNRdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:33:43 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33931 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761306Ab2CNRdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:33:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [INFO] : Hibernation and Resume between 2 similar devices
In-Reply-To: Your message of "Wed, 14 Mar 2012 03:21:58 PDT."
             <1331720518.14716.YahooMailNeo@web162005.mail.bf1.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <28119509.96581331614425960.JavaMail.weblogic@epml27> <201203132136.56353.rjw@sisk.pl>
            <1331720518.14716.YahooMailNeo@web162005.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1331746385_2943P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Mar 2012 13:33:05 -0400
Message-ID: <10238.1331746385@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4F60D652.0002,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1331746385_2943P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Mar 2012 03:21:58 PDT, PINTU KUMAR said:
> > From: Rafael J. Wysocki <rjw=40sisk.pl>
> > Not out of the box (you'd need to hack the kernel for that to work I =
think,
> > at least on x86) and the devices would need to be _exactly_ identical=
.
> > Moreover, if there is read-write mass storage in them, the filesystem=
s on
> > both would have to be exactly identical as well (including metadata a=
nd data
> > layout etc.).

> Suppose in =22Device 1=22 during hibernation, I have a file say =22file=
1.txt=22 opened whose inode number is say =22123456=22.
> This opened state of file1.txt will be captured in hibernation image.
> Now assume that same =22file1.txt=22 is also present (not opened) in =
=22Device2=22 but whose inode number is say =22567890=22.
> Now if I reboot =22Device 2=22 and try to resume from hibernated image =
of =22Device 1=22, what would happen to =22file1.txt=22 ??

Rafael was quite clear - the mass storage has to be *identical*.  You reb=
oot
with the image of =22Device 1=22, that had file1.txt open, what will happ=
en when
you close (or write, or sync) the file is this:

1) You'll write data out to disk into whatever blocks were owned by inode=

12345, no matter who actually owns them on Device2's storage.

2) You'll write out inode 12345 to disk, no matter what used to be there.=


Note that you'll do this same thing for *every single* file that was open=
 when
you hibernated, which means you'll corrupt every file that was opened *an=
d*
every file that was closed but was using the same blocks on the new disk =
as the
open file was using on the original disk.

In short, you just completely corrupted the file system.=20

--==_Exmh_1331746385_2943P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2DWUQdmEQWDXROgAQKDfw//cMEj6VG32LB0huOMBr4lnrSEJ+54sIRb
n13Ii6c4HLImH4blRLNnGrEmdXjh5KHUYUZlMmf43BPQuweaDqHp4TCJuHysW1u1
QRNYIWmotSwoI7L1bzUFmLBsRd1szOQUzBAug8PC8usl4cmo9UfsSWIoTDGygmaA
SRurmVYXtbgyUq52pC9cAr9S/W9cVH1lJvbnrmR86+HpgdUv9+sfk/7NQUL2YDEr
4fgPJOBcGI2JdKBx38iVNI/bqKDdUom78RTUAH1BrwQy7qo+rvulkYnCsKy2hLDF
BIjzmXjOkatCdCCzIN7Iy3ZGWLwV0qniWcx0jjtoABZ6X3meTGmycwny3Rb4bcsm
o1fmM94jUrHEMUMrbbwS69DxMZFYn2mTNp3UOAOxb1YLG/JueUphOh7cMBozsabH
kEwr6359iqvScCMjQcqpDbt3WbQQDBeOCiyiYSf/gMMC1AB/DrS9irfxjPTUjeev
1UVcRTbCcQ7TMz3tC10InJXMrKqGBcoJgS5L6y0ly4gEjMed2Exgn5/qacIYNb3W
QIYuRciHc8V7TGU8/sZSSsuhsgXLOO7VeDPHFX5rM58spMqaC+7uYmtJmj9wqXUq
s4g12TJ9nb7CKezJO0X6sY4qdHocx2ibs7Q26Nq3ghLJwq5VSpgflGx5QTnpp5ZA
/r0aOIkVEZ8=
=ApJ0
-----END PGP SIGNATURE-----

--==_Exmh_1331746385_2943P--

