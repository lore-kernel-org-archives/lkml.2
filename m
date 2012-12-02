Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2LBTxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 14:53:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2LBTw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 14:52:58 -0500
Date: Mon, 3 Dec 2012 06:52:45 +1100
From: NeilBrown <neilb@suse.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Hang in md-raid1 with 3.7-rcX
Message-ID: <20121203065245.4a95b386@notabene.brown>
In-Reply-To: <CAPVoSvTOQT65zYbz++jbbaT63VbVKchYdhip58R8S6cPxbW2cw@mail.gmail.com>
References: <CAPVoSvQNVnz=NrkNaZ4G_k76WuVaAJ24uEXkAyJvDNLHHPs1Kw@mail.gmail.com>
	<20121127120528.637099aa@notabene.brown>
	<CAPVoSvRssJSzjg1wZ8g9-05Y50xVkVcQqsnZ92Ru6mWZgGrfKg@mail.gmail.com>
	<CAPVoSvTOQT65zYbz++jbbaT63VbVKchYdhip58R8S6cPxbW2cw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZwU7=tGDnCJkgs=IZnX1zeW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZwU7=tGDnCJkgs=IZnX1zeW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Dec 2012 13:10:33 +0100 Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:

> On Tue, Nov 27, 2012 at 8:08 AM, Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
> > On Tue, Nov 27, 2012 at 2:05 AM, NeilBrown <neilb@suse.de> wrote:
> >> Can you test to see if this fixes it?
> >
> > Patch applied, I will try to get it stuck again.
> > I don't have a reliable reproducers, but if the problem persists I
> > will definitly report back here.
>=20
> With this patch I was not able to recreate the hang. Lacking an 100%
> way of recreating this, I can't be completely sure of the fix, but as
> you understood from the code how this hang could happen, I'm quite
> confident that the fix is working.
>=20
> (As I do not use the raid10 personality only patching raid1.c was
> sufficient for me, I didn't test the version that also patched
> raid10.c as its not even compiled on my kernel.)
>=20
> Thanks for the fix!

And thanks for testing!
Linus doesn't seem to have pulled in the fix yet, but hopefully it will be =
in
3.7.

NeilBrown

>=20
> Torsten
>=20
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index 636bae0..a0f7309 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, b=
ool from_schedule)
> >>         struct r1conf *conf =3D mddev->private;
> >>         struct bio *bio;
> >>
> >> -       if (from_schedule) {
> >> +       if (from_schedule || current->bio_list) {
> >>                 spin_lock_irq(&conf->device_lock);
> >>                 bio_list_merge(&conf->pending_bio_list, &plug->pending=
);
> >>                 conf->pending_count +=3D plug->pending_cnt;
> >>


--Sig_/ZwU7=tGDnCJkgs=IZnX1zeW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULuxjTnsnt1WYoG5AQLnyw/7BhVZpE23b7tYceA4c39Ul1iE3v7UXaKU
t922kfxSIugJWSbKzOBjDzzz222CZZT1vbEGn1MGoD/dE47VEMQBMsUJe6GERcM/
/UG9yo5dOtun6C4v1yPL6toE4yebIK0EBkB0DRc8UDCWjyyhtnZdGs1GD8ZC1MNg
w18+59I8/KZoNxHbAA8VvWJnxHHxmNn50wLLJl14mGnBKjG4anIKMMAbiDnzmxDA
ZeJgMo3Xj/FlBRcXG7r2XWp+pjcY8rdeNLrfcY6By6ATSn4DjOe84skCRUNSAHrB
aodVPfKMAOjas529If+Ckzy0/arP1ILmcWafzEy8MO5RYESWr43tvJvhMF8GSjHf
vQLg5yt6bYbieXtnNXvYMDcg8erirwaotTG6B55qX3YtEi8PQjYT55JOP1MjsddI
nWvq+MVaJL2PK7TNugLNxbCo2+mIp0UaaEoY4dJU+Oo6u8Zet84oqAEC09LHXtQK
KUxg3AfXZchmVN+dDiWfruGvRx6o/bfS9Dx1EwtTUjJkba55fQoS63PPf23gsza9
jBiHLBOfTDcIfK46TX2ecBRtVq9FUKRz14NIGDZTcgUAGdAR2l7CkEYbC1TmfPdr
7l6wBs5RsRvJEzOxyrhcLsQY8ztj4pYXb99hF3bWfMbpVRMQmKV7JAoepHoV8by3
naEYrLbDARg=
=rb27
-----END PGP SIGNATURE-----

--Sig_/ZwU7=tGDnCJkgs=IZnX1zeW--
