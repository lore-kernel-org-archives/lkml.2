Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab2EKTPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:15:53 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab2EKTPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:15:51 -0400
Message-ID: <4FAD6563.7040408@nod.at>
Date: Fri, 11 May 2012 21:15:47 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, tim.bird@am.sony.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de
Subject: Re: [PATCH 1/7] [RFC] UBI: Add checkpoint on-chip layout
References: <1336585125-127220-1-git-send-email-richard@nod.at>    <1336585125-127220-2-git-send-email-richard@nod.at>   <1336735041.2625.35.camel@sauron.fi.intel.com> <4FACFFED.40105@nod.at>  <1336738864.2625.66.camel@sauron.fi.intel.com> <4FAD493F.1040804@nod.at> <1336762570.6126.6.camel@brekeke>
In-Reply-To: <1336762570.6126.6.camel@brekeke>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD8CE7FF7399C56B86182D8B3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD8CE7FF7399C56B86182D8B3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 11.05.2012 20:56, schrieb Artem Bityutskiy:
> I think this is not a good enough justification. I think we may use
> 0xFFFFFFFF and other high EC values to indicate that the block was bad
> or erroneous or whatever.

Okay, then we have to store all PEB ec values. (used, free, erroneous and=
 scrub)
This is not a big deal.
As I said, currently only used and free PEBs are stored.

I think we need also a better solution for the protection queue.
My current solution (ubi_flush_prot_queue) is not the right thing.
Today I've observed a data corruption issue an I'm sure it happened
because fastmap did the wrong thing with the protection queue.
The problem is that a PEB in the protection queue is not visible to fastm=
ap.
(Because it writes only used and free PEBs on the flash).

> BTW, did you think about scenario of moving dumping UBI2 on on one
> device with one bad PEBs distribution and then flashing it to a
> different device with a different bad PEB distribution? What would
> happen when we have fastmap enabled? Also, what if I write it to a
> larger flash with otherwise the same geometry?
>=20
> I guess we could detect these things and fall-back to scanning?

Falling back to scanning is easy.
But how can we detect such a change?

Thanks,
//richard



--------------enigD8CE7FF7399C56B86182D8B3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPrWVjAAoJEN9758yqZn9etgQIAJMRZvDL3843VWPkaIcZJoCJ
KBsFAwxb7sy7rL+E6c0y9C4fuZceg9CjwHEGdSoPvgiywAKrHtIaPtKebeOILgG8
3NQMXuJY4sX/Q1LHBLnosc5V2KLVnKVhrAFs2Ku4VKmIBFzZxfQPOwoySHlDSpjP
AFU8jN0jDz8vtwtBP+PpARnr7BwHQ8T0PCqkepPQO7n+osIxVVkmk8+N8D+t+14k
42JsWWGuIcaivvgiEKCUKg63/VgxCmVo/A001q0w3DsqtPaWn7XeD8tTpGJREH0p
CP4rk3py4PhntFBcxkfrpTME7Uk+zM7h7JYYhynylm+dXJoHHRjpysScl2ZuaYM=
=LI31
-----END PGP SIGNATURE-----

--------------enigD8CE7FF7399C56B86182D8B3--
