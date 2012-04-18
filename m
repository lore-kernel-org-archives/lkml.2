Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2DRO0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2DRO0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:26:45 -0400
Message-ID: <4F8ECED3.5070909@redhat.com>
Date: Wed, 18 Apr 2012 10:25:23 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [Patch 5/8] mqueue: revert bump up DFLT_*MAX
References: <cover.1334676645.git.dledford@redhat.com> <de8d761688dd34f312822db71ceed6753493933a.1334676645.git.dledford@redhat.com> <20120418032210.GB18830@mail.hallyn.com>
In-Reply-To: <20120418032210.GB18830@mail.hallyn.com>
X-Enigmail-Version: 1.4
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig87F6A8463E0AFBDB13138974"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig87F6A8463E0AFBDB13138974
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 4/17/2012 11:22 PM, Serge E. Hallyn wrote:
> Quoting Doug Ledford (dledford@redhat.com):
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> Mqueue limitation is slightly naieve parameter likes other ipcs
>> because unprivileged user can consume kernel memory by using ipcs.
>>
>> Thus, too aggressive raise bring us security issue. Example,
>> current setting allow evil unprivileged user use 256GB (=3D 256
>> * 1024 * 1024*1024) and it's enough large to system will belome
>> unresponsive. Don't do that.
>>
>> Instead, every admin should adjust the knobs for their own systems.
>=20
> Would you be terribly averse to having a higher limit in init_ipc_ns,
> and the lower values by default in all child namespaces?
>=20
> Sorry it sounds from the intro like you've already had quite a bit of
> discussion on this...
>=20
> Of course I realize the values can just be raised by distro boot
> scripts...

The default maximums this patch put into place were in fact in place
from 2008 until my earlier patch in this same series, so in that regard
this is merely restoring an already established default maximum.  It
*could* be raised, yes, but as Motohiro pointed out, this is pinned
memory that any user can allocate, so the smaller the default amount the
better.  The sysadmin can make changes as they see fit.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig87F6A8463E0AFBDB13138974
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPjs7TAAoJELgmozMOVy/dzmQQAKfIoiAFB1KxZjPmdcHXbPyD
ruSBACGzYzzNyyJkeRTfWR6TQpZHOoZtaCe6mtHzD1lGqZnLWFX5kqtTk7BVc+HD
b3J2C26OGcgnyMNXkXZAz8kkVoynoTCLjbK1TplaKmrQwzI1kyWHJ3WBRrRC8cNE
rLw+7d3Jsg3EhNAEKRg7UnSJYjoLlPELSC02UPVWYtMUtRy7ArnDf1T/ytIx7edm
Pd8HP4JqhuC6+Vny+w3LzDc/kqMZ6tonq/dm/TydNoaF9ldxUZpRSNX4PPKUNN/K
rYBJpHxrvOa5jfPesLiRD86B+nQPO4Fr3pqZ9wR9K5FJU776upWWcx5GFJIJlGB0
1x2lz9eIc3k1oMQEIXqsCz9j1ZJLsmtWjnIwE/UyHICrAxkNN7XQ4JOWP8QR4eS3
SQ8fUaDkuUGXyl/rlC67zqfdbSvSGEE2YCO/DUP3W6t9UolI9xrVOUoodVU2At3I
lNRROPN/dedi+mE97IF4D/qvORp08Au1YS2ktOvM2tMuG5XgPOsjQpA8AyYB4kPb
Bb4T6m7e2oSibxjNwyS/ibiRKIcjC7EqJqci/lpxQquN+dlpOUXxuWNsU1TetACk
a23PBuMj6Vsg9EExa5aPG4x3LBN77qUwYbPZ65iUpZKlowtwcZU4nPv3k4YlQceC
4NyTN6vRpg5hhIM+BKPQ
=7rBX
-----END PGP SIGNATURE-----

--------------enig87F6A8463E0AFBDB13138974--
