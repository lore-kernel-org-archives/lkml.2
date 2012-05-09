Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2EIHUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:20:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2EIHUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:20:38 -0400
Date: Wed, 9 May 2012 17:20:22 +1000
From: NeilBrown <neilb@suse.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: [ 024/167] [PATCH] md: dont call ->add_disk unless there is
 good reason.
Message-ID: <20120509172022.73159017@notabene.brown>
In-Reply-To: <20120509065717.GB32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
	<20120509055032.897593072@decadent.org.uk>
	<20120509065717.GB32230@burratino>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Bjhc8ifjWGeErAKFJZ=b0mG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Bjhc8ifjWGeErAKFJZ=b0mG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 May 2012 01:57:17 -0500 Jonathan Nieder <jrnieder@gmail.com> wrot=
e:

> Hi,
>=20
> Ben Hutchings wrote:
>=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> [...]
> > commit ed209584c38fb74b7eecc03e5b1bfe674e591bd8 upstream.
> >
> > Commit 7bfec5f35c68121e7b18
> >
> >    md/raid5: If there is a spare and a want_replacement device, start r=
eplacement.
> >
> > cause md_check_recovery to call ->add_disk much more often.
> > Instead of only when the array is degraded, it is now called whenever
> > md_check_recovery finds anything useful to do, which includes
> > updating the metadata for clean<->dirty transition.
> > This causes unnecessary work, and causes info messages from ->add_disk
> > to be reported much too often.
>=20
> Does 3.2.y need this?  Commit 7bfec5f35c68121e7b18 (aka v3.3-rc3~3^2~22)
> does not seem to be part of the 3.2-stable tree.
>=20
> Jonathan

Thanks for checking!

Probably not needed then, but it wouldn't be harmful.

NeilBrown


>=20
> > So refine md_check_recovery to only do any actual recovery checking
> > (including ->add_disk) if MD_RECOVERY_NEEDED is set.
> >=20
> > This fix is suitable for 3.3.y:
> >=20
> > Reported-by: Jan Ceuleers <jan.ceuleers@computer.org>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/md/md.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index b572e1e..8beb19c 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7560,14 +7560,14 @@ void md_check_recovery(struct mddev *mddev)
> >  		 * any transients in the value of "sync_action".
> >  		 */
> >  		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> > -		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >  		/* Clear some bits that don't mean anything, but
> >  		 * might be left set
> >  		 */
> >  		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >  		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
> > =20
> > -		if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
> > +		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> > +		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
> >  			goto unlock;
> >  		/* no recovery is running.
> >  		 * remove any failed drives, then


--Sig_/Bjhc8ifjWGeErAKFJZ=b0mG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6oatjnsnt1WYoG5AQKI2xAAm99tIw9mc6dFmsZnEvxvQkRHxZoljohp
QgwpFuX7MEvBgX57V3MDgvtkuj14YsctLQ2XGPlBW2Y23STqW65opE3SiESr1snh
zuhuaiHBkmC1yqo7GfWt3vOTJET40WQUxQXiPxatR9jO+10c3t8FdxZPzNWBtJ/2
k9LMPCQRZjnI/pBOcwkjKjILthm0phOYEYh/KJo3QD58p5tA0nhdt7bNB070c6wA
dA3mKHoJlPcxv491DQfLvBJU1SlEs8HwBx8RnZ+KZCDl4e9KBNfzY44GlUq64B2O
/SziOv7Bn727FlMLzsivTjJFiZVvy4aLx5OrYgnpJw28OiQDd/ndc0WaPvSUZPl0
G3HWclg294vgRp+lr18B0d80CZW7z2vv9pB06Ghcpnhueulvmio57GLe6gX8rkwC
Yv3WGGlbA6nvci46n79z9y1MmXNzoWsSMdpcUA3nEhRGHq7kfnWUc0+75i7hm/TK
ilqh/we4jvb7tJCoCcv2Std9uMkzKTfKuj3xMcc2hpU/8E7mIYgXWYPi2YRtHuvL
2FYCw8aIetlDsclze6aeOIkOgekb5r7FqReDJo8F5UC8QSi2nQPaYiU8HzuilK6k
neto2iUlQz4k5gXPSQ1IqJC5Ic1cTtdAeUwhUUaiiXCP0E5/73R7skhgvYdOe0eC
PtmfxAIb1VA=
=Ue9t
-----END PGP SIGNATURE-----

--Sig_/Bjhc8ifjWGeErAKFJZ=b0mG--
