Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1ATP1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:27:17 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39544 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab1ATP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:27:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cDLZsSElPGwjR61kXDet2yURz4A1vaqz2kxoRZ/ANkRKvtjc0/5pbm7TJUiFuq3CCE
         8t4CCIccM+evrA1W6f/mPIHiECYcgnERaiO5tAYiqQOQ4IJly8lR/n/FJua8Cr2SwUi5
         AYXPnlc2V8KPzHrRSGLxoCxr6/YFEWVTvRSRY=
Date: Thu, 20 Jan 2011 17:18:22 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: queue_lock NULL pointer derefence in
 blk_throtl_exit (v2)
Message-ID: <20110120151738.GA4665@swordfish.minsk.epam.com>
References: <20110114192532.GA4274@swordfish>
 <20110120113211.GB16184@redhat.com>
 <20110120125849.GA4172@swordfish>
 <20110120143546.GA18875@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <20110120143546.GA18875@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (01/20/11 09:35), Vivek Goyal wrote:
> Hi Sergey,
>

Hi Vivek,

> Can we expand a little bit on comment that why do we need to have
> q->queue_lock initialized here now. Basically in the past nobody tried
> to take q->queue_lock in blk_cleanup_queue() path hence things just
> worked. Now blk throttling code is new and it takes q->queue_lock hence we
> run into issues. This could be true for some other future code too.
>=20
> Secondly currently blk throttle code seems to be the only user dependent
> on this lock initialization. So it might make sense to move this code
> closer to the actual call and blk_release_queue() might be even better
> place to do it atleast for now.
>=20

I'm afraid it's not safe to move NULL-check-and-fix out from blk_cleanup_qu=
eue,=20
since we're performing elevator_exit(q->elevator) call, which may depend on=
=20
q->queue_lock. For example, (./cfq-iosched.c: .elevator_exit_fn =3D cfq_exi=
t_queue)
cfq_exit_queue uses q->queue_lock.


	Sergey

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk04Uj4ACgkQfKHnntdSXjSsPwP/WpK329hy5zOoivCoh5tgR/ZW
0LZkXh5VhjdO3R1o3B2+bo4FOM/rSk8sO30UUDu02VYffQ0R94Ddqu4G/2rGgFnU
qz4HGXNcyIY25fsfBMIALHNxBgPToyVV1Q401D1KwtEtKi2e+Dy50P98gVmrJLXP
lTOEEEPN8xFvc/IAma0=
=K/qK
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
