Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2LKV1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:27:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38981 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2LKV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:27:19 -0500
Date: Tue, 11 Dec 2012 13:27:06 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Michal Nazarewicz'" <mina86@mina86.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config
 groups
Message-ID: <20121211212705.GR22789@localhost>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	'Sebastian Andrzej Siewior' <bigeasy@linutronix.de>,
	'Michal Nazarewicz' <mina86@mina86.com>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
 <50B39921.6090308@linutronix.de>
 <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
 <50B4E364.8030704@linutronix.de>
 <xa1tip8ruia5.fsf@mina86.com>
 <50B5C821.4000406@linutronix.de>
 <xa1ta9u1naik.fsf@mina86.com>
 <50B61695.50207@linutronix.de>
 <20121207231828.GM22789@localhost>
 <001401cdd6cd$788defa0$69a9cee0$%p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001401cdd6cd$788defa0$69a9cee0$%p@samsung.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 12:57:02PM +0100, Andrzej Pietrasiewicz wrote:
> Hello Joel,
> 
> So you are alive, I'm glad to hear from you ;) Thank you for your response.

	Yeah, sorry for missing the thread for so long.

> On Saturday, December 08, 2012 12:18 AM Joel Becker wrote:
> > Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config
> > groups
> > 
> > Hey Guys,
> > 	Sorry I missed this for a while.  I'll make a couple of inline
> > comments, and then I'll summarize my (incomplete) thoughts at the bottom.
> > 
> > On Wed, Nov 28, 2012 at 02:50:13PM +0100, Sebastian Andrzej Siewior wrote:
> > > On 11/28/2012 02:05 PM, Michal Nazarewicz wrote:
> > > >>On 11/27/2012 05:23 PM, Michal Nazarewicz wrote:
> > > >>>How should a generic tool know what kind of actions are needed for
> > > >>>given function to be removed?  If you ask me, there should be a way
> > > >>>to unbind gadget and unload all modules without any specific
> > > >>>knowledge of the functions.  If there is no such mechanism, then
> > > >>>it's a bad user interface.
> > 
> > 	Please remember that configfs is not a "user" interface, it's a
> > userspace<->kernelspace interface.  Like sysfs, it's not required to be
> > convenient for someone at a bash prompt.  My goal is that it is *usable*
> > from a bash prompt.  So it must be that you can create/destroy/configure
> > objects via mkdir/rmkdir/cat/echo, but you might have a lot of those
> > mkdir/echo combos to configure something.
> > When it comes to the "user" interface, a wrapper script or library should
> > be converting a user intention into all that boilerplate.
> > 
> 
> If you say so there is little we can do, is there? :O

	I don't want to make your life harder.  I'm describing the
motivations so that we can come to a consensus.  But configfs isn't an
end-user interface.  Consider the RAID ioctls
(/usr/include/linux/md/md_u.h).  Do you really expect that users will
manage their MD devices by writing programs that do "ioctl(/dev/md0,
GET_ARRAY_INFO)"?  No, you don't.  You expect that mdadm will exist.
	But ioctls are a pain.  Want to do something in a script or code
that mdadm doesn't handle?  Get ready to write ioctls.  In configfs, you
can do it in a shell script.  What about debugging?  Sometimes hackers
like us and sysadmins debugging problems like "mdadm doesn't work" need
to poke around.  If mdadm isn't working, they have to strace the ioctl
calls, then unpack the arguments and see what is happening.  With
configfs, instead, you have a filesystem tree to poke at.
	That's why I wrote it.  sysfs is the same way.  You and I can
poke about sysfs to get info, but most people just want udev to convert
sysfs info into a working system.
	Now, none of this means we shouldn't come up with the simplest
configfs interface for your gadgets.  But if we want to add features to
configfs (rather than to your use of it), I want to understand how this
helps us as userspace<->kernelspace API designers, not how it helps a
sysadmin type fewer commands.

> > > Anyway, for this to work we have to go through Joel.
> > >
> > > >	rmdir udcs/*		# unload all UDCs
> > >
> > > No, for this you still have to rmmod :)
> > >
> > >
> > > >>>I think the question is of information flow direction.  If user
> > > >>>gives some information to the kernel, she should be the one
> > > >>>creating any necessary directories.  But if the information comes
> > > >>>from kernel to the user, the kernel should create the structure.
> > 
> > 	This last paragraph actually describes the distinction between
> > configfs and sysfs.  More specifically, if userspace wants to create an
> > object in the kernel, it should use configfs.  If the kernel has created
> > an object on its own, it exposes it via sysfs.  It is a deliberate non-
> > goal for configfs to replicate sysfs behavior.
> 
> So if the lifetime of some object is controlled by the user, it belongs
> to configfs. If, on the other hand, the lifetime is controlled by the
> kernel, it belongs to sysfs. I think that the trouble with e.g. luns
> is that they might want to behave like both (at least in the "more
> automated"
> approach where they are programmatically created): they are created
> by the kernel (=> sysfs) but their lifetime is controlled by the user
> (=>configfs).

	I think your point is correct, but not quite aligned.  The
gadget endpoint is created by the user (configfs).  It, in turn, causes
the kernel to detect and create LUNs (sysfs).  I don't think this is a
conflict.
	Is your concern that I can then remove the gadget endpoint,
which should trigger the LUNs to disappear, but they are in use?  This
is why the depend_item() interface exists.  When the LUN is opened, the
LUN should mark depend_item() on the gadget endpoint.  Now rmdir() will
fail.

> > 	But this doesn't alleviate Andrzej's primary concern, nor does it
> > answer Michal's concerns about corner cases.  Let's see if we can solve
> > those.
> > 	First, what about preventing extraneous LUNs?  There are two
> > approaches: the prevent approach, and the ignore approach.  In the Target
> > module, they take the ignore approach.  If you create a LUN that is
> > outside the scope, they just ignore it.  So a user can make 10 LUNs, but
> > if only five are allowed, the other five are ignored.  In the prevent
> > approach, we try to fail the mkdir() when we go over the limit.
> 
> I think I like the prevent approach better, because I don't know what to
> do with the unused luns in the ignore approach. I also think that it would
> be nice if configfs described the actual state of the system instead of
> presenting all the possible user-created garbage (i.e. something which is
> ignored).

	Both good arguments.  I described both because they were
mentioned in the thread; I don't have a horse in that race from a
configfs perspective.

> > 	But you need to do the parsing anyway!  If the LUN is created via
> > mkdir(), somehow the gadget system needs to know what LUN number to
> > advertise.  I would actually decouple it from the name.  The name should
> > be free-form; if it happens to be comprehensible, that's good.  Imagine
> > this:
> > 	cd /cfg/.../mass_storage
> > 	echo 4 >max_lun_id
> > 	mkdir lun100
> > 	echo 1 >lun100/lun_id
> > 
> > The LUN actually has the ID of 1.  The fact that the directory name is
> > wrong is irrelevant to the gadget processing; non-hackers use the tooling,
> > and the tooling should  make sane names.  Then your
> > ->make_group() function can choose either approach to avoiding LUN IDs
> > that are too large.  It can prevent:
> > 
> > 	lun_id->store() {
> > 		if (lun_id_exists(parent, value))
> > 			return ERR_PTR(-EINVAL);
> > 		if (value > parent->max_lun_id)
> > 			return ERR_PTR(-ENOSPC) /* or EINVAL */
> > 		setup_lun();
> > 		make_live();
> > 	}
<snip>
> 
> Taking into account what you say about the expected userspace tooling
> using a free-form name plus the lun_id attribute could be attractive,
> because the lun_id attribute's value can be analyzed at ->store() and,
> if it doesn't fit, an appropriate error can be easily returned using
> just what we already have in configfs. Prevent seems better to me, too.

	Yeah, that's the behavior I was driving at.

> > 	But is max LUNs a requirement?  Why not just have the LUN count be
> > the number of LUNs created?  In that case, you can allow or disallow
> > discontiguous LUN IDs without worrying about a max ID.
> > 
> 
> I am not sure, but I think that Michal would say that he wouldn't like
> things to change once the gadget is up and running, so the number of
> luns should be fixed up front. On the other hand, after the gadget is
> set up, we can fail in ->make_group() to prevent the user from creating
> additional luns with which we don't know what to do. So what you suggest
> seems fine, but I would ask Michal to be on a safe side.

	Yeah, if you have a live/not-live toggle, failing new LUN
creation once live is fine.

> > [Really Hate Mkdir]
> > 
> > 	If you considered it appropriate for the LUN objects to be created
> > by the kernel, the standard way would to have "echo 5 >luns_allowed"
> > create LUN objects in sysfs.  Yes, sysfs.
> > There's no reason you can't have things in configfs *and* sysfs.  My
> > understanding of your code says to me that the mkdir approach is the way
> > to go, but if you hate it, this works.
> > 
> 
> I guess you are right, but see my point about luns' lifetime being
> controlled by the user and their creation being performed by the kernel.

	I hope I answered that.

> Once upon a time, Felipe expressed interest in having the information
> about endpoints and interfaces (mostly read-only stuff, but not all of it)
> accessible in the gadget subsystem in configfs. This kind of information
> is fully available only after the gadget has been bound, that is, after
> the user created all the groups/items and filled all the attributes
> and told the gadget to start (with e.g. filling some attribute or
> creating a symlink). So this looks like a programmatic creation of
> configfs directories. On the other hand, Felipe wanted it for debugging
> purposes, so the user could just as well create the required directories
> by hand when they need to, as Sebastian once suggested. Again, this requires
> ->make_group() to fail if all the information is not available yet.

	Some of this might belong in debugfs.  Some of it might belong
in a single attribute file, not in a hierarchy (so you can cat the
.../debug attribute; it is empty before start and full after start).
Just throwing out ideas.

> But isn't it kind of similar to the luns' case? It is a bunch of objects
> whose lifetime is controlled by the user (bind the gadget, unbind the
> gadget),
> but which are created by the kernel.
> Another problem with this is that the user must at some point _guess_
> what name to use in mkdir. Example:
> 
> For each interface there should be a folder. So the user must know how many
> interfaces' folders to create and how to name them, like:
> 
> $ mkdir ...../some_usb_function/interface00
> $ mkdir ...../some_usb_function/interface01
> ...
> ...
> ...
> 
> In each interface folder, there should be some endpoint folders and the user
> must know how many endpoints there are and how to name them:
> 
> $ mkdir ...../some_usb_function/interface00/endpoint02
> $ mkdir ...../some_usb_function/interface00/endpoint81
> 
> So probably there should be some attribute in some_usb_function,
> which contains a list of available interface names, and some attribute in
> interface#, which contains a list of available endpoint names.

	This is worth discussing.  I repeat that the goals of configfs
are transparency and discoverability.  If I just have to *know* to
"mkdirx interface01", it is not discoverable.  If mkdir fails for magic
reasons, it is not transparent.
	Your proposed attribute of available interface names is one of
the usual ways to solve this in configfs.  It makes for clean code, too.
If "mkdir interface_name" is not on the list described by "cat
available_interfaces", you can return an error.  In this fashion, the
interface (and endpoint) names are discoverable, and why your mkdir
succeeds or fails is transparent.
	The other approach is the one I described for LUNs: the path
name is free-form, and an attribute is set to make it appropriate.  eg,
rather than a directory named interface00, you have:

  $ mkdir .../some_usb_function/free-interface-name
  $ echo 00 > .../some_usb_function/free-interface-name/interface_id

> Workable, but not so convenient. And there could be a problem, too,

	Yeah, you are right, we are sacrificing convenience in the name
of transparency and discoverability.

> if the gadget is unbound: there is no way to remove the user-created
> directories other than by the user themselves, so there will be times
> (i.e. between gadget unbind and manual rmdir) when these interface/endpoint
> directories will not correspond to anything present in the system.

	Sure.  After unbind, they are a potential configuration, just
like they were before bind while you were setting them up.

Joel

 

-- 

Life's Little Instruction Book #157 

	"Take time to smell the roses."

			http://www.jlbec.org/
			jlbec@evilplan.org
