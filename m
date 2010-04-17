Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0DQRlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 13:41:39 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:48957 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0DQRlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 13:41:37 -0400
Date: Sat, 17 Apr 2010 21:41:27 +0400
From: Eric B Munson <ebmunson@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       rolandd@cisco.com, peterz@infradead.org, pavel@ucw.cz, mingo@elte.hu
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Message-ID: <20100417174127.GA3579@us.ibm.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20100412160359.1d9074dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Apr 2010, Andrew Morton wrote:

> On Mon, 12 Apr 2010 07:22:17 +0100
> Eric B Munson <ebmunson@us.ibm.com> wrote:
>=20
> > Andrew,
> >=20
> > I am resubmitting this patch because I believe that the discussion
> > has shown this to be an acceptable solution.
>=20
> To whom?  Some acked-by's would clarify.
>=20
> >  I have fixed the 32 bit
> > build errors, but other than that change, the code is the same as
> > Roland's V3 patch.
> >=20
> > From: Roland Dreier <rolandd@cisco.com>
> >=20
> > As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61=
925>
> > and follow-up messages, libraries using RDMA would like to track
> > precisely when application code changes memory mapping via free(),
> > munmap(), etc.  Current pure-userspace solutions using malloc hooks
> > and other tricks are not robust, and the feeling among experts is that
> > the issue is unfixable without kernel help.
>=20
> But this info could be reassembled by tracking syscall activity, yes?=20
> Perhaps some discussion here explaining why the (possibly enhanced)
> ptrace, audit, etc interfaces are unsuitable.
>=20
> > We solve this not by implementing the full API proposed in the email
> > linked above but rather with a simpler and more generic interface,
> > which may be useful in other contexts.  Specifically, we implement a
> > new character device driver, ummunotify, that creates a /dev/ummunotify
> > node.  A userspace process can open this node read-only and use the fd
> > as follows:
> >=20
> >  1. ioctl() to register/unregister an address range to watch in the
> >     kernel (cf struct ummunotify_register_ioctl in <linux/ummunotify.h>=
).
> >=20
> >  2. read() to retrieve events generated when a mapping in a watched
> >     address range is invalidated (cf struct ummunotify_event in
> >     <linux/ummunotify.h>).  select()/poll()/epoll() and SIGIO are
> >     handled for this IO.
> >=20
> >  3. mmap() one page at offset 0 to map a kernel page that contains a
> >     generation counter that is incremented each time an event is
> >     generated.  This allows userspace to have a fast path that checks
> >     that no events have occurred without a system call.
>=20
> OK, what's missing from this whole description and from ummunotify.txt
> is: how does one specify the target process?  Does /dev/ummunotify
> implicitly attach to current->mm?  If so, why, and what are the
> implications of this?
>=20
> If instead it is possible to attach to some other process's mmu
> activity (/proc/<pid>/ummunotity?) then how is that done and what are
> the security/permissions implications?
>=20
> Also, the whole thing is obviously racy: by the time userspace finds
> out that something has happened, it might have changed.  This
> inevitably reduces the applicability/usefulness of the whole thing as
> compared to some synchronous mechanism which halts the monitored thread
> until the request has been processed and acked.  All this should (IMO)
> be explored, explained and justified.
>=20
> Also, what prevents the obvious DoS which occurs when I register for
> events and just let them queue up until the kernel runs out of memory?=20
> presumably events get dropped - what are the reliability implications
> of this and how is the max queue length managed?
>=20
> Also, ioctls are unpopular.  Were other intefaces considered?
>=20

I am reworking the Documentation to address all these questions and will
resubmit when finished.

Thanks for the feedback,
Eric

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvJ8scACgkQsnv9E83jkzr2CACcDcUmh4SngEQJfq+6GQoqjExn
qagAn27zfrCWa299GHLy5R9WVXwN3wAc
=gSm8
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
