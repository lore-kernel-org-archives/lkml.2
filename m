Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0C0CDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:03:13 -0400
Received: from ppa02.Princeton.EDU ([128.112.128.216]:46893 "EHLO
	ppa02.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0C0CDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:03:12 -0400
Date: Fri, 26 Mar 2010 22:02:59 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100326220259.702859e9@penta.localdomain>
In-Reply-To: <20100327005710.GA31009@mail.oracle.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	<20100326214648.GF9984@mail.oracle.com>
	<20100326180025.052d930f@penta.localdomain>
	<20100327005710.GA31009@mail.oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GzFqLFlAudsVmMxGW+tpdFK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GzFqLFlAudsVmMxGW+tpdFK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Mar 2010 17:57:11 -0700
Joel Becker <Joel.Becker@oracle.com> wrote:

> On Fri, Mar 26, 2010 at 06:00:25PM -0400, Yury Polyanskiy wrote:
> > On Fri, 26 Mar 2010 14:46:49 -0700
> > Joel Becker <Joel.Becker@oracle.com> wrote:
> >=20
> > > On Tue, Mar 23, 2010 at 11:36:11PM -0400, Yury Polyanskiy wrote:
> >=20
> > > 1) Does getrawmonotonic() satisfy hangcheck-timer?  What I mean is, w=
ill
> > > it always return the wallclock nanoseconds even in the face of CPU sp=
eed
> > > changes, suspend, udelay, or any other suspension of kernel operation?
> > > Yes, I know this is a tougher standard than rdtsc(), but this is what
> > > hangcheck-timer wants.  rdtsc() at least satisfied udelay and PCI han=
gs.
> >=20
> > Yes, as far as I can tell. Note that rdtsc is hosed on suspend-resume.
>=20
> 	Yeah, I know.  rdtsc hangcheck-timer really required no suspend
> or cpufreq.  Since it is only really used by servers, this wasn't a
> terrible restriction.  Then virtualization came along...

Joel, just realized there is a slight mistake in what I said before.
getrawmonotonic() is a refined jiffies (and actually resolves to
get_cycles() on my system in the end). Thus it doesn't count while in
suspend. However, jiffies-based timers (aka timer-wheel) are also
stopped while in suspend. So getrawmonotonic() is the right call to
check the precision of the jiffies-based timer (i.e. you dont need to
make a correction by calling monotonic_to_bootbased()).=20

So my comment about rdtsc and suspend-resume is wrong.

Yury

--Sig_/GzFqLFlAudsVmMxGW+tpdFK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkutZ1MACgkQemuRe3zuqOR1SwCgt6cDE26cVYeu2LOT6DHa21X1
HXAAni5IbjxBuRg5+0itrqO0A0LnDNOR
=blrW
-----END PGP SIGNATURE-----

--Sig_/GzFqLFlAudsVmMxGW+tpdFK--
