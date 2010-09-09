Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0IILUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:20:41 -0400
Received: from mail.klingt.org ([86.59.21.178]:50425 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab0IILUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:20:38 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 07:20:38 EDT
From: Tim Blechmann <tim@klingt.org>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [process scheduler] Possible bug in context_swich()?
Date: Thu, 9 Sep 2010 13:12:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; x86_64; ; )
Cc: Mike Galbraith <efault@gmx.de>, fabio de francesco <fabio@metanix.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <201009081728.18227.fabio@metanix.org> <1283999539.9103.54.camel@marge.simson.net> <1284028746.23762.54.camel@laptop>
In-Reply-To: <1284028746.23762.54.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9804333.zPxQLRbZyt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009091312.25424.tim@klingt.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.7 (klingt.org [86.59.21.178]); Thu, 09 Sep 2010 13:12:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9804333.zPxQLRbZyt
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Thursday, September 09, 2010 12:39:06 pm Peter Zijlstra wrote:
> On Thu, 2010-09-09 at 04:32 +0200, Mike Galbraith wrote:
> > On Wed, 2010-09-08 at 17:54 +0200, Peter Zijlstra wrote:
> > > On Wed, 2010-09-08 at 17:28 +0200, fabio de francesco wrote:
> > > > In context_switch() (in linux/kernel/sched.c), starting with release
> > > > 2.6.33, two "unlikely" macro  have been changed to "likely". I think
> > > > the previous logic was right while the latter is wrong.
> > > >=20
> > > > In case I am missing something I, please, ask someone to explain the
> > > > above mentioned inversion of logic through releases.
> > >=20
> > > It helps if you CC people, LKML alone is a bit of a gamble.
> > >=20
> > > git blame kernel/sched.c, will tell you that the change you refer to
> > > comes from:
> > >=20
> > > commit 710390d90f143a9ebb87a475215140f426792efd
> > > Author: Tim Blechmann <tim@klingt.org>
> > > Date:   Tue Nov 24 11:55:27 2009 +0100
> > >=20
> > >     sched: Optimize branch hint in context_switch()
> > >    =20
> > >     Branch hint profiling on my nehalem machine showed over 90%
> >=20
> > >     incorrect branch hints:
> > That change never made any sense to me, seems Tim must have been
> > measuring a kthread load.  I benched at the time, and saw absolutely
> > zero difference one way or the other wrt max ctx rate on my Q6600.
>=20
> One option is to simply remove the whole branch hint.. But lets ask Tim
> what kind of workload he used..

i was using a standard desktop workload, nothing special ...

=2D-=20
tim@klingt.org
http://tim.klingt.org

Wherever we are, what we hear is mostly noise. When we ignore it, it
disturbs us. When we listen to it, we find it fascinating.
  John Cage

--nextPart9804333.zPxQLRbZyt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyIwRIACgkQg0On+TFEWzwI+ACffNgSl3oi9ze7w/1J5TWg61sw
8oEAniuDVGYeyjzi+NTv5KhlDXbEPg2V
=+DWx
-----END PGP SIGNATURE-----

--nextPart9804333.zPxQLRbZyt--
