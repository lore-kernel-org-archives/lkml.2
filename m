Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136Ab2EIUl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:41:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59472 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761087Ab2EIUlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:41:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: ptrace.2: PTRACE_KILL needs a stopped process too
Date: Wed, 9 May 2012 12:41:56 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc6; KDE/4.6.5; x86_64; ; )
Cc: Pedro Alves <palves@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        pacman@kosh.dhis.org, "linux-man" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
References: <20091216004533.22261.qmail@kosh.dhis.org> <4FAAC706.6000808@redhat.com> <20120509201219.GA32051@redhat.com>
In-Reply-To: <20120509201219.GA32051@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8470889.9A0qnNokt4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201205091241.59060.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8470889.9A0qnNokt4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 09 May 2012 16:12:19 Oleg Nesterov wrote:
> On 05/09, Pedro Alves wrote:
> > On 05/09/2012 04:09 PM, Mike Frysinger wrote:
> > > probably not that big of a deal, but the reason i like using
> > > ptrace(PTRACE_KILL) over a raw kill() is that you are less likely to
> > > kill the wrong process by accident.  maybe not that big of a deal in
> > > practice though.
> >=20
> > And you can do tgkill instead.  It was specifically invented to handle
> > the reuse case.
>=20
> tgkill() can kill the wrong process/thread too, although it lessens the
> risk.
>=20
> But I don't really understand the problem. The traced thread can't go away
> until the tracer does wait/detach, and thus its pid can't be reused?

or the process has received a SIGKILL for some reason

> May be, "by accident" above means something else, not pid reuse...

i like to assume that my code isn't going to be bug free, so the more=20
mechanisms i have in place to protect innocent bystanders the better :)
=2Dmike

--nextPart8470889.9A0qnNokt4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPqp5WAAoJEEFjO5/oN/WBhZQP/RO5BUC6Q6vHq1364xcEGuk1
y7Hrf90DHufw3s47HXXp3eujHEaPwLwV+Jjpn5RNP9aGpKk2Y+7Upe6fDt3MM0YD
tj9mdkIuFQz3AEyxRN6eiDyNRw9TVVE4YfIJfbZT+gbiEezt01AnTcTT5BDmPEGs
kDgeE36F2M7XQiXchx7d3mr25YE6lV+3QcWzgLIoSLUdRaA156Rh4hvtZ8NMq8+4
Z3eC4j0wwHg3sexg+CAHGkrArpAqY+ebn1N8I5ETYYOutDF2tFW02u5gtEkWd6l9
59mmQKp2YKmjLvTA4n9VPjrbyBGbiA6jyPRjFemciJrVB+rRyDw/N7hoFeQkEdDB
uxdH+J9DJNS/3p0UzxMYkmb77Aalz4ZBpnWeb7wVGuLTrXbTL5dWaa367L+ulIK4
U/yXQoe2GjKgRy6Iby3/BB4DGTL74AUUzkTN6fDG5XGX5q+18B8GQgfSxsh6/SKi
oOHW2yhzmu6jveRmSsJlh5kPuuC4MN+oxn1WzMdwqgNxJliJwbaz9+3diGVJi0iN
GNORREDLmKLU6+gZX4T92CIBtRAMxhrw9J4/VhkpZ536Kn43EtXaErp/bokOrK3g
Az+dVF34k2AKZNyXHrfWXYhMUb79vflYcKw+XX0pgC3GVgN8OfqfNUv6kuJIB5vw
1ydLmzzd41DQJjDYHbkP
=2LGv
-----END PGP SIGNATURE-----

--nextPart8470889.9A0qnNokt4--
