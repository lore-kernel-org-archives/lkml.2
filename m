Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2F0LK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:10:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49168 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab2F0LKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:10:24 -0400
Date: Wed, 27 Jun 2012 12:10:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i2c/ch7006: Convert to dev_pm_ops
Message-ID: <20120627111022.GB308@opensource.wolfsonmicro.com>
References: <1339465514-10766-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAPM=9txnD5zoFrUya3dn4x6RnSsP4xyg+YLJvXr42K8T5EkY6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <CAPM=9txnD5zoFrUya3dn4x6RnSsP4xyg+YLJvXr42K8T5EkY6w@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 27, 2012 at 10:21:46AM +0100, Dave Airlie wrote:

> Thanks for this and I like the fact its been posted 5 times but never
> compiled once.

It's hard to remember since it was so long ago that I wrote the patch
but I rather suspect the reason this didn't happen is that it's actually
fairly hard to enable for test builds as the relevant Kconfig is buried
in a different directory (it's done as part of the Nouveau driver) with
no immediate relationship with the code.  That said...

> Can you at least test compile it?

...it could also be that the build error I get when I enable CONFIG_DRM
with -next is a long standing one:

In file included from include/drm/drmP.h:75,
                 from drivers/gpu/drm/drm_auth.c:36:
include/drm/drm.h:47: fatal error: sys/ioccom.h: No such file or directory
compilation terminated.
make[3]: *** [drivers/gpu/drm/drm_auth.o] Error 1

The error here seems to be that you're relying on __linux__ to decide if
you're building the kernel but that's not something you can rely on, we
can build the kernel with a freestanding compiler and the compiler will
only define this if it targets a Linux userspace.  I happen to do pretty
much all of my kernel builds with a freestanding compiler.

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6un4AAoJEBus8iNuMP3drNsP/i7oMc9onwJ2gJ4ID//S3skl
9Opt7K63L797Yt/CD+Owni1P0id+ECRrBwT2ck7PN0+/8xtEd7cEM4ED3cywCBOj
BTmBi9qy1gowTTHpkHd9kXZBiUNmE3ahD8PGZShBB6HliiBqkc5nU1m9HxqBiY9F
14kh+c9xnrm4iut5ORRoSTKXaleKGX+aaXsM1oXdTzGaMhJBTmaIdtD0deA/50j2
6PTOD+kRC4glulC4mI3B5QzvX8mZ7I1hPY2dycSj2urkWT04imTqE3amy2kAwK7D
VZxm4gOUjnWUHQEF+fZrlAFbRufXB9bhFkZ3l/fDzLyCKWZn7UMJfjGM6CFtRw9h
38meFK2YAPVsBzXPDYsUSsM8C0wTO6b1JTtH7yitwSlBgDWEIAosFN8JcOI20zAh
nvEIJIYYcSpk+XCPIFR+LQeDgQ1xaJhOf4E8Ub6lZbCYokNc+3+RPLHZhnF+iaiW
KZScnMKCwOq6GvEuMFHeL4WtEWUL5kqdyjRRbEYTpEysvvRqfw4fv+oH9pVG7b/E
D7XwBVfCA+Wg1ch6pRygqMdpJ2p980AQpPhfuwFB+Jc1WhY0JtdfBtEmTP7btyf7
NfoaX7X3RQL/kN38pYZ5s8gqcyI5+x0n8N20Ma+8zZyrMSzvEJnpQtr9SBTD1hBn
hZSNSQyFGEV2qimuu4l4
=HBQc
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
