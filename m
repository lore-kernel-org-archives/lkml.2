Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1HYSLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:11:32 -0400
Received: from 60.wheelsystems.com ([83.12.187.60]:58769 "EHLO
	mail.dawidek.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1HYSLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:11:30 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 14:11:30 EDT
Date: Thu, 25 Aug 2011 20:02:44 +0200
From: Pawel Jakub Dawidek <pjd@FreeBSD.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH 016/118] drbd: Add read_requests tree
Message-ID: <20110825180244.GA1697@garage.freebsd.pl>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
 <1314284934-17999-17-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1314284934-17999-17-git-send-email-philipp.reisner@linbit.com>
X-OS: FreeBSD 9.0-CURRENT amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 25, 2011 at 05:07:12PM +0200, Philipp Reisner wrote:
> From: Andreas Gruenbacher <agruen@linbit.com>
>=20
> We do not do collision detection for read requests, but we still need to
> look up the request objects when we receive a package over the network.
> Using the same data structure for read and write requests results in
> simpler code once the tl_hash and app_reads_hash tables are removed.
>=20
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> ---
>  drivers/block/drbd/drbd_int.h  |    1 +
>  drivers/block/drbd/drbd_main.c |    1 +
>  drivers/block/drbd/drbd_req.c  |   13 ++++++++++---
>  3 files changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index 0583713..fe15319 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -1020,6 +1020,7 @@ struct drbd_conf {
>  	unsigned int tl_hash_s;
> =20
>  	/* Interval tree of pending local write requests */
> +	struct rb_root read_requests;
>  	struct rb_root write_requests;

Looks like the comment needs updating.

--=20
Pawel Jakub Dawidek                       http://www.wheelsystems.com
FreeBSD committer                         http://www.FreeBSD.org
Am I Evil? Yes, I Am!                     http://yomoli.com

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (FreeBSD)

iEYEARECAAYFAk5WjkQACgkQForvXbEpPzTRQwCgoVpvZWs1optlG6OGKx1MzjkD
f6AAn0UGktKuJJ9tIGQMbQKfGOGgczax
=K5zD
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
