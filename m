Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab2DTEHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 00:07:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41655 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab2DTEHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 00:07:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] blackfin: fix ifdef fustercluck in mach-bf538/boards/ezkit.c
Date: Fri, 20 Apr 2012 00:08:34 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.6.5; x86_64; ; )
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
References: <1334807838-3006-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1334807838-3006-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1799793.pIRqn5DR7R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201204200008.36915.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1799793.pIRqn5DR7R
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 April 2012 23:57:18 Paul Gortmaker wrote:
> This file has lots and lots of ifdef, around structure decls
> and structure usages.

yeah.  we killed some off, and there probably is room for more, but some of=
 the=20
subsystems are not friendly to dynamic resource management, so we need some=
 of=20
the ifdefs.  SPI doesn't like it if you declare resources for different dev=
ices=20
on the same CS even if you never actually use the device in question.  be n=
ice=20
if the detection could be delayed until "open" time.

> but since I had to tag the #endif with their respective #ifdef
> options to find this misplaced SPI endif, it would be silly to
> then go and delete them all.  So they stay.

Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike

--nextPart1799793.pIRqn5DR7R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPkOFEAAoJEEFjO5/oN/WBnYEP/Reihl79EYyn1JxL9xoG14sl
hZQDtlggxwAvsq3Ep1s0fYhAybwxW1PR7pFmmtpT8PMk1kbqtsabJnRfRaj+Xiqz
aoaMrQ8n79Q2xI9cTVFtong74QT3GbcxhLoNQyYL7rJC0qvrVIcCrvaf4f/Dk4Ck
jWVaBR6G1B/hvwyj7ymE0HcSgO425ERke/L4pW76Z6Vdj5dG1PX4hu1ReoD4B1TC
/oWwHh7vxva67TPZKZOF9xCQ+OPN2Z0Opo8N4OWrjYc3Tzr3OH7PAsvATkksUzTh
d1dmnnhnqxD8i94wEgJOUFnHV7ijMaRdl45H7MMB2lnkPLLT/8MDsmR97gU+DiY/
ZatvASSAN3q+Gg8GjXBU2DkMnJjbAweIZKQ3Jh4QpEodfXqcqL3SnJ7oRZ+GT2RC
fMqNqAd7U4JnrenxFEVfYSmtaeHHvFV6aBfS+yd90N8j1Fq9y+hPogIC74HuzzZP
cT1UNluJxNOydi5mkksffzN7bDTuyIgKiORdvbbqRalM34lBNRG1By1G28dx2NeG
v+DTSgpdW6F2S4lbSCyPrd+0lCBps9LdNDXDgAnb5p9vpuXb0+rK1g5CpLB83X8F
2DdVxdfPuZxuTru00iS1VyfyREwQhMXV/CYlukc+oamohGbR/1Mr1zVsrQQOa+fT
j+4FVYvTgPMNb/+qQRfW
=HH11
-----END PGP SIGNATURE-----

--nextPart1799793.pIRqn5DR7R--
