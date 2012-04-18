Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2DROWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:22:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2DROWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:22:04 -0400
Message-ID: <4F8ECE09.3050700@redhat.com>
Date: Wed, 18 Apr 2012 10:22:01 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 2/8] ipc/mqueue: switch back to using non-max values on
 create
References: <cover.1334676645.git.dledford@redhat.com> <a9cfc656e665735e11606d452a536a9a9e6ebdde.1334676645.git.dledford@redhat.com> <20120417151729.e255188c.akpm@linux-foundation.org> <4F8DEF79.409@gmail.com> <20120417160055.f8e35101.akpm@linux-foundation.org>
In-Reply-To: <20120417160055.f8e35101.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig70B826BA4FCE0AE0AF7FC583"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig70B826BA4FCE0AE0AF7FC583
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 4/17/2012 7:00 PM, Andrew Morton wrote:
> On Tue, 17 Apr 2012 18:32:25 -0400
> KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
>=20
>>> Here the "future patch" is "mqueue: separate mqueue default value fro=
m
>>> maximum value v2" in this series, yes?
>>>
>>> So people who have applications which are broken by this patch will
>>> need to manually set /proc/sys/fs/mqueue/msg_default and/or
>>> /proc/sys/fs/mqueue/msgsize_default to get those apps working again?
>>>
>>
>> Yes, it works.
>>
>=20
> OK, I updated the changelog for this patch to reflect that.
>=20
> I worry a bit that some people who we don't know about will hit this
> problem and will have to spend a lot of time working out why it broke. =

> Is there some way in which we can make it easier for them?  A little
> printk_once() in a suitable place?

It might be doable, although rather tricky.  The deal is that we won't
know on mq_open if they really wanted a default sized mq or a max sized
mq.  And we wouldn't even know on send if they wanted default or max
sized mqs.  The best we could do is flag an mq as being a
no-attr-struct-used mq, then wait and see if they ever try to send too
many or too large of a message to that mq, and then we could do a
printk_once(), but we would almost need a printk_once_per_pid() because
they could have more than one app guilty of this behavior (if any are
guilty of it, something I doubt).  But even with all of this, we
wouldn't necessarily know that the app was intending to get a max sized
mq, it could simply be that the app expected a default sized mq but
tried to send an overly large message because it is a poorly coded app,
or it could have run out of space because the receiving app is blocked.
 So, we could print something out, but personally I'm not entirely
convinced that it's worth the extra lines of code in the kernel to make
it happen properly.  This problem, if it existed in the real world,
would be such poor programming practice that I'm having a hard time
imagining that it really exists.  For a simple, whip it up in 20 minutes
test program as part of a regression suite?  Sure, I can see that.  For
anything intended to be robust and reliable?  No, I can't see this bad
behavior being done there.  But, who knows, maybe I give programmers
writing real programs too much credit...


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig70B826BA4FCE0AE0AF7FC583
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPjs4JAAoJELgmozMOVy/d+PgP/iCsUM/w7chXTT4sMaEdFRoM
yIo13qt1OqWTx5UqM+h/9pVuxQWXVCfqR28ZLMVgUPl0Woubg0kpBOGzlU4O6WmN
eaAwImPfvd34E+Xeg4sPB0cJGQJcHrZ+OQVVEysOxvQqFcZF9sm9ZfR9D3XV/BXT
YaVIo4r3A7YbazilmB7CKqndDzSjtroVJHHUotiega5S2MlvTY6T7bTmOjVyEjfl
vugdNQmPeX0RcTzrSD43H7lVoWveXZsyxEco7Fop5R/uEpgUgyRBoVnbJ+8hsa9T
Zd0IQBGO6P2zfzpCvFDixoWXS+ruI/A06WTFns9AHE82hs60H0D2rtYpz0gAKS68
YJ1ChyVVn8kncOb057S8uSyLa96Dd8fOlIh44w6jCrSiXY7eitzNLdd1ICgqEBh6
gJrIobxGkeFpMKQd4q9Rwi0emL/H6Rjb3XSmfPWRvjX5h+Nv2UmFlaWPgFtxOzEi
1SxZwHZ7EvN0wf9RNxH+nruTkul5gfdu2kvluEPPSUx12DptVgbo06a6P/47vfjb
jm6FEBQymiiSvS4eM9P+AVuEHwS3BDHIbBQUI682w/R8GKfrQmMFFhRpTIGpHOQ6
/O/Nd9G8i436lw4usZYyjOnopLOUVftka3D+rOyDZQQwIpk0oJGAS2mQUdO/jqIZ
MELzmHCCRaVph6fzdaDb
=SS2k
-----END PGP SIGNATURE-----

--------------enig70B826BA4FCE0AE0AF7FC583--
