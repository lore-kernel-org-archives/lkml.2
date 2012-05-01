Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2EAXDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab2EAXDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:03:07 -0400
Message-ID: <4FA06BA2.7020703@redhat.com>
Date: Tue, 01 May 2012 19:02:58 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au
Subject: Re: [Patch 3/4] ipc/mqueue: strengthen checks on mqueue creation
References: <1335894655-11398-1-git-send-email-dledford@redhat.com> <d280fa846e9093a3cc82d9e75da4bb8074c7d4c7.1335894230.git.dledford@redhat.com> <4FA04131.2040004@gmail.com> <4FA04373.6090100@redhat.com> <CAHGf_=p34t2jrqr1V_TP0UiXLE8g1p6UXOV25SwWC8C9h2BVBQ@mail.gmail.com>
In-Reply-To: <CAHGf_=p34t2jrqr1V_TP0UiXLE8g1p6UXOV25SwWC8C9h2BVBQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6AE6FC092B58C78556335A9D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6AE6FC092B58C78556335A9D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 5/1/2012 4:18 PM, KOSAKI Motohiro wrote:
>>> But ENOMEM is more inaccurate. It almostly is used for kmalloc failur=
e.
>>
>> I chose ENOMEM for that particular error because above there we have
>> checked the passed in arguments to make sure that they don't violate o=
ur
>> allowances for max message or max message size.  If we violate either =
of
>> those items, we return EINVAL.  In this case, neither of the values is=

>> invalid, it's just that together they make an overly large allocation.=

>> I would see that as more helpful to a programmer than EINVAL when the
>> values are within the maximums allowed.  At least with ENOMEM the
>> programmer knows they have to reduce their combined message size and
>> message count in order to get things working.
>=20
> Incorrect. When ENOMEM is returned, programmers can't know
> which problem was happen 1) kernel has real memory starvation
> or 2) queue limitation exceed was happen. The problem is, you
> introduced new overloaded error code for avoiding overload error code.
> It doesn't make sense. My question was, why can't you choose no
> overload error code if you want accurate one?

OK, then would EOVERFLOW suit things better?

All this reminds me that when this is taken into Linus' kernel, we need
to coordinate a man page update for the mq subsystem.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig6AE6FC092B58C78556335A9D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPoGuiAAoJELgmozMOVy/dH9kQAK4TAACQQxhSiTAuSNvY6hHZ
+PBZgMp/2fQPeaOJ61/0o/m4ugsECwBQpjQqLI+4/GJVF8ZFqGbmk/657Y6ewA+3
NEdvQWeyF9KSz2qKk1cB3QsCkoVF5zqBtP3cSiPmAVV4uKLRIkx6wGdJQb4P7tWx
WpfKZWGqV/TO4DEAPggy54Ukgg0YdZqrmSN5ZneeWsXvvG91Kr993NbTXW8ONBju
Fwtq42E/Hkaye5uEVvLZ517rjobFqn/sYGDc9mGZxOUO6Xud3vJuFNVs/Hs8JPW3
EoGwYF/6kkIOxt1C9JlQ0MCCds5Kqft4zrsQOnm5wmdbCPy9GNNhH/OI7Pul4Yck
4mSKQYAckYBcDSQ8TljdGgt+LANq9g5YD6PiOGcph95mtRF/3U/eZwS9flrrTLqf
vjmrtU1yv7TeqXoolXWHEw2pFCWMZjsnmnASxQ/D9vbCO36ox/UHGacskbwLoqOt
5vvCgJAdzTbMMl4jqN36Je0aPIfp+GZ3TTTBCzv6yTEtpmfaEEaxsc5C11uefrVH
6qY0DhBCctY9E0XJkDgSvcmyq+lO3DzFc+rEcb0fzCTbBnrj3o1Z1ykHOBjJf2+s
FAvBjE3gsl8gGJzj6HOp297ZGudu3jz7iNqnqIJJs4Xny5MhVpuctbIHgFDrQ9LI
uf/Qgtzwf666AurPbvqe
=4uBD
-----END PGP SIGNATURE-----

--------------enig6AE6FC092B58C78556335A9D--
