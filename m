Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1CQIqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:46:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37544 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1CQIqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:46:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: X32 syscall number base
Date: Thu, 17 Mar 2011 04:46:11 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37.3; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
In-Reply-To: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1629223.dgVLgLuMBb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103170446.12011.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1629223.dgVLgLuMBb
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

in looking at how syscalls are implemented, i see that you've picked a base=
 of=20
4096.  so syscall numbers [0...4096) are for x86_64 and [4096...-1) are for=
=20
x32.  this 4096 limit is a bit low isnt it ?  seems like the best bet would=
 be=20
to bisect the available space for each new ABI ...

ARM EABI picked 0x900000 for their base when adding a new ABI ...
=2Dmike

--nextPart1629223.dgVLgLuMBb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNgcpTAAoJEEFjO5/oN/WBjHwQAIJQ4gFURUEqmZLHYeAHWeSi
BOdQ+xjQoLVULF5udv6gQliKpQtPX/9SVBkMjQosb9jFgOp/7MNHiFHmNzDtpZJS
hXfH75AWEb12bkdWl9dM94Bh1cthgGBbkudiIeE+dMboz12STBlhdnR+0UhOEyrC
tHUtYOJB4Dqy4eKPXKbqCyCx5ARVTh0xsUnuN2Ma4TgXyhu19t+06faZS8wRC3Ts
1i06Iv8EQ8+NFGkU+t1bMn+GL4SvfZjQRUdJOy9uWY1ohKb5qHq/UJHC6yjvkVsh
6iKORjQpjezRYz9Tc9o/cpPoA1EeEU1wS0uu+5Dgf8Tk61yTgzVYi41dyMpN1rK6
7OEBCMiz3q/+Sokt9bksrOaCyWyh3mZTcte+g/y1UVko1HpFH029t9twHds2no9P
MYlhKT85241g7CbDKkzJfWdxPaOVw8o8l9pjQW3t5/HOc8xOmtcAoEKKh/SkS/KK
ALStHFhW9mAS8eXnFRFZS0d51Lb/s9JuGTEorAfuJo1U2rBYy/VBBYb16k0+7xuo
mULmm2AqyfmT1lHlwPLx3SiT11szOcUPhpe/aGcobEYdaD3Ykwd7sKi2gyXWbtpV
FGWqhPao66T0bH0qppQOUv2o7FE9TWJjjBKFvB+9fjkMHEBpAE7yMd+7efyKu2aK
aIL+3GIMN8jjZB+Bf0vg
=jdv8
-----END PGP SIGNATURE-----

--nextPart1629223.dgVLgLuMBb--
