Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1C3Ln0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:43:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1C3LnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OqpZKip5paBS0Ti0Xhafr67jpdKmaQx72oUHFZdIZfYQhSFbFsm+p+w6x35rih57PU
         ejB69BywwgjQhs8zr/LLPpDF5K9za2sjH4gpvLddTe3WzOSpEZkGbAuLZz8Xcy9MSqqC
         AzNUlbQAbK+8aJErEq5m/96PgK2KtzQ2RMhEY=
Date: Wed, 30 Mar 2011 14:49:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330114953.GA4080@swordfish.minsk.epam.com>
References: <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <4D9302ED.4030807@kernel.dk>
 <20110330112126.GA3967@swordfish.minsk.epam.com>
 <4D931292.8050104@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <4D931292.8050104@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (03/30/11 13:22), Jens Axboe wrote:
> > Nope, doesn't work for me. fsck.ext4 crashed the system.
> >=20
> > __elv_add_request
> > blk_flush_complete_seq
> > blk_insert_flush
> > __elv_add_request
> > __make_request
> > generic_make_request
> > ?bio_alloc_bioset
> > blkdev_issue_flush
> > blkdev_fsync
> > vfs_fsync
> > [..]
>=20
> Ah, this addon should behave better.
>

Seems to work fine for me.


	Sergey

=20
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 6a16fea..eba4a27 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -261,7 +261,7 @@ static bool blk_kick_flush(struct request_queue *q)
>  	q->flush_rq.end_io =3D flush_end_io;
> =20
>  	q->flush_pending_idx ^=3D 1;
> -	__elv_add_request(q, &q->flush_rq, ELEVATOR_INSERT_FLUSH);
> +	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
>  	return true;
>  }
> =20
>=20
> --=20
> Jens Axboe
>=20

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2TGOEACgkQfKHnntdSXjTgqQP/bLNnKiH0VPiUeSSu/beOPY52
MCItsvPdKpWZt4LILjbXt5dYnWiLyp2+eyY1jnuGqEvhqHjPVeUsOyhZBnQwW8zH
CVq24vdBvo1x9jRaxBdq6dMexpaydsEMmDc/RWxRjpdKMz238VWBagMfabRjZ4FK
mkqoPaxQjaHZSvLEsbY=
=HyaD
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
