Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2EHK7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:59:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab2EHK7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:59:19 -0400
Message-ID: <4FA8FC83.7000503@nod.at>
Date: Tue, 08 May 2012 12:59:15 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] UBI: Replace yield() with cond_resched()
References: <1336465602-12627-1-git-send-email-richard@nod.at> <1336467723.23308.23.camel@sauron.fi.intel.com>
In-Reply-To: <1336467723.23308.23.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8F5C05EDFA887649D3D72122"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8F5C05EDFA887649D3D72122
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 08.05.2012 11:02, schrieb Artem Bityutskiy:
> On Tue, 2012-05-08 at 10:26 +0200, Richard Weinberger wrote:
>> The comment above yield()'s definition says:
>>  * If you want to use yield() to wait for something, use wait_event().=

>>  * If you want to use yield() to be 'nice' for others, use cond_resche=
d().
>>  * If you still want to use yield(), do not!
>>
>> The yield() usage of UBI really looks like the "be nice for others" ca=
se,
>> so use cond_resched().
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> CC: peterz@infradead.org
>
> I guess we would better sleep for a couple of hundreds of milliseconds
> instead.

So, you'd prefer a msleep_interruptible(500) instead of yield() in this c=
ase?

> The purpose was different. If we have I/O error, we hope it is a
> transient failure. E.g., the HW is temporary unavailable because of an
> internal issue. And with yield() we hoped to schedule away for longer
> time than usual and let other processes which may affect that HW go
> forward and do something.

Okay, yield() is clearly the wrong choice here.
cond_resched() is better.

Thanks,
//richard


--------------enig8F5C05EDFA887649D3D72122
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPqPyDAAoJEN9758yqZn9ejpgH/2tvAjGBbOKEFwbnCCNgEnAz
zQ0tC1cM/IwU0pftqDd2MlPEVpkPNzqW/sFfDMAEqaF9kY+GFztY8piYaZX3Pqtc
w9kIvBU12QTAswZdvI4vFBybsumzLBRsQuSzDv+FiT19HolY90eUWXBAFC8oQT6I
bawGrXXH3uCIvgxgnF36irYRibq69fWeTFQOeBtiXnPt+RC/jzZO6CJwdpaCAJWq
mTwC5ckR9I61W2kUWMQpzg++wGKpEKw/SwXGpyxXXcqicjkVZ2zEqtft/d+rGjg7
DDHVYtNxNFuAjMC3m1rYgqRUOZuAcPVybr77JzF8x4S60eqaCY4Xk56DwPvUEY8=
=UWP6
-----END PGP SIGNATURE-----

--------------enig8F5C05EDFA887649D3D72122--
