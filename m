Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2EUAfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 20:35:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab2EUAfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 20:35:16 -0400
Date: Mon, 21 May 2012 10:35:00 +1000
From: NeilBrown <neilb@suse.de>
To: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Q: enterprise-readiness of MD-RAID (md: kicking non-fresh dm-14
 from array!)
Message-ID: <20120521103500.152a70a6@notabene.brown>
In-Reply-To: <4FB3B9E4020000A100009C72@gwsmtp1.uni-regensburg.de>
References: <4FB3B9E4020000A100009C72@gwsmtp1.uni-regensburg.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KltQ9QNyhDfM3TJzhxaNh3e"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KltQ9QNyhDfM3TJzhxaNh3e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi,
 I'd just like to say up front that I don't think "enterprise" means anythi=
ng
 from a technical perspective.
 Maybe it means "more willing to spend on insurance" or "more bureaucracy
 here", but I don't think either of those are really relevant here.

 We all value our data, and we all want to minimise costs.  Different people
 will resolve the tension in different ways and buy different hardware, but
 md should work with all of them.

 So lets just talk about "data readiness" - is md ready for you to trust yo=
ur
 data to - whatever that data is.

On Wed, 16 May 2012 14:29:56 +0200 "Ulrich Windl"
<Ulrich.Windl@rz.uni-regensburg.de> wrote:

> Hi!
>=20
> I'm using disk mirroring with HP-UX and LVM in an enterprise environment =
for about 20 years. Not loo long ago I started to use disk mirroring with L=
inux and MD-RAID.
>=20
> Unfortunately I found a lot of bugs (e.g. mdadm being unable to setup the=
 correct bitmaps) and inefficiencies. Recently I found out that some of our=
 RAID1 are not mirrored any more, and even during boot the kernel does not =
even try to resynchronize them.
>=20

Did you report them?  Were they fixed?
Which release of linux and mdadm were you using?
There will always be bugs.  If you want to minimise bugs, your best bet is =
to
pay some distro that does more testing and stabilisation.

If your system is configured properly, then you should get email every day
when any array is not fully synchronised.


> The message reads to me like "I found out that one of the disks has obsol=
ete data on it; let's throw it out from the RAID". Naturally my expectation=
s were that the kernel would resynchronize the stale disk blocks.

You are misinterpreting the message.
What is really says is "This device looks like it was ejected from the arra=
y,
presumably because it reported an error.  I don't know if you want to trust=
 a
device that has produced errors so I'm not even going to try including it
into the array.  You might want to do something about that".

The "something" might "find out why it produced an error and fix it" or
"replace it" or "just add it anyway, I don't care if the disk is a bit dodg=
y".


>=20
> <6>[   15.248125] md: md0 stopped.=20
> <6>[   15.249075] md: bind<dm-14>=20
> <6>[   15.249290] md: bind<dm-16>=20
> <4>[   15.249409] md: kicking non-fresh dm-14 from array!=20
> <6>[   15.249525] md: unbind<dm-14>=20
> <6>[   15.293560] md: export_rdev(dm-14)=20
> <6>[   15.296317] md: raid1 personality registered for level 1=20
> <6>[   15.296814] raid1: raid set md0 active with 1 out of 2 mirrors=20
> <6>[   15.325348] md0: bitmap initialized from disk: read 8/8 pages, set =
97446 bits=20
> <6>[   15.325461] created bitmap (126 pages) for device md0=20
> <6>[   15.325781] md0: detected capacity change from 0 to 537944588288=20
>=20
> On another occasion we had the case that after a hard reset (from cluster=
) one of our biggest RAIDs (several hundred GB) was resynchronized fully, e=
ven though it had a bitmap. After a little reading I got the impression tha=
t MD-RAID1 always copies disk0 to disk1 if there are mismatches. My expecta=
tion was that the more recent disk would be copied to the outdated disk. No=
te that even if writes to both disks are issued to the queues simultaneousl=
y, it's not clear (especially with SAN storage and after a reset situation)=
 which of the disks got the write done first.

I am surprised that a full sync happened when a bitmap was present.  I would
need details to help you understand what actually happened and why.

You seem to be saying that you expect md/raid1 to copy the newer data even
though you know it is not possible to know which is the newer data. ....

There is a very common misunderstanding here.  Between the time when you st=
art
writing to a device and the time when that write reports that it is
complete, there is no "correct" or "best" value for the data in the target
block.  Both the old and the new are equally "good".  Any filesystem or oth=
er
client of the storage must be able to correctly handle either value being
returned by subsequent reads after a crash, and I believe they do.
There is no credible reason to prefer the "newer" data.


>=20
> My latest experience was with SLES11 SP1 which may not have the latest co=
de bits.

It is a little old, but not very.  It should be fairly stable.  If you have
problems with SLES11-SP1 and have a maintenance contract with SUSE, I sugge=
st
you log an issue.

>=20
> If anybody wants to share his/her wisdom on that (the enterpris-readyness=
 of MD-RAID, please reply to the CC: also as I'm not subscribed to the kern=
el list.

Yes, there are bugs from time to time, but if you manage your arrays sensib=
ly
and have regular alerts configured with "mdadm --monitor", all should be we=
ll.

>=20
> BTW: I had made some performance comparisons between our SAN storage ("ha=
rdware") and MD-RAID ("software") regarding RAID levels:
>=20
> hardware seq. read:  RAID0=3D100%, RAID1=3D67%, RAID5=3D71%, RAID6=3D72%
> hardware seq. write: RAID0=3D100%, RAID1=3D67%, RAID5=3D64%, RAID6=3D42%
>=20
> software seq. read:  RAID0=3D100%, RAID1=3D44%, RAID5=3D36%, RAID6=3Dnot =
done
> software seq. write: RAID0=3D100%, RAID1=3D48%, RAID5=3D19%, RAID6=3Dnot =
done
>=20
> Note: I was using two independent SAN storage units for the RAID1 tests; =
for the higher levels I had to reuse one of those SAN storage units.
>=20
> Measuring LVM overhead I found a penalty of 27% when reading, but a 48% b=
oot for writing. I never quite understood ;-)
> Comparing I/O schedulers "cfq" with "noop", I found that the latter impro=
ved throughput from about 10% to 25%.
>=20
> Now if you combine "cfq", MD-RAID5 and LVM, you'll see that Linux is very=
 effective when taking your performance away ;-)

cfq is probably not a good choice for a SAN.  noop is definitely best there.
RAID5 is obviously slower than native access, but also safer.
I cannot comment on LVM.

In summary: md works for many people.  If it does not work for you, I am
sorry.
If you have specific issues or question, I suggest you report them with
details and you may well get detailed answers.

NeilBrown


--Sig_/KltQ9QNyhDfM3TJzhxaNh3e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7mNtDnsnt1WYoG5AQJtTRAAo2wxziklGbc5fQYz0Eg4QhEPiV68KfmK
Kgn3nwEjOghR9o6hxvf0PKKxT28N8ojyEV/5r0C2BrbcEB793FIKJZSYY3zGlYWg
XqDjtyP9ZJyN7iFw3ZUuy217bckXrsrI8mBAvwfR/gvvSeUdaE2HZuSSkTnmNxdn
sDPX8eASs7QHIAXMe7MCyqD/epjS6Q7qemIy46bo20lfbNX2meG9KU64R+JnY2NM
om6/iPbZPzI1r9CyPK6CQ06ebfcfZrH6nwg5EsvzL82oK2DAio3bKWyxpBjFRjYV
6u9iiHqLeFFrAIffLbsrNgdPii+2AvdN1kOyGLZMO0gj4lsK07o5YI35q20jld3/
X9tQlCVHeV/UbHhiTlSRhqXFhci3MQ6A/6+/WeVpCrN5dVm9WFrRt6jFm0trH0BC
2Bo8RrMXYrxj51HJJWShAliSgVPURnkkPTri4XS3t74DYpVBpPyk7EMej1N9a831
nSIGXyhDYFVBISa/xfIX4EDhaDRXs+fWLDz8UTXPtacs4IPQ6E9VRE9lYBIvzQdW
wtocoxaxkZh8ZG4liBJm6Qcwf7/x+SJ+8FONmORWWa/11AOwtMn2tETRGkMbHYws
4CZrii/kSzjkukaMYg1udBPSDw54k8G6iH9CugKSrQ+kin7zqLqXGe3MPfILuux9
MT5nIvwiWpo=
=iYqL
-----END PGP SIGNATURE-----

--Sig_/KltQ9QNyhDfM3TJzhxaNh3e--
