Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2IMNem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:34:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48190 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2IMNel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:34:41 -0400
Date: Thu, 13 Sep 2012 23:34:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Fries <david@fries.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20120913233429.27668296c459915dc11222f5@canb.auug.org.au>
In-Reply-To: <20120913132408.GZ2608@spacedout.fries.net>
References: <20120913181127.862265ddb9a08758ada8405c@canb.auug.org.au>
	<20120913132408.GZ2608@spacedout.fries.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_23_34_29_+1000_0KbffCb5YVP5aF/M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_23_34_29_+1000_0KbffCb5YVP5aF/M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, 13 Sep 2012 08:24:08 -0500 David Fries <david@fries.net> wrote:
>
> On Thu, Sep 13, 2012 at 06:11:27PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the final tree, today's linux-next build (sparc64 defconf=
ig)
> > failed like this:
> >=20
> > drivers/built-in.o: In function `rtc_hctosys':
> > hctosys.c:(.init.text+0x4a98): undefined reference to `rtc_hctosys_ret'
> > hctosys.c:(.init.text+0x4b54): undefined reference to `rtc_hctosys_ret'
> > hctosys.c:(.init.text+0x4b58): undefined reference to `rtc_hctosys_ret'
>=20
> Can you post your .config?  `grep RTC .config`
> It would seem to me that drivers/rtc/hctosys.c is being compiled
> without drivers/rtc/class.c which now holds the global variable, but
> Kconfig says that RTC_HCTOSYS 'depends on RTC_CLASS =3D y'.

Did you read the bit you quoted below?  CONFIG_PM is not set, so that the
part of class.c that contains the definition of rtc_hctosys_ret is not
compiled ...

> > Caused by commit "rtc_sysfs_show_hctosys(): display 0 if resume failed"
> > from the akpm tree.  rtc_hctosys_ret was moved into class.c but protect=
ed
> > by defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE) and this
> > build does not have CONFIG_PM set.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_23_34_29_+1000_0KbffCb5YVP5aF/M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUeDlAAoJEECxmPOUX5FEpxwQAIYJrXGaFHyVRQ/dpXEBHqPD
yODjgNN+0O5FTGhTJM2FdC8zE3xgqA/YUV9cG07cjrlXFoU0W63kSCWJYkwXnq6c
/gx4j9t6jpLPqq/ua9K7yMeuf403f9GBux6TJDXaqArv1yiZVqGD7xo8zTIRAFfi
mPKe9SfeVuVkHC+VHgy4bvxgCHCyVtz1a3ksIxw/jFBuxp94tKQpCOi8H9OJoV0S
wg62hGLpjDtFPLC3VU/5/eMtMbchZUfZyZ3Sz0j7nNfkkjEZ6usk5UUHfRfYMWQe
Q6T6PMotfSyF+eKPiSJR3Spg2D3Sor8qjzFKvAD0mjpWdvPNeypTIsWkIv41GHST
I3lPuHA11+3YVtfwKuZyTJi9niOg+zh9BvcbZdj4ng0+GCxC+FxzaFN4wL/GQ37l
u0wS2rkMQ8l9iSDxt5HLY8JbkZETnlChN5hvqj9MwN2pefpME/aupeoCR557mtR+
M9DcQVRq1qU3BvpiLZ6H9G86eFR5Nk+XuMlcKOsLL59vM6hPhF0QwA9HCAqahsgj
iuLBIte4snAtivT3kfdcu+E9P8FwPj0boliB6Uke+XDDsDsOlq22ftcl0a4opgo6
+zhE8cJzMt9TWeiAj7z9vp4R33+ba0D82UbiFchNOil2VJ4cmkeT4HDcz5VK4aqh
MEn3QP+ziLMFv/PCv1w0
=SwjT
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_23_34_29_+1000_0KbffCb5YVP5aF/M--
