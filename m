Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2LJOlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:41:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41123 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2LJOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:41:47 -0500
Date: Mon, 10 Dec 2012 16:34:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: "'Joel Becker'" <jlbec@evilplan.org>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Michal Nazarewicz'" <mina86@mina86.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
Message-ID: <20121210143416.GF11038@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50B39921.6090308@linutronix.de>
 <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
 <50B4E364.8030704@linutronix.de>
 <xa1tip8ruia5.fsf@mina86.com>
 <50B5C821.4000406@linutronix.de>
 <xa1ta9u1naik.fsf@mina86.com>
 <50B61695.50207@linutronix.de>
 <20121207231828.GM22789@localhost>
 <001401cdd6cd$788defa0$69a9cee0$%p@samsung.com>
 <000001cdd6e1$1ac24f60$5046ee20$%p@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8TaQrIeukR7mmbKf"
Content-Disposition: inline
In-Reply-To: <000001cdd6e1$1ac24f60$5046ee20$%p@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8TaQrIeukR7mmbKf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 10, 2012 at 03:17:34PM +0100, Andrzej Pietrasiewicz wrote:
> @Joel in particular: please see my comment in the bottom.
>=20
> On Monday, December 10, 2012 12:57 PM I wrote:
> > Subject: RE: [RFC][PATCH] fs: configfs: programmatically create config
> > groups
> >=20
> > Hello Joel,
> >=20
> > So you are alive, I'm glad to hear from you ;) Thank you for your
> response.
> >=20
> > On Saturday, December 08, 2012 12:18 AM Joel Becker wrote:
> > > Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config
> > > groups
> > >
> > > Hey Guys,
> > > 	Sorry I missed this for a while.  I'll make a couple of inline
> > > comments, and then I'll summarize my (incomplete) thoughts at the
> bottom.
> > >
> > > On Wed, Nov 28, 2012 at 02:50:13PM +0100, Sebastian Andrzej Siewior
> > wrote:
> > > > On 11/28/2012 02:05 PM, Michal Nazarewicz wrote:
> > > > >>On 11/27/2012 05:23 PM, Michal Nazarewicz wrote:
> > > > >>>How should a generic tool know what kind of actions are needed f=
or
> > > > >>>given function to be removed?  If you ask me, there should be a =
way
> > > > >>>to unbind gadget and unload all modules without any specific
> > > > >>>knowledge of the functions.  If there is no such mechanism, then
> > > > >>>it's a bad user interface.
> > >
> > > 	Please remember that configfs is not a "user" interface, it's a
> > > userspace<->kernelspace interface.  Like sysfs, it's not required to =
be
> > > convenient for someone at a bash prompt.  My goal is that it is *usab=
le*
> > > from a bash prompt.  So it must be that you can create/destroy/config=
ure
> > > objects via mkdir/rmkdir/cat/echo, but you might have a lot of those
> > > mkdir/echo combos to configure something.
> > > When it comes to the "user" interface, a wrapper script or library
> > should
> > > be converting a user intention into all that boilerplate.
> > >
> >=20
> > If you say so there is little we can do, is there? :O
> >=20
> > <snip>
> >=20
> > >
> > > 	Yeah, user tools are expected (and should be).
> > >
> >=20
> > ditto
> >=20
> > > > Anyway, for this to work we have to go through Joel.
> > > >
> > > > >	rmdir udcs/*		# unload all UDCs
> > > >
> > > > No, for this you still have to rmmod :)
> > > >
> > > >
> > > > >>>I think the question is of information flow direction.  If user
> > > > >>>gives some information to the kernel, she should be the one
> > > > >>>creating any necessary directories.  But if the information comes
> > > > >>>from kernel to the user, the kernel should create the structure.
> > >
> > > 	This last paragraph actually describes the distinction between
> > > configfs and sysfs.  More specifically, if userspace wants to create =
an
> > > object in the kernel, it should use configfs.  If the kernel has crea=
ted
> > > an object on its own, it exposes it via sysfs.  It is a deliberate no=
n-
> > > goal for configfs to replicate sysfs behavior.
> >=20
> > So if the lifetime of some object is controlled by the user, it belongs
> > to configfs. If, on the other hand, the lifetime is controlled by the
> > kernel, it belongs to sysfs. I think that the trouble with e.g. luns
> > is that they might want to behave like both (at least in the "more
> > automated"
> > approach where they are programmatically created): they are created
> > by the kernel (=3D> sysfs) but their lifetime is controlled by the user
> > (=3D>configfs).
> >=20
> > >
> > > [General Thoughts]
> > >
> > > 	First let me restate your problem to see if I understand it.
> > > 	You want to expose e.g. five LUNs.  They should eventually appear in
> > > configfs as five items to configure (.../{lun0,lun1,...lun4}/.  The
> > > current configfs way to do this is to have your setup script do:
> > >
> > > 	cd /cfg/.../mass_storage
> > > 	mkdir lun0
> > > 	echo blah >lun0/attr1
> > > 	echo blahh >lun0/attr2
> > > 	mkdir lun1
> > > 	echo blag >lun1/attr1
> > > 	echo blagg >lun1/attr1
> > > 	...
> > >
> > > I think the primary concern expressed by Andrzej is that a random user
> > > could come along and say "mkdir lun8", even though the gadget cannot
> > > support it.  A secondary concern from Michal is that userspace has to
> > run
> > > all of those mkdirs.  The thread has described varying solutions.
> > > 	If these original directories were default_groups, you could
> > > disallow any child creation and not require the setup script to create
> > > directories.  Here I will point out that you *can* create default_gro=
ups
> > > programmatically.  The default_groups pointer on each configfs_group =
can
> > > be different.  ->make_group() can attach whatever groups it wants.
> > > If this would work, it would fit both of your concerns, but you do not
> > > have a priori knowledge of the LUN count.
> > > 	Your original email proposed that the max lun be set like so:
> > >
> > > 	cd /cfg/.../mass_storage
> > > 	echo 5 >luns_allowed
> > >
> > > There are then a couple of proposed ways to enforce the limit.  Your
> > > ->create_group() idea wants luns_allowed to be able to create subdirs=
 in
> > > the ->store() function.  No ->mkdir() is provided, so a lunN cannot be
> > > created by hand.
> > > 	The ->create_group() idea has three challenges.  First, it creates
> > > "default" groups *after* the object is created.  This makes no sense =
if
> > > they are attributes of the toplevel object.  Second, it volates the
> > > configfs mantra that user-generated objects are explicitly created.
> > > The kicker, however, is the technical problem.  configfs explicitly
> > > forbids tree changes inside attribute operations for deadlock reasons.
> > > Trying to create new tree parts in luns_allowed->store() is exactly
> that.
> > > 	Another suggestion (I think I read this in the thread) would be to
> > > have ->mkdir() function parse the name and check that it is lunN, whe=
re
> > N
> > > is less than the limit.  I think that this was shot down because of
> > > parsing the LUN name.  I don't think that's too terrible, but there's
> > > certainly room for argument.
> > >
> > > [Possible Solutions]
> > >
> > > 	Before coming back to the proposed patch, let's look at what I might
> > > do if I were fitting this into configfs.
> > > 	I would actually do what I described at first:
> > >
> > > 	cd /cfg/.../mass_storage
> > > 	mkdir lun0
> > > 	echo blah >lun0/attr1
> > > 	...
> > >
> > > This is idiomatic configfs usage.  Sebastian noted this earlier in the
> > > thread.  Michal thought the repeated mkdirs were a problem ("I think
> > > that's suboptimal, and we can do better").  This is Michal's objection
> > to
> > > making the user do work.  This is where I point out we are not design=
ing
> > > configfs interfaces for ease of end-user use.  We're defining them for
> > > transparent and discoverable interfaces for tools to create things in
> > the
> > > kernel.  So the repeated mkdir()s are actually a good thing from my
> > > perspective; userspace is telling the kernel to create LUN objects.
> > > 	But this doesn't alleviate Andrzej's primary concern, nor does it
> > > answer Michal's concerns about corner cases.  Let's see if we can sol=
ve
> > > those.
> > > 	First, what about preventing extraneous LUNs?  There are two
> > > approaches: the prevent approach, and the ignore approach.  In the
> > Target
> > > module, they take the ignore approach.  If you create a LUN that is
> > > outside the scope, they just ignore it.  So a user can make 10 LUNs, =
but
> > > if only five are allowed, the other five are ignored.  In the prevent
> > > approach, we try to fail the mkdir() when we go over the limit.
> >=20
> > I think I like the prevent approach better, because I don't know what to
> > do with the unused luns in the ignore approach. I also think that it wo=
uld
> > be nice if configfs described the actual state of the system instead of
> > presenting all the possible user-created garbage (i.e. something which =
is
> > ignored).
> >=20
> > > 	So you've set a limit with "echo 5 >luns_allowed".  How do you
> > > restrict?  If you don't care about contiguous LUN numbering, you could
> > > literally do this in your make_group():
> > >
> > > 	if (count_luns(parent) >=3D parent->luns_allowed)
> > > 		return -ENOSPC;
> > >
> > > Note that we don't check the LUN number; SCSI does not require
> > contiguous
> > > numbering.  It does require LUN 0, which should probably be a default
> > > group.  So your lun count starts at 1.
> > > 	What if you decide you really want contiguous LUN numbers, which is
> > > considered nice to have?  Then we get to Michal's concern about parsi=
ng
> > > the name.  If you "mkdir lun1", the code has to confirm that it
> > > a) starts with "lun", b) finishes with a parsable number, c) that num=
ber
> > > is < luns_allowed.
> > > 	But you need to do the parsing anyway!  If the LUN is created via
> > > mkdir(), somehow the gadget system needs to know what LUN number to
> > > advertise.  I would actually decouple it from the name.  The name sho=
uld
> > > be free-form; if it happens to be comprehensible, that's good.  Imagi=
ne
> > > this:
> > > 	cd /cfg/.../mass_storage
> > > 	echo 4 >max_lun_id
> > > 	mkdir lun100
> > > 	echo 1 >lun100/lun_id
> > >
> > > The LUN actually has the ID of 1.  The fact that the directory name is
> > > wrong is irrelevant to the gadget processing; non-hackers use the
> > tooling,
> > > and the tooling should  make sane names.  Then your
> > > ->make_group() function can choose either approach to avoiding LUN IDs
> > > that are too large.  It can prevent:
> > >
> > > 	lun_id->store() {
> > > 		if (lun_id_exists(parent, value))
> > > 			return ERR_PTR(-EINVAL);
> > > 		if (value > parent->max_lun_id)
> > > 			return ERR_PTR(-ENOSPC) /* or EINVAL */
> > > 		setup_lun();
> > > 		make_live();
> > > 	}
> > >
> > > Or it can ignore:
> > >
> > > 	lun_id->store() {
> > > 		if (lun_id_exists(parent, value))
> > > 			return ERR_PTR(-EINVAL);
> > > 		if (value <=3D parent->max_lun_id) {
> > > 			setup_lun();
> > > 			make_live();
> > > 		}
> > > 		/* Do nothing for the ignored sucker */
> > > 	}
> > >
> > > 	I think that I, personally, would go with this <name>/lun_id scheme.
> > > Given a requirement for contiguous LUNs and the max_lun_id restrictio=
n,
> > > I'd go with the "prevent" option myself.
> >=20
> > Taking into account what you say about the expected userspace tooling
> > using a free-form name plus the lun_id attribute could be attractive,
> > because the lun_id attribute's value can be analyzed at ->store() and,
> > if it doesn't fit, an appropriate error can be easily returned using
> > just what we already have in configfs. Prevent seems better to me, too.
> >=20
> > > 	But is max LUNs a requirement?  Why not just have the LUN count be
> > > the number of LUNs created?  In that case, you can allow or disallow
> > > discontiguous LUN IDs without worrying about a max ID.
> > >
> >=20
> > I am not sure, but I think that Michal would say that he wouldn't like
> > things to change once the gadget is up and running, so the number of
> > luns should be fixed up front. On the other hand, after the gadget is
> > set up, we can fail in ->make_group() to prevent the user from creating
> > additional luns with which we don't know what to do. So what you suggest
> > seems fine, but I would ask Michal to be on a safe side.
> >=20
> > > [Really Hate Mkdir]
> > >
> > > 	If you considered it appropriate for the LUN objects to be created
> > > by the kernel, the standard way would to have "echo 5 >luns_allowed"
> > > create LUN objects in sysfs.  Yes, sysfs.
> > > There's no reason you can't have things in configfs *and* sysfs.  My
> > > understanding of your code says to me that the mkdir approach is the =
way
> > > to go, but if you hate it, this works.
> > >
> >=20
> > I guess you are right, but see my point about luns' lifetime being
> > controlled by the user and their creation being performed by the kernel.
> >=20
> > > [What About the Patch?]
> > >
> > > 	In general, attribute setting that turns into created configfs
> > > objects is against the theory of configfs.
> >=20
> > This looks like an authoritative answer.
> >=20
> > > In practice, it's a nightmare
> > > locking change.  Coming into this discussion, I though you were doing
> > > dymanic things at ->make_group() time, but that is already supported.
> > > 	But I want to hear your thoughts.  I've dumped a bunch of alternate
> > > approaches here.  Do any seem to fit?  What other challenges do you s=
ee?
> > >
> > > Joel
> > >
> >=20
> > Once upon a time, Felipe expressed interest in having the information
> > about endpoints and interfaces (mostly read-only stuff, but not all of =
it)
> > accessible in the gadget subsystem in configfs. This kind of information
> > is fully available only after the gadget has been bound, that is, after
> > the user created all the groups/items and filled all the attributes
> > and told the gadget to start (with e.g. filling some attribute or
> > creating a symlink). So this looks like a programmatic creation of
> > configfs directories. On the other hand, Felipe wanted it for debugging
> > purposes, so the user could just as well create the required directories
> > by hand when they need to, as Sebastian once suggested. Again, this
> > requires
> > ->make_group() to fail if all the information is not available yet.
> > But isn't it kind of similar to the luns' case? It is a bunch of objects
> > whose lifetime is controlled by the user (bind the gadget, unbind the
> > gadget),
> > but which are created by the kernel.
> > Another problem with this is that the user must at some point _guess_
> > what name to use in mkdir. Example:
> >=20
> > For each interface there should be a folder. So the user must know how
> > many
> > interfaces' folders to create and how to name them, like:
> >=20
> > $ mkdir ...../some_usb_function/interface00
> > $ mkdir ...../some_usb_function/interface01
> > ...
> > ...
> > ...
> >=20
> > In each interface folder, there should be some endpoint folders and the
> > user
> > must know how many endpoints there are and how to name them:
> >=20
> > $ mkdir ...../some_usb_function/interface00/endpoint02
> > $ mkdir ...../some_usb_function/interface00/endpoint81
> >=20
> > So probably there should be some attribute in some_usb_function,
> > which contains a list of available interface names, and some attribute =
in
> > interface#, which contains a list of available endpoint names.
> > Workable, but not so convenient. And there could be a problem, too,
> > if the gadget is unbound: there is no way to remove the user-created
> > directories other than by the user themselves, so there will be times
> > (i.e. between gadget unbind and manual rmdir) when these
> > interface/endpoint
> > directories will not correspond to anything present in the system.
> >=20
> > So maybe this kind of information should live in sysfs? But I don't
> > know now if it would be any easier. Joel? Felipe?
> >=20
>=20
> I forgot to mention, representing udcs (USB Device Controllers) in
> configfs is similar to interfaces/endpoints: the user needs to guess
> what name to use in mkdir, e.g. in:
>=20
> $ mkdir ....../udcs/s3c-hsotg

why would you even require a UDC directory to be created ? You
*register* the UDC with the udc-class and that should be enough to
expose all UDCs under /sys/kernel/config/..../udcs/*

The fact is that in most cases you will have multiple instances of the
*same IP* not different UDCs with different names as you seem to think.
While that's possible, it'll be a rare situation.

So what we will have in 95% of the cases will be:

/...../udcs/dwc3.0
/...../udcs/dwc3.1
=2E..
/...../udcs/dwc3.N

The only thing the poor user needs to know is that *.0 is the first
controller, *.1 is the second controller and so on. Since that's
hardcoded in HW anyway (every instance has its own IRQ, address space,
etc, and each of them is physically attached to a single port), you can
kinda make that assumption in code too.

--=20
balbi

--8TaQrIeukR7mmbKf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQxfLoAAoJEIaOsuA1yqRE85UQAKqdN3vl5YLCMCn7BgxG5Qc0
hWsqecd6J8/OPQI2+GVsy3S3JjiM/Q8TR0LO1+oZaOzXu4Q6m9aByB6W2Elrk2it
EeJyy0R+90gvyB2FOCJXlkaLJbYqgHm1/v7I3p/AyE5HrBRD7T+7rvvZB5Pj0FXX
IDB51trlud1SRGucc0L5+mLb5g0iEjWWRGr4NWl2lOmTqYLdirDwyxSqwlukAO6c
PETsm5KM+TmyfrEAfgx/et1p0SQFKc/+hVKSt689Jiuw32xGnJqAO6RuFeQO2L/6
3Uoi/U7a4kA5KArJ88u46hO8erX8jmDzOh3yabPQG92YQPpUyjakwKb0hy4KOoN/
xxL2srsJSt69dNMKkdyBihsR+QS4E3uSvN7L++4dGSMUnNivYK5Ecz6tJA0Rh+Jr
OKQOMIJ8Xc0VytvWU7626hXz2br7IltY5K84qILz+gnXHG1RBIlh0XhlrfL6B+DN
DvZIxFpX5uyF8l7VrOxiYnLnIFbvcZsrZPrLESmdTP6W4S4cUEnFr1WkoS4jJcLT
EfTjoMxcGQZ4Olw1Rd9ppzEAdbeP/mubOCCtaGPKruH151LYFSh1YhxT7tEH1qU6
4YGKcVQXR/xhtKJeZTCEVFY31KncivVyL24u10LCkWJv5zoFt8Q2yBMz6s7QsfPu
1Dw/2XK9/RUbDCoBwWLj
=wBY6
-----END PGP SIGNATURE-----

--8TaQrIeukR7mmbKf--
