Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2JQCLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:11:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42279 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973Ab2JQCLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:11:18 -0400
Message-ID: <1350437407.26833.72.camel@deadeye.wl.decadent.org.uk>
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Oct 2012 02:30:07 +0100
In-Reply-To: <CA+1xoqcGN1xYP5-N17eZQ=F_JTG-8gr43DAxREa-Wf+n8=P7Og@mail.gmail.com>
References: <505E2108.2060108@gmail.com>
	 <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com>
	 <20121008172207.GB14767@quack.suse.cz>
	 <alpine.LNX.2.00.1210082340501.19980@pobox.suse.cz>
	 <507424F7.60801@gmail.com> <50742600.10606@gmail.com>
	 <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>
	 <CA+1xoqcGN1xYP5-N17eZQ=F_JTG-8gr43DAxREa-Wf+n8=P7Og@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5ByCAd5QYeEkLuoN8YtI"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5ByCAd5QYeEkLuoN8YtI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-10-12 at 13:55 -0400, Sasha Levin wrote:
> Hi Ben,
>=20
> On Wed, Oct 10, 2012 at 11:52 AM, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> > On Tue, 2012-10-09 at 09:26 -0400, Sasha Levin wrote:
> >> On 10/09/2012 09:21 AM, Sasha Levin wrote:
> >> > On 10/08/2012 05:45 PM, Jiri Kosina wrote:
> >> >> On Mon, 8 Oct 2012, Jan Kara wrote:
> >> >>
> >> >>>>>> I'm still seeing this on linux-next.
> >> >>>>   I think this is floppy related (see redo_fd_request() in the st=
ack
> >> >>>> trace). And there were quite some changes to the area recently. A=
dding
> >> >>>> maintainer to CC.
> >> >> Hmm ... I don't immediately see how this is happening.
> >> >>
> >> >> Sasha, could you please do git bisect on drivers/block/floppy.c bet=
ween
> >> >> f6365201d and your git HEAD for starters (assuming that f6365201d w=
orks
> >> >> well for you?).
> >> >>
> >> >
> >> > A bisect on floppy.c yielded the following:
> >> >
> >> > b33d002f4b6bae912463e5a66387c498aa69b6fe is the first bad commit
> >> > commit b33d002f4b6bae912463e5a66387c498aa69b6fe
> >> > Author: Ben Hutchings <ben@decadent.org.uk>
> >> > Date:   Mon Aug 27 20:56:53 2012 -0300
> >> >
> >> >     genhd: Make put_disk() safe for disks that have not been registe=
red
[...]
> > I see two problems:
> >
> > 1. redo_fd_request() races with tear-down of the disks, but because
> > set_next_request() checks disk->queue before doing anything this was
> > usually harmless.  Now that do_floppy_init() doesn't clear disk->queue,
> > the race condition is much easier to hit.  This may fix that problem in
> > do_floppy_init(), though there appear to be worse bugs in tear-down
> > order in floppy_module_exit():
[...]
> > 2. I made a big mistake in using the existing GENHD_FL_UP flag, as it i=
s
> > cleared by del_gendisk().  Incremental patch below, but it should be
> > squashed into the previous patch if that branch is still rebase-able.
[...]
> I'm now seeing these instead:
[...]

Sorry, I'm not going to spend more time in the quagmire of the floppy
driver.  Whoever has this commit in their tree, please revert or drop it
as appropriate.

Ben.

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-5ByCAd5QYeEkLuoN8YtI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUH4KH+e/yOyVhhEJAQofOBAAysk3YGoxGwrTJvNclHBGckpcRu/sqyKZ
jC4eIklN3o4xseB7xvjAUJUeWxoQPHwfq4S5cPc/5Mf5qbdnZO6ExQTgL0S04Ml2
5KeBFBtEgtjE4gJ2JLFLHn9eP44C3FoYicSPSB3zDZM+wctDHnPacG157cxR+7pj
AYhONN95aLdCcX2j2OxB0aR9joGITOGmG3ps6/yehqoDO4cDTiRJX5IwI08/ZdN1
7//AG5XYgBtNFD57E0tz8OZy/EbzSh+iIrnTF6Ok5eMc4RBpoxs1tpl7YzLWxnC6
raFtuzM/x8hrQV/GkXZ9uTyAs7b/gZFsivAdqJrVqiPnS9d2a3mbEOOklznN1RWH
IK9WNwTP8QhYVsfSUl+EGn6Mgb6bePF/2Obpneg9s4v7EXiIOENdJ16qW80vKJtR
Qc723RL+JnpfMvN1/dxz1SloKKk+PI5BG1MMWQvm15OV68p5+8nFCqZqDEQbM31g
0+9XauFkJWg3anAIj+mb40pSSckxmGH+B6SymQI8/SyNdfytilBztniDGO4wYhEN
UE1BW9afjSAS1RxuhtatKT+MsgsTKj8v+5v0sS46s3oLVxaDkmZtYRErKmxrjYNW
ne3E9fLUdCV4pjp3cOnS96W0NB6ZoUsWmIVl8Negv7B/ys/s0FrtTrbiLpfL43kN
nSqODInGipo=
=kNkh
-----END PGP SIGNATURE-----

--=-5ByCAd5QYeEkLuoN8YtI--
