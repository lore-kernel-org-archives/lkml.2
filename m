Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0C1NCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 09:02:34 -0400
Received: from ppa01.Princeton.EDU ([128.112.128.213]:57368 "EHLO
	ppa01.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0C1NCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 09:02:32 -0400
Date: Sat, 27 Mar 2010 22:08:51 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100327220851.7d0962b9@penta.localdomain>
In-Reply-To: <20100327233630.GB1810@mail.oracle.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	<20100326214648.GF9984@mail.oracle.com>
	<20100326180025.052d930f@penta.localdomain>
	<20100327005710.GA31009@mail.oracle.com>
	<20100326220259.702859e9@penta.localdomain>
	<20100327220355.GA1810@mail.oracle.com>
	<ea182b21003271551k10d0ef1oa0757ba921f1870f@mail.gmail.com>
	<20100327233630.GB1810@mail.oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2fMY8BM6F8zaMr_oKP/vW=a"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2fMY8BM6F8zaMr_oKP/vW=a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Mar 2010 16:36:30 -0700
Joel Becker <Joel.Becker@oracle.com> wrote:

> On Sat, Mar 27, 2010 at 06:51:01PM -0400, Yury Polyanskiy wrote:
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0It's OK to tell hangcheck-timer users that=
 suspend is not
> > > allowed. =C2=A0After all, you're running something that you don't wan=
t to see
> > > hang.
> >=20
> > Joel, what I am saying is exactly the opposite: it is totally ok to
> > suspend-resume with hangcheck-timer (jiffies are stopped and so is
> > getrawmonotonic() when system suspended).
>=20
> 	Nope.  The point of hangcheck-timer is that it reboots should
> the system not be running for a certain amountof time.  If
> suspend-resume is allowed, a system can resume after days and think it
> wasn't more than a second.  hangcheck-timer will not know to reboot.

But what is the reason for rebooting? Hangcheck is supposed to reboot
the machine only if the timer handler was run too late. However,
jiffies-based timers DO NOT count time spent in suspend.

Y

--Sig_/2fMY8BM6F8zaMr_oKP/vW=a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuuujMACgkQemuRe3zuqOQosACeORtoTc6v2CXkn9YBGv+cYsNm
I4cAoKzfE4RXgCTG6fZFR1+Gw5vUtHsR
=lNCk
-----END PGP SIGNATURE-----

--Sig_/2fMY8BM6F8zaMr_oKP/vW=a--
