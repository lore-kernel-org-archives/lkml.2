Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2IKGV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:21:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab2IKGV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:21:28 -0400
Date: Tue, 11 Sep 2012 16:21:20 +1000
From: NeilBrown <neilb@suse.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] raid: replace	list_for_each_continue_rcu with new
 interface
Message-ID: <20120911162120.5d5b5fe5@notabene.brown>
In-Reply-To: <504DA513.2060004@linux.vnet.ibm.com>
References: <502CB924.10200@linux.vnet.ibm.com>
	<502DC999.1040407@linux.vnet.ibm.com>
	<5036D00F.2040009@linux.vnet.ibm.com>
	<504DA513.2060004@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TRmX6W.G3B=JNyVdahCCN3/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TRmX6W.G3B=JNyVdahCCN3/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 16:30:11 +0800 Michael Wang <wangyun@linux.vnet.ibm.com>
wrote:

> On 08/24/2012 08:51 AM, Michael Wang wrote:
> > On 08/17/2012 12:33 PM, Michael Wang wrote:
> >> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> >>
> >> This patch replaces list_for_each_continue_rcu() with
> >> list_for_each_entry_continue_rcu() to save a few lines
> >> of code and allow removing list_for_each_continue_rcu().
> >>
> >=20
> > Hi, Neil
> >=20
> > Could I get some comments on this patch?
>=20
> Hi, Neil
>=20
> Could I get some comments?
>=20
> And please forgive and warn me if this patch has came to the wrong
> place...I get the address from get_maintainer.

Sorry, August was a bad month.

Yes, patch looks good.  Shall I include it in my tree, do you want to submit
them altogether through some rcu tree?
Either way is fine by me.  If you want to submit it through some other tree=
,=20
   Acked-by: NeilBrown <neilb@suse.de>

If not, it'll probably appear in my -next soonish.

Thanks,
NeilBrown


>=20
> Regards,
> Michael Wang
>=20
> >=20
> > Regards,
> > Michael Wang
> >=20
> >> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> >> ---
> >>  drivers/md/bitmap.c |    9 +++------
> >>  1 files changed, 3 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> >> index 15dbe03..b160828 100644
> >> --- a/drivers/md/bitmap.c
> >> +++ b/drivers/md/bitmap.c
> >> @@ -163,20 +163,17 @@ static struct md_rdev *next_active_rdev(struct m=
d_rdev *rdev, struct mddev *mdde
> >>  	 * As devices are only added or removed when raid_disk is < 0 and
> >>  	 * nr_pending is 0 and In_sync is clear, the entries we return will
> >>  	 * still be in the same position on the list when we re-enter
> >> -	 * list_for_each_continue_rcu.
> >> +	 * list_for_each_entry_continue_rcu.
> >>  	 */
> >> -	struct list_head *pos;
> >>  	rcu_read_lock();
> >>  	if (rdev =3D=3D NULL)
> >>  		/* start at the beginning */
> >> -		pos =3D &mddev->disks;
> >> +		rdev =3D list_entry_rcu(&mddev->disks, struct md_rdev, same_set);
> >>  	else {
> >>  		/* release the previous rdev and start from there. */
> >>  		rdev_dec_pending(rdev, mddev);
> >> -		pos =3D &rdev->same_set;
> >>  	}
> >> -	list_for_each_continue_rcu(pos, &mddev->disks) {
> >> -		rdev =3D list_entry(pos, struct md_rdev, same_set);
> >> +	list_for_each_entry_continue_rcu(rdev, &mddev->disks, same_set) {
> >>  		if (rdev->raid_disk >=3D 0 &&
> >>  		    !test_bit(Faulty, &rdev->flags)) {
> >>  			/* this is a usable devices */
> >>
> >=20


--Sig_/TRmX6W.G3B=JNyVdahCCN3/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE7YYDnsnt1WYoG5AQKumw//TuOKOjHzBQnZ/+YWNP3Yv4/Zmtzn5GZx
y+8xfkER5uAe/A9+F0Vsej8t9LOmiZXdaAwedqtbng/yrgjVze0fwF1uA3sJEHMh
5rpLleHlYcpLjqPHURPaa1GplEbfqENHQ9HRpUwnJ2WULJymri4r9ZFJp0bxYyhS
KnfRBVAQ6Hx3m6/La7HSSihg661NE0sYP5ELzddo/oZMK4MEQZv+xRjZk3vXm20L
F7TFUmebFg7e7Y0F4oiC6zMLhK9r2JttzzSXF3RD98ezDsMHeLNiRJUiDoGyP6wT
767s0KcCb+3uf/STVpgJaNr6tgfVVG8rDJqak/wbTXH+Tam8O7/xWiGDtl5TpQm8
1dHsNEayd9mDfiDKfaZKtDjvpXD0oy+i2SsO2svyfIb4lu4V2uDB1jK8WWOyQMS6
iiPN8Z7yCYqdPRdq3pYAQEC6K42O7GXRl1tq1KzpTZM1k17nSrKlRhOIwtbgAtqL
gEpCY2fKb39FxN8gf+wizYXctxqsLTBKbPDFmSab8hhJYNRp4MPtt6NS6vr5acVA
L8RiyTL0IPCTDTODwUUtia2v6vrpkCRs7bQ9zsIGtH4onaBaA4Z3UfKNrh7qTHnY
0Wq2FJX2Unk2590sfe5SQHmtPszv61m57fO5o+A4/3l5juYoPZsJNYp/cfQNC4gw
RupwgjqJoSU=
=5B5h
-----END PGP SIGNATURE-----

--Sig_/TRmX6W.G3B=JNyVdahCCN3/--
