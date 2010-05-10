Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0EJFli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:41:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35951 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0EJFlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:41:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the backlight tree
Date: Mon, 10 May 2010 01:41:21 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.33.2; KDE/4.4.1; x86_64; ; )
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michael Hennerich <michael.hennerich@analog.com>
References: <20100510124304.2249532c.sfr@canb.auug.org.au>
In-Reply-To: <20100510124304.2249532c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5394563.GBnx3Flnm4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201005100141.22985.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5394563.GBnx3Flnm4
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 09 May 2010 22:43:04 Stephen Rothwell wrote:
> After merging the backlight tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/video/backlight/adp8860_bl.c: In function 'adp8860_led_probe':
> drivers/video/backlight/adp8860_bl.c:215: error: implicit declaration of
> function 'kzalloc' drivers/video/backlight/adp8860_bl.c:215: warning:
> assignment makes pointer from integer without a cast
> drivers/video/backlight/adp8860_bl.c:285: error: implicit declaration of
> function 'kfree' drivers/video/backlight/adp8860_bl.c: In function
> 'adp8860_probe': drivers/video/backlight/adp8860_bl.c:673: warning:
> assignment makes pointer from integer without a cast
> drivers/video/backlight/adp8860_bl.c:689: error: too few arguments to
> function 'backlight_device_register'
>=20
> Caused by commit 6f1a02240dba279a389fd4a4138445bd3f13f67f ("backlight:
> new driver for the ADP8860 backlight parts").  Use of kzalloc or kfree
> requires including linux/slab.h (see Rule 1 in
> Documentation/SubmitChecklist) and the prototype of
> backlight_device_register changed before v2.6.34-rc2.

obviously the driver simply missed the tree-wide slab.h updates

Richard: you want a new version to replace the one in your tree ?  or a one=
=20
line fix for this issue ?
=2Dmike

--nextPart5394563.GBnx3Flnm4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJL55yCAAoJEEFjO5/oN/WBkOkQANdFg43qkzc5Ju488VP4NalM
m13rlhevsbibhZIn0LThrn8rGYfIDBRmdrOlfcKIJ9m9A8OwcMQF0Er31c+a+wL3
wLHLwmBdq6GoZSwl1GgBrVdhsGjyag5rJ1Ev2j7frrMF9VIMemPMv5j4kP1Ce9A6
eXwPKgVte0LQnFH3eGYmLqvOeIknbGv++iUWBhUt0++32A7+18U1XoFNwMC6XYl9
9vGyBhTHjcWWYzOgk+35cTWae4oITbV/IGQTRBoxfYQOYtFviAPaMePbKhYG3wav
pUwA7t0KLQdVMhG7wpOq9OZVDVivx5pDpA6BPW/71QM4hrRIQsJengqct1Ak6jGt
b8zjy6W/x50tzzyDwc4prx9EBn0QWtEN1kcA0ztZBQFqjbSsC0AI0ZxgeFdORj2w
o0hGJmysMfRdL2Gu8RlueL3bTiefcD+GYsoegZekNwq7/lbc21Myr3+x3uUNJLYM
ZUx6tG0AW5SNMlHIRaoaQ39yXzAYeVxx3J6eDfX9gSE4Qp0NZ4LPHSz5813jXNvP
2Jia/FYEa9fChZtyCuh1AiREHg5ZsWnyDOZ1NYN3/Oabh2num/jaZr70usXGR7T4
RTIsCldUbute8wDq3b9wlT82aAsvyAeKKcwoEusZ1M1XJpEdZFUw7X29fJY/7Lm0
amXk07ORWxb418W79u+k
=n3TB
-----END PGP SIGNATURE-----

--nextPart5394563.GBnx3Flnm4--
