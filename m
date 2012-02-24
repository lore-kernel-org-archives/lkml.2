Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab2BXQMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:12:48 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33669 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab2BXQMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:12:47 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
Date: Fri, 24 Feb 2012 11:12:43 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>
References: <20120222150010.c784b29b.akpm@linux-foundation.org> <201202231847.55733.vapier@gentoo.org> <CAAHN_R0ihoA6K8w53ToRD1xew9NWk-bJAZ=U0+hgRV3=0FpVDg@mail.gmail.com>
In-Reply-To: <CAAHN_R0ihoA6K8w53ToRD1xew9NWk-bJAZ=U0+hgRV3=0FpVDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1417372.jNFM8tIgvD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202241112.46337.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1417372.jNFM8tIgvD
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 24 February 2012 00:47:48 Siddhesh Poyarekar wrote:
> On Fri, Feb 24, 2012 at 5:17 AM, Mike Frysinger wrote:
> > i don't suppose we could have it say "[tid stack]" rather than "[stack]"
> > ?  or perhaps even "[stack tid:%u]" with replacing %u with the tid ?
>=20
> Why do we need to differentiate a thread stack from a process stack?

if it's trivial to display, it'd be nice to coordinate things when=20
investigating issues

> If someone really wants to know, the main stack is the last one since
> it doesn't look like mmap allocates anything above the stack right
> now.

you can't rely on that.  you're describing arch-specific details that happe=
n to=20
work.

> I like the idea of marking all stack vmas with their task ids but it
> will most likely break procps.

how ?

> Besides, I think it could be done within procps with this change rather t=
han
> having the kernel do it.

how exactly is procps supposed to figure this out ?  /proc/<pid>/maps shows=
 the=20
pid's main stack, as does /proc/<pid>/tid/*/maps.
=2Dmike

--nextPart1417372.jNFM8tIgvD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPR7b+AAoJEEFjO5/oN/WBvJ4QAIYoaGeQ0P8fCc/VzLWuGTKr
9x9NxwROzsweDQlC8TFAp49dVvVWhJblMv4xVVd2bMwSeYoA3Tl/zwBdE53BlxiR
XYKPVpyuFA0WO84o8e1S7Wzf9DL8aT+P2YLp005er21SKkQ99tu55NbcQXnu907s
wDNCwNBp9yLyV4uRANk4dT5GYBuqTlL7bgxO9ba4NlhNUFPdI8XtEjQErYdr0DXT
B/Zao8cFoe/ZTL9BqT9uDnw+8CnKKOLG+7k1tuGI1/N3a4HBPn9bOhk39CiX1UJo
nFrDLrc/rkVg38ya/WwX7RohZruyRGttfIVm8+pnWb6OS3beQEZhLgQkb4qCR8Z8
vx5/vrur4vWH6NnJHdKBd0PstvglMN9ry1KUgmvTAjwTi2HrGqzIyEwDFtppz9Py
gBrLSZcThEwNZDkiqXxzpbClZJdVMa7aq8nIIcad1WoeGOnIpH+qBRx0TmEywbGj
96uoHaMUhjTmBkhOvhozLMtkPAiCH6hS+otKZjUMEYVNo55664HkyvzxnQAC9tRB
5Iy4z4Vl71BrtRPPC0pj25IUuHv6IgExinYhvmV1Av5Hnq3NUxEAT/mW32jP4IXr
A+s4NR6lVPRMTcnyDCLbYWCfryu+n2QCNGuSLiC5ocZSSECiXv3VXKZllhlEqqU+
GGD4m3u1aWziV8VGtjje
=zsgO
-----END PGP SIGNATURE-----

--nextPart1417372.jNFM8tIgvD--
