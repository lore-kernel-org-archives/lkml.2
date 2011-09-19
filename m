Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1ISHQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 03:16:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1ISHQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 03:16:20 -0400
Date: Mon, 19 Sep 2011 17:16:06 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Dan Williams <dan.j.williams@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110919171606.3640c102@notabene.brown>
In-Reply-To: <CAC7rs0t_J+foaLZSuuw5BhpUAYfr-KY1iegFOxEBPCpbrkk1Dg@mail.gmail.com>
References: <20110910064531.GA32536@moria>
	<20110911081854.2958fdc8@notabene.brown>
	<20110911192259.GA3743@moria>
	<FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
	<20110912014407.GA5171@moria>
	<CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
	<CAC7rs0t_J+foaLZSuuw5BhpUAYfr-KY1iegFOxEBPCpbrkk1Dg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0RRRY8h6LfUw1EnYMQzkXR8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0RRRY8h6LfUw1EnYMQzkXR8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 14:33:36 -0700 Kent Overstreet
<kent.overstreet@gmail.com> wrote:

> On Thu, Sep 15, 2011 at 2:15 PM, Dan Williams <dan.j.williams@gmail.com> =
wrote:
> > On Sun, Sep 11, 2011 at 6:44 PM, Kent Overstreet
> > <kent.overstreet@gmail.com> wrote:
> >> On Sun, Sep 11, 2011 at 07:35:56PM -0600, Andreas Dilger wrote:
> >>> On 2011-09-11, at 1:23 PM, Kent Overstreet <kent.overstreet@gmail.com=
> wrote:
> >>> > I don't think that makes any more sense, as module paramaters AFAIK=
 are
> >>> > even more explicitly just a value you can stick in and pull out.
> >>> > /sys/fs/bcache/register is really more analagous to mount().
> >
> > ... and you looked at module_param_call()?
>=20
> Damn, nope. I still think a module parameter is even uglier than a
> sysfs file, though.

Beauty is in the eye of the beholder I guess.

>=20
> As far as I can tell, the linux kernel is really lacking any sort of
> coherent vision for how to make arbitrary interfaces available from
> the filesystem.

Cannot disagree with that.  Coherent vision isn't something that the kernel
community really values.

I think the best approach is always to find out how someone else already
achieved a similar goal.  Then either:
 1/ copy that
 2/ make a convincing argument why is it bad, and produce a better
    implementation which meets your needs and theirs.

i.e. perfect is not an option, better is good when convincing, but not-worse
is always acceptable.


>=20
> We all seem to agree that it's a worthwhile thing to do - nobody likes
> ioctls, /proc/sys has been around for ages; something visible and
> discoverable beats an ioctl or a weird special purpose system call any
> day.
>=20
> But until people can agree on - hell, even come up with a decent plan
> - for the right way to put interfaces in the filesystem, I'm not going
> to lose much sleep over it.
>=20
> >> I looked into that many months ago, spent quite a bit of time fighting
> >> with the dm code trying to get it to do what I wanted and... no. Never
> >> again
> >
> > Did you do a similar analysis of md? =A0I had a pet caching project that
> > had it's own sysfs interface registration system, and came to the
> > conclusion that it would have been better to have started with an MD
> > personality. =A0Especially when one of the legs of the cache is a
> > md-raid array it helps to keep all that assembly logic using the same
> > interface.
>=20
> I did spend some time looking at md, I don't really remember if I gave
> it a fair chance or if I found a critical flaw.
>=20
> I agree that an md personality ought to be a good fit but I don't
> think the current md code is ideal for what bcache wants to do. Much
> saner than dm, but I think it still suffers from the assumption that
> there's some easy mapping from superblocks to block devices, with
> bcache they really can't be tied together.

I don't understand what you mean there, even after reading bcache.txt.

Does not each block device have a unique superblock (created by make-bcache)
on it?  That should define a clear 1-to-1 mapping....

It isn't clear from the documentation what a 'cache set' is.  I think it is=
 a
set of related cache devices.  But how do they relate to backing devices?
Is it one backing device per cache set?  Or can it be several backing devic=
es
are all cached by one cache-set??
In any case it certainly could be modelled in md - and if the modelling were
not elegant (e.g. even device numbers for backing devices, odd device numbe=
rs
for cache devices) we could "fix" md to make it more elegant.

(Not that I'm necessarily advocating an md interface, but if I can understa=
nd
why you don't think md can work, then I might understand bcache better ....
or you might get to understand md better).


Do you have any benchmark numbers showing how wonderful this feature is in
practice?  Preferably some artificial workloads that show fantastic
improvement, some that show the worst result you can, and something that is
actually realistic (best case, worst case, real case).  Graphs are nice.

... I just checked http://bcache.evilpiepirate.org/ and there is one graph
there which does seem nice, but it doesn't tell me much (I don't know what a
Corsair Nova is).  And while bonnie certainly has some value, it mainly sho=
ws
you how fast bonnie can run.  Reporting the file size used and splitting out
the sequential and random, read and write speeds would help a lot.

Also I don't think the code belongs in /block.  The CRC64 code should go
in /lib and the rest should either be in /drivers/block or
possible /drivers/md (as it makes a single device out of 'multiple devices'.
Obviously that isn't urgent, but should be fixed before it can be considered
to be ready.

Is there some documentation on the format of the cache and the cache
replacement policy?  I couldn't easily find anything on your wiki.
Having that would make it much easier to review the code and to understand
pessimal workloads.


Thanks,
NeilBrown



>=20
> > And md supports assembling devices via sysfs without
> > requiring mdadm which is a nice feature.
>=20
> Didn't know that, I'll have to look at that. If nothing else
> consistency is good...
>=20
> > Also has the benefit of reusing the distro installation / boot
> > enabling for md devices which turned out to be a bit of work when
> > enabling external-metadata in md.
>=20
> Dunno what you mean about external metadata, but it would be nice to
> not have to do anything to userspace to boot from a bcache device. As
> is though it's only a couple lines of bash you have to drop in your
> initramfs.


--Sig_/0RRRY8h6LfUw1EnYMQzkXR8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOduw2G5fc6gV+Wb0RAm44AJ9lQ5U7T2iPUvjFcOGDLAfoS9zLxQCfV8yp
2AKmRJzOqEkgSiSysQG2npY=
=1r4f
-----END PGP SIGNATURE-----

--Sig_/0RRRY8h6LfUw1EnYMQzkXR8--
