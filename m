Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2GCXlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:41:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab2GCXli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:41:38 -0400
Date: Wed, 4 Jul 2012 09:41:33 +1000
From: NeilBrown <neilb@suse.de>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: md: fix up plugging (again). breaks build of the latest 3.5rc5+
Message-ID: <20120704094133.3f58fcf1@notabene.brown>
In-Reply-To: <4FF36732.3060306@mni.thm.de>
References: <4FF36732.3060306@mni.thm.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0piDZB9NJ=5QaNG9.Bjhz5f"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0piDZB9NJ=5QaNG9.Bjhz5f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Jul 2012 23:42:10 +0200 Tobias Klausmann
<tobias.johannes.klausmann@mni.thm.de> wrote:

> Proposing this patch:
>=20
> >From c6ac2740ed916ccf5b6fec0682101dd7a6a50f9f Mon Sep 17 00:00:00 2001
> From: Tobias Klausmann <tobias.klausmann@mni.thm.de>
> Date: Tue, 3 Jul 2012 23:03:43 +0200
> Subject: [PATCH] Fix patch md: fix up plugging again. Commit
>  b357f04a67c2aeee828b240863cd3f21d6cb3179
>=20
> ---
>  drivers/md/raid10.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index acf5a82..8da6282 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1394,7 +1394,7 @@ retry_write:
>  		bio_list_add(&conf->pending_bio_list, mbio);
>  		conf->pending_count++;
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		if (!mddev_check_plugged(mddev, 0, 0))
> +		if (!mddev_check_plugged(mddev))
>  			md_wakeup_thread(mddev->thread);
>=20
>  		if (!r10_bio->devs[i].repl_bio)

Thanks.  That was careless.
I've posted a pull request so Linus can take either that or this.

Thanks,
NeilBrown

--Sig_/0piDZB9NJ=5QaNG9.Bjhz5f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/ODLTnsnt1WYoG5AQKAJg//bqij+WNCblX6Y55MxrbCMM+bgJ0y1ATe
R1BUSqsLdwrZ5mqy6k2FXbtCE5h3sWrEDvCVQ3knV8ENjC0o0McafT+19jH65Ldc
Hj5Relka79CBfMVR5CxUU5Rx+1InMzjDRR9fX9z5zbsqBGjqmksZ9Bbv+L0T2Dzq
doc4SYGvXjRovyu+pq1zYnULGD+GlM92uZtdYan7JHjcf+qzDHYoqDKcdCMLbBUy
r+WmP/Xqo6o6sYdVGVzvmd7gCbHogPAm+9tJoS6wUSTRfveUQxT3u+58UqW3Q/Cm
jeruBx/mjfmZ20jmGSv41/IvPQDmtgW2+wQE7bg8NTMsCS8O3kiQ0m/dBJ2grO9O
Y2ia6VSelAgeZ50WHKHqtOwa2YlylOjDtXdibTEL88xJn7YO0c48ieDtEEFYkfEL
dwxBvmvtr4mzog5epIJ/uaMyTUd8vD9FklV8NRwXwxgR5XS5YwsK86xwLI0oto7P
B2IhhSp7ida45pQmlMD6amuxZ4yf1XRtLMgUEgpmbYE9Yt6ehhCUR/k2aWe6xovB
2MnW7Wuh/NSgyXNemn5GpYOeTbfpYaOfXER2jHDXHCfXDHMLYp/vQfb1cj/7CQ95
Q62P+ny8R+VnvSssyb9eGs5OBGjES0YH88pvwwqEOh5Cas1v9i6TFz0D1ccLa5Ns
pTq53JaRRmo=
=oG/z
-----END PGP SIGNATURE-----

--Sig_/0piDZB9NJ=5QaNG9.Bjhz5f--
