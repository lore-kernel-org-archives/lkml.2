Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2EHNU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:20:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:62151 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab2EHNU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:20:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="163407084"
Message-ID: <1336483427.23308.37.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Replace yield() with cond_resched()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Date: Tue, 08 May 2012 16:23:47 +0300
In-Reply-To: <4FA8FC83.7000503@nod.at>
References: <1336465602-12627-1-git-send-email-richard@nod.at>
	 <1336467723.23308.23.camel@sauron.fi.intel.com> <4FA8FC83.7000503@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-m6LTfWPk/PxgaBs9Am8f"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m6LTfWPk/PxgaBs9Am8f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-08 at 12:59 +0200, Richard Weinberger wrote:
> > The purpose was different. If we have I/O error, we hope it is a
> > transient failure. E.g., the HW is temporary unavailable because of an
> > internal issue. And with yield() we hoped to schedule away for longer
> > time than usual and let other processes which may affect that HW go
> > forward and do something.
>=20
> Okay, yield() is clearly the wrong choice here.
> cond_resched() is better.

I do not think it is better. Yes, for I/O I'd suggest
msleep_interruptible(200) instead.

--=20
Best Regards,
Artem Bityutskiy

--=-m6LTfWPk/PxgaBs9Am8f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqR5jAAoJECmIfjd9wqK0Jq0P+QEPbkZPYZrroG8yw8NWfvw8
kRuQpfFjpuWQZplJBaqwAKfV8O5l2O4YS/ptyX2x7rnH7q8S62puc55Nf0tfVMZT
Ge2VdkwZch3iA/4BQTqLve9kbqTuug5kjmOnOdERaZb08J2ys4Nt1nXmHPvEZEMY
1DEX4VHRBGXPROkiVszTjaw+Ka9/Rlv9otRti1YlilCdnChQHFQT07+g6IdWURCj
zCsGbRtteY0twP2yUiOZIqwXrFrq/uqzw9n6gEvubj1Q/upsKzo+ZB5mosG24DUV
72jhfoMuILVpj7kiDib+WmO/FuEKFxJzWlQhTjH0HEpv+Z2ZsOkrjmSpfANnguG/
kqsCiuGGfUqIuL5Wd3bz1fs7yRNHRTCN1u572jFN+Mb8Q4KOS0oy4FzvEwTNMdi1
KsM4kJy5aTEyKBrn5jILtNABZE34pvyUkra/HCDnNejDzmb/RzbSawuHLIwGgJTn
cV+jAyw9VEZO78Fyw9lyfxfZChcFxsYtNLqYJiusWLV+VDNfKRIrwy4+UqMmVJX1
54xtxiwVD/MNH/Svbhh98XwvVjeQAvV2aUW1PEW5DyBDh6gM45LZkPNq3h22fQQZ
Vxq8DF9PxaCN4kEfwYWSf+uUupQ7MDWaH5ti+aHsXwG7bo54JGH/Tk52k0Uxb7Sg
KBPYQE59I6GlE1r+h9AH
=4D6I
-----END PGP SIGNATURE-----

--=-m6LTfWPk/PxgaBs9Am8f--

