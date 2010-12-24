Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0LXBhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 20:37:40 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:59667 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0LXBhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 20:37:37 -0500
X-Spam-ASN: 
Date: Fri, 24 Dec 2010 04:37:26 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCHv7 16/16] pps: add parallel port PPS signal generator
Message-ID: <20101224043726.15042d0b@tornado.gnet>
In-Reply-To: <20101223163549.86a73ae8.akpm@linux-foundation.org>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<cover.1292844387.git.lasaine@lvk.cs.msu.su>
	<bbca0f7138c0814482a1d907833b7de1b7e70f25.1292844387.git.lasaine@lvk.cs.msu.su>
	<20101223163549.86a73ae8.akpm@linux-foundation.org>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/hW7CAywfzO/PhZbl5iTm6fL"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hW7CAywfzO/PhZbl5iTm6fL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Thu, 23 Dec 2010 16:35:49 -0800
Andrew Morton <akpm@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Mon, 20 Dec 2010 14:54:56 +0300
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > +	expire_time =3D ktime_to_timespec(timer->_expires);
>=20
> It's bad to play around with internal fields, especially when an
> accessor API was provided to access those fields.
>=20
> And lo, hrtimers got changed in linux-next:
>=20
> drivers/pps/generators/pps_gen_parport.c: In function 'hrtimer_event':
> drivers/pps/generators/pps_gen_parport.c:92: error: 'struct hrtimer'
> has no member named '_expires'
>=20
> The documentation in hrtimer.h is of course complete crap and
> Documentation/timers/hrtimers.txt appears to be bitrot, but with a
> little sleuthing and guesswork, it seems that what you want here is

Ah, cool, thanks for the fix!

> ---
> a/drivers/pps/generators/pps_gen_parport.c~pps-add-parallel-port-pps-sign=
al-generator-fix
> +++ a/drivers/pps/generators/pps_gen_parport.c @@ -82,7 +82,7 @@
> static enum hrtimer_restart hrtimer_even=20
>  	/* first of all we get the time stamp... */
>  	getnstimeofday(&ts1);
> -	expire_time =3D ktime_to_timespec(timer->_expires);
> +	expire_time =3D
> ktime_to_timespec(hrtimer_get_softexpires(timer)); dev =3D
> container_of(timer, struct pps_generator_pp, timer); lim =3D
> NSEC_PER_SEC - send_delay - dev->port_write_time;=20
> _
>=20


--=20
  Alexander

--Sig_/hW7CAywfzO/PhZbl5iTm6fL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNE/lWAAoJEElrwznyooJbg/sH/2MFvnzY/e4aCKpaujpPs1s/
LzKFzSTrm7sUB1VNDfyie97zxJDe4yxF3N3D0xENMLox729VkMj8WZt3JlaGHjNc
63oxInbtBUxD/8jSPWAhDyG2qZX/jxQiQFUKtG7v/ufulvLATcV8+eUZVCV0BwOd
IqEXwNx2DvwLmEhYIsPPP/z9nD6aJkrtg835MHOuiNQkK4RHu021aDP5ek4J9WSw
2CIxkdoHEZr8xJ/fGXaNRHAMQd6e74EauRzWx8gq6RaV420xepamssc8N5oKsurU
lqd+YBkwDH4VdLp7bh/TdgFjjLSYHmMWy3sRgPzafL95XmEr57ycl7YnPVvOrTY=
=kJRq
-----END PGP SIGNATURE-----

--Sig_/hW7CAywfzO/PhZbl5iTm6fL--
