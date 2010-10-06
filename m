Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0JFE2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:28:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52574 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0JFE2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:28:44 -0400
Date: Wed, 6 Oct 2010 15:28:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
 (jdelvare-hwmon tree related)
Message-Id: <20101006152831.f91a5610.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_15_28_31_+1100_YrJAxi/UnN6d_Lpk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Oct_2010_15_28_31_+1100_YrJAxi/UnN6d_Lpk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/hwmon/pcf8591.c: In function 'pcf8591_probe':
drivers/hwmon/pcf8591.c:205: error: implicit declaration of function 'IS_ER=
R'
drivers/hwmon/pcf8591.c:206: error: implicit declaration of function 'PTR_E=
RR'

Caused by commit 63575f5628b811d80f81158825dbc9d3db4ac1a5 ("hwmon:
(pcf8591) Register as a hwmon device").

See Rule 1 in Documentation/SubmitChecklist.

I have added reverted that commit (and
3eabb87a17ff8da477f7bf4c5a14063b68937fb1 ("hwmon: (pcf8591) Don't attempt
to detect devices") that followed it) for today.


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Oct_2010_15_28_31_+1100_YrJAxi/UnN6d_Lpk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMq/rvAAoJEDMEi1NhKgbsgv4H/3oqalpfjFvF9APGnOy6h50z
RSNCdmRnhFbALO2hg3Ht478WI8hYYO0OgwjeAm2YTIrekkN9bRSxRxRwyD+YWnhR
/L0VrvrYR4NxZCVc7n92w/fnxODN5aGCZGwxlqbRFeVlPzo2GUFECPVGyCQiq0FS
1ETjYPu/SpgW5jUpJE4gmo4+MKNqN+vwKLTbrzZNI88VzxrtcZy/Jz+uZniyMChP
r/r6hBVlCnNsmwJ6dgJrEliRatBj+lH7StFe7b7SD+ATf/b8cgeqWJm0bThunwuh
TqcUp1MYZ3FpWnMBuBv4hngF9Zm25c9cbWTe+k8ada4mBRqqWMRjcMOxZ+gS5ec=
=FaMZ
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_15_28_31_+1100_YrJAxi/UnN6d_Lpk--
