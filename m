Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab0C2OLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:11:33 -0400
Received: from ppa04.Princeton.EDU ([128.112.128.215]:37070 "EHLO
	ppa04.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0C2OLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:11:31 -0400
Date: Mon, 29 Mar 2010 10:11:06 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: john stultz <johnstul@us.ibm.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100329101106.3678a312@penta.localdomain>
In-Reply-To: <1269824436.1880.2.camel@work-vm>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	<20100326214648.GF9984@mail.oracle.com>
	<1269824436.1880.2.camel@work-vm>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//xQurcI4HTn3R_LdzFsLUTm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//xQurcI4HTn3R_LdzFsLUTm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Mar 2010 18:00:36 -0700
john stultz <johnstul@us.ibm.com> wrote:

> > 1) Does getrawmonotonic() satisfy hangcheck-timer?  What I mean is, will
> > it always return the wallclock nanoseconds even in the face of CPU speed
> > changes, suspend, udelay, or any other suspension of kernel operation?
> > Yes, I know this is a tougher standard than rdtsc(), but this is what
> > hangcheck-timer wants.  rdtsc() at least satisfied udelay and PCI hangs.
>=20
> getrawmonotonic() can be stalled and will wrap on some hardware (acpi pm
> timer wraps every 5 seconds).
>=20

I am not sure which archs do you mean. But in any case,
getrawmonotonic() is not just a wrap around a call to rdtsc() (or acpi
pm timer read). It is based on the clock->raw_time, which is updated
every timer interrupt by the update_wall_time(). So even if underlying
timer wraps, it doesn't lead to getrawmonotonic() returning 0 sec.


Y

--Sig_//xQurcI4HTn3R_LdzFsLUTm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuwtPoACgkQemuRe3zuqOTSfACcCKDLFECg2YSWQe2J18kJZ7pe
OSMAnibaIvJLh7vfVqlOHJUQq4yIKf+c
=Myw7
-----END PGP SIGNATURE-----

--Sig_//xQurcI4HTn3R_LdzFsLUTm--
