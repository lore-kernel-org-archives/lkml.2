Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0CWGls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:41:48 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:39307 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0CWGlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:41:47 -0400
Date: Tue, 23 Mar 2010 07:41:41 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-cr] nested pid namespaces (v2)
Message-ID: <20100323064140.GB4242@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <20100319213955.GA17912@us.ibm.com> <20100322105502.GB5569@localdomain> <20100322143800.GD3744@us.ibm.com> <20100322195735.GE20796@count0.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-2221-1269326422-0001-2"
Content-Disposition: inline
In-Reply-To: <20100322195735.GE20796@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-2221-1269326422-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2010 at 12:57:35PM -0700, Matt Helsley wrote:
> On Mon, Mar 22, 2010 at 09:38:00AM -0500, Serge E. Hallyn wrote:
> > Quoting Louis Rilling (Louis.Rilling@kerlabs.com):
> > > On Fri, Mar 19, 2010 at 04:39:55PM -0500, Serge E. Hallyn wrote:
> > > > Support checkpoint and restart of tasks in nested pid namespaces.  =
At
>=20
> <snip>
>=20
> > > It would probably be safer too to use task_active_pid_ns() instead of
> > > task->nsproxy->pid_ns, just in case some PID namespace unsharing like=
 proposed
> > > by Eric makes it to mainline.
> >=20
> > The task is frozen though so it shouldn't be able to unshare while being
> > checkpointed, right?  But it's probably better code anyway.
>=20
> By the time it reaches checkpoint a frozen task is in the refrigerator
> -- most often in the signal delivery portion of syscall return. So it can=
't
> be making any new unshare/setns syscalls and any changes to the namespaces
> should be visible.

And what about a task having already unshared its pid namespace (from within
the container)? In this case, all pid-related stuff should be based on
task_active_pid_ns(), and ->nsproxy->pid_ns should be recorded too to corre=
ctly
restore pid unsharing.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-2221-1269326422-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuoYqQACgkQVKcRuvQ9Q1SzdgCguWeotr/sPeYkfOIQ/KGamduX
ryMAoJMQsBelx+Av+SBB8hyTIVyKbqMa
=LyF1
-----END PGP SIGNATURE-----

--=_bohort-2221-1269326422-0001-2--
