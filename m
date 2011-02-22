Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1BVHgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:36:36 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:51907 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1BVHgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:36:35 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 02:36:35 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y70NAFIsc+2gxyrBRvCddsEA0fMWSbgpyEQ8Vc2T6eiCgGHIii4PK3eFyUB8b9ULTp
         x+DdbUSrpwZDMXA3/i17D2Q/48WEK754/aq58gNrNSiMtn2UEr2+0TDMHHQmhmn9mUcH
         jWW39b4u8vYOOxNnTY/LZsQ7kUFS4KiPlzbsI=
Date: Tue, 22 Feb 2011 09:30:32 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, neilb@suse.de,
        sergey.senozhatsky@gmail.com, tj@kernel.org, jmoyer@redhat.com,
        snitzer@redhat.com
Subject: Re: [PATCH 2/3] loop: No need to initialize ->queue_lock explicitly
 before calling blk_cleanup_queue()
Message-ID: <20110222073032.GA4555@swordfish.minsk.epam.com>
References: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
 <1298346817-26144-3-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1298346817-26144-3-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (02/21/11 22:53), Vivek Goyal wrote:
> o Now we initialize ->queue_lock at queue allocation time so driver does
>   not have to worry about initializing it before calling blk_cleanup_queu=
e().
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/block/loop.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 49e6a54..44e18c0 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1641,9 +1641,6 @@ out:
> =20
>  static void loop_free(struct loop_device *lo)
>  {
> -	if (!lo->lo_queue->queue_lock)
> -		lo->lo_queue->queue_lock =3D &lo->lo_queue->__queue_lock;
> -
>  	blk_cleanup_queue(lo->lo_queue);
>  	put_disk(lo->lo_disk);
>  	list_del(&lo->lo_list);

Hi,

(just for note)=20
There is an incremental patch fixing this case in Andrew's mm tree:=20
https://lkml.org/lkml/2011/2/11/165
                                  =20
(block-fix-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v4.patch
added to -mm tree).


        Sergey

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1jZhgACgkQfKHnntdSXjRTGQP/bxoaekP/dFMheWFtLB2bWbao
twIXyRXK3/k260fY9jvb13nJ+KZo4u1/qlm0OCW/NOrim1IeB52GEOdpfmNHcWr4
dWopMOCGDceGNXzf5jFWs471yx2dOVBsZaqwHF+IzBJJ3fDd5GMfBj5IRsdtYR52
9xF2W2KX3qJAdLGms8Q=
=rwsR
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
