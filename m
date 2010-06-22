Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab0FVKxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:53:53 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:33268 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab0FVKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:53:51 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 06:53:51 EDT
Date: Tue, 22 Jun 2010 12:44:12 +0200
From: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>,
       Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
Message-ID: <20100622104412.GB9779@ethz.ch>
Mail-Followup-To: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
	Michal Marek <mmarek@suse.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
	Greg Thelen <gthelen@google.com>
References: <4C1764CD.3080402@suse.cz>
 <1276782038-23441-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <1276782038-23441-1-git-send-email-mmarek@suse.cz>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-rc2 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Michal Marek [Thu, Jun 17, 2010 at 03:40:38PM +0200]:
> Now that we run scripts/setlocalversion during every build, it makes
> sense to move all the localversion logic there. This cleans up the
> toplevel Makefile and also makes sure that the script is called only
> once in 'make prepare' (previously, it would be called every time due to
> a variable expansion in an ifneq statement). No user-visible change is
> intended, unless one runs the setlocalversion script directly.

Sounds good in general.

> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -10,73 +10,158 @@
>  #
> =20
>  usage() {
> -	echo "Usage: $0 [srctree]" >&2
> +	echo "Usage: $0 [--scm-only] [srctree]" >&2
>  	exit 1
>  }

If more stuff like this is coming, we should probably rewrite
option handling. No need to change right now, but to keep in mind.

> -cd "${1:-.}" || usage
> +scm_only=3Dfalse
> +srctree=3D.
> +if test "$1" =3D "--scm-only"; then
> +	scm_only=3Dtrue
> +	shift
> +fi
> +if test $# -gt 0; then
> +	srctree=3D$1

You probably want

srctree=3D"$1"=20

to catch spaces and co. in the path.

Otherwise I just had a quick view over it, but seems to look good.

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwgk/sACgkQ19zI5DGHffA5TgCdE7DiPzXSG5AaSzJZu9A676vI
pOsAoJaujDwClZDszlvY+jvyBkM51S8D
=Ouw8
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
