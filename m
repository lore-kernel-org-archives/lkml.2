Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0FOP1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:27:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63311 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab0FOP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GvN5PO/64mFwIfuYeWVAgIhBGhgsDfbMG1snupuuQO7EaS3O3Bw6Dn0bHAun8ZHbi9
         78SaGV7Pq65KcvhAi6tGI1wxQoz41hSfhSmMTi2UVvwUNCrwKUhGeV7eJ3/l5u1p5bIj
         8qqi1d8a+UlLyyhVzu2wS3/9HduGMIsTYhJTE=
Date: Tue, 15 Jun 2010 18:31:16 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid using smp_processor_id() in preemptible code
 (nr_iowait_cpu)
Message-ID: <20100615153116.GD3967@swordfish.minsk.epam.com>
References: <20100614073853.6fa2f91f@infradead.org>
 <20100614145439.GA3448@swordfish.minsk.epam.com>
 <20100614080154.7d6a71fc@infradead.org>
 <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
 <20100615061927.GA3312@swordfish>
 <20100615072435.5a47d850@infradead.org>
 <20100615145029.GB3967@swordfish.minsk.epam.com>
 <20100615080808.6286448b@infradead.org>
 <20100615152315.GC3967@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20100615152315.GC3967@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/15/10 18:23), Sergey Senozhatsky wrote:
>....
> 		delta =3D ktime_sub(now, ts->idle_entrytime);
> 		ts->idle_sleeptime =3D ktime_add(ts->idle_sleeptime, delta);
> 		if (nr_iowait_cpu(cpu) > 0)
> 			ts->iowait_sleeptime =3D ktime_add(ts->iowait_sleeptime, delta);
> 		put_cpu();
> 		ts->idle_entrytime =3D now;
> +		ts->idle_active =3D 0;
		^^^^^^

This part is wrong. Sorry.

> 	}
>=20
> 	if (last_update_time)
> 		*last_update_time =3D ktime_to_us(now);
>=20
> }

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwXnMQACgkQfKHnntdSXjTbJAP9FTB6CT50/t/LDi/hUm7MRgnp
wceeao0fxngX9Hx4bwMQWqVmpMLNbTwd7reD1AnIlkXvlCeNL6ufCNljbPLHNc6O
iXOVyUyb/SAwHLN7rTwaK8GeHLRV8u/3px6z+NR8VAJ3jE3N7Nc+7uDgXvAkMVJP
puEXYuUZKnJJy+zp14I=
=a4GJ
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
