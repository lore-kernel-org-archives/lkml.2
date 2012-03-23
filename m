Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab2CWJY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:24:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41975 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2CWJY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:24:28 -0400
Date: Fri, 23 Mar 2012 20:24:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-Id: <20120323202414.12bc2529aa4cb5b8e781878d@canb.auug.org.au>
In-Reply-To: <1332490809.2801.2.camel@dabdike.int.hansenpartnership.com>
References: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
	<1332490809.2801.2.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__23_Mar_2012_20_24_14_+1100_J_++NLvz/_IYE2IK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Mar_2012_20_24_14_+1100_J_++NLvz/_IYE2IK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Fri, 23 Mar 2012 08:20:09 +0000 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> On Fri, 2012-03-23 at 13:00 +1100, Stephen Rothwell wrote:
> >=20
> > After merging the scsi tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > drivers/ata/sata_svw.c: In function 'k2_sata_proc_open':
> > drivers/ata/sata_svw.c:327:2: error: implicit declaration of function '=
PDE' [-Werror=3Dimplicit-function-declaration]
> > drivers/ata/sata_svw.c:327:56: error: invalid type argument of '->' (ha=
ve 'int')
> > drivers/ata/sata_svw.c:328:1: warning: control reaches end of non-void =
function [-Wreturn-type]
>=20
> That's defined in linux/proc_fs.h
>=20
> What was the config?  Was it a no-PROCFS config, or is this just
> something that needs to be explicitly included?

See above, that was a powerpc ppc64_defconfig.  It certainly has PROCFS
enabled.  Almost everything needs to be explicitly included - see Rule 1
in Documentation/SubmitChecklist ...

Implicit includes are vulnerable to CONFIG changes and
architecture/platform differences in the include files.  I have seen lots
of these.  :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__23_Mar_2012_20_24_14_+1100_J_++NLvz/_IYE2IK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPbEE+AAoJEECxmPOUX5FELPQP/2OL8VLYrdMgdVcXUISbxetx
ly7QVHtp8cZ0w191zOVhkwZRgsCps9iim321j172h14hjUP2pU+CwEAFNw2rgh3p
LvA4eHnVuo2n5vbgrXgJe3gX6ooVLv/FMm31ZYEJMPYiWMqVJjd/MNA+pQmd/zaz
B+PWxxENpvalgrBHin2F3tXx68sdeysg17gqqn2DTBrLVgMUcrhqQ8lcs9UCKK0l
di1Ng4+LC9wt97VeDr8HuNjfIf5ZQHhrfZe+gAiGcjIm6kKhQH5bNIGgKrnkAozn
mi9LKC/gY3x97glgBvPil/y3eIgMWm+9lccztWC9lUuWmYd4vpMMeiobpNwAfZI6
5HZEsVgTAnZT/+oi1bzEPsyIMq34DALhjg2H0cdPdQA9zE/AWFhOmruXv8PniSv+
KivjF4MCaC+E3H/2cY/QCBiiS2/CaAr2XQZaoVVl4MkUV5MOdOPg/jAQdK74RbXI
dGWzOgdZbNf63antoQBCosi/+Lg7Qo3QCO6hoJ99CGrLjo9kmDBTjRLzvZND75W/
IjAGWVXVuxIis/9UUZSjGOzsTDhmDiJHuspkg95zGeNHAVcOWIETbv+D3CLH8UWB
dMsCHfu+OSnqgXg4q/2gSVEAlnaevEPpaOmzs84Altc/o7icdyDP0u5cv8178LMw
na0yFuhVUajf9Akoc/7I
=YYSX
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Mar_2012_20_24_14_+1100_J_++NLvz/_IYE2IK--
