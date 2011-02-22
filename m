Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1BVOul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:50:41 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45882 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab1BVOue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eZGWt4Rd5rKQgWh4bhEX/2VPE0l1az0jXged/Csx7NUDJZjYYEfumHUrjdPki3XARt
         bu5Wvg5aBOZGUc1mEvPtBdPvyDWQXSJWVWm99mVY7pDSi12pBH1O3jjXekCT/rl5TWN4
         lGG9v+bKV/x+7v4Waa3Iwnve7QKkW6BvwVUpE=
Date: Tue, 22 Feb 2011 16:48:50 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, neilb@suse.de,
        tj@kernel.org, jmoyer@redhat.com, snitzer@redhat.com
Subject: Re: [PATCH 2/3] loop: No need to initialize ->queue_lock explicitly
 before calling blk_cleanup_queue()
Message-ID: <20110222144850.GB4759@swordfish.minsk.epam.com>
References: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
 <1298346817-26144-3-git-send-email-vgoyal@redhat.com>
 <20110222073032.GA4555@swordfish.minsk.epam.com>
 <20110222142050.GB28269@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20110222142050.GB28269@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (02/22/11 09:20), Vivek Goyal wrote:
> On Tue, Feb 22, 2011 at 09:30:32AM +0200, Sergey Senozhatsky wrote:
> > On (02/21/11 22:53), Vivek Goyal wrote:
> > > o Now we initialize ->queue_lock at queue allocation time so driver d=
oes
> > >   not have to worry about initializing it before calling blk_cleanup_=
queue().
> > >=20
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  drivers/block/loop.c |    3 ---
> > >  1 files changed, 0 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> > > index 49e6a54..44e18c0 100644
> > > --- a/drivers/block/loop.c
> > > +++ b/drivers/block/loop.c
> > > @@ -1641,9 +1641,6 @@ out:
> > > =20
> > >  static void loop_free(struct loop_device *lo)
> > >  {
> > > -	if (!lo->lo_queue->queue_lock)
> > > -		lo->lo_queue->queue_lock =3D &lo->lo_queue->__queue_lock;
> > > -
> > >  	blk_cleanup_queue(lo->lo_queue);
> > >  	put_disk(lo->lo_disk);
> > >  	list_del(&lo->lo_list);
> >=20
> > Hi,
> >=20
> > (just for note)=20
> > There is an incremental patch fixing this case in Andrew's mm tree:=20
> > https://lkml.org/lkml/2011/2/11/165
> >                                   =20
> > (block-fix-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v4.patch
> > added to -mm tree).
>=20
> Hi Sergey,
>=20
> Thinking more about it, initializing queue lock in blk_alloc_queue() seems
> to be even more cleaner to me instead of initializing it to internal lock
> during blk_cleanup_queue(). If others like the idea, then we can either
> ask Andrew to drop the patch or I can generate one on top of it.
>=20

Hi Vivek,

Sure, fixing the even probability of NULL queue_lock is better (correct/san=
e/etc.)=20
then fixing NULL queue_lock in `different places'. I'm presonally OK with d=
ropping=20
my patch.

By the way, I guess we should Cc stable when we decide which one [fix] will=
 land=20
on the mainline (taking in account that we're on -rc6 already).

Side Note: Need to check if .37 is affected (I suspect it is).


	Sergey

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1jzNIACgkQfKHnntdSXjTITwQAoZL0eVCPQnMRiRcHgZY2LoVZ
ZQ9CL+wrkbdNiFPp00lSV4nESRggrUTxq6zHnmZrXqPNruuFEnGE02BGYR4i+0nz
Ui5+rrsD5uzBXVG1Tu2DGORf3xnUIFkEfelzmX2M7R2Qt6V91Zay1TZ/tBdUOi9+
7X/8+UWhxYeyRNXak4g=
=NsGs
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
