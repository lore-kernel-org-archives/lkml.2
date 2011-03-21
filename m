Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1CUC70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 22:59:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59854 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1CUC7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 22:59:23 -0400
Date: Mon, 21 Mar 2011 13:59:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: build failure after merge of the final tree (mfd tree
 related)
Message-Id: <20110321135910.267f367f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Mar_2011_13_59_10_+1100___PnwN2qbISg9nUQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Mar_2011_13_59_10_+1100___PnwN2qbISg9nUQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/max8997-irq.c:170: error: unknown field 'bus_lock' specified in=
 initializer
drivers/mfd/max8997-irq.c:170: warning: initialization from incompatible po=
inter type
drivers/mfd/max8997-irq.c:171: error: unknown field 'bus_sync_unlock' speci=
fied in initializer
drivers/mfd/max8997-irq.c:171: warning: initialization from incompatible po=
inter type
drivers/mfd/max8997-irq.c:172: error: unknown field 'mask' specified in ini=
tializer
drivers/mfd/max8997-irq.c:172: warning: initialization from incompatible po=
inter type
drivers/mfd/max8997-irq.c:173: error: unknown field 'unmask' specified in i=
nitializer
drivers/mfd/max8997-irq.c:173: warning: initialization from incompatible po=
inter type

Caused by commit d7d21d394c9d ("mfd: Add MAX8997/8966 IRQ control feature").

The presence of these fields depends on
CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED not being set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Mar_2011_13_59_10_+1100___PnwN2qbISg9nUQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNhr7+AAoJEDMEi1NhKgbsEf8IAIoRe2tjStbJ2d47rMqX7Dd0
T1ZzchW4lD5wzFSrLEj8SVW4s+NfdWp3IsGse5znfrW78yvIguJrRQA0chC/69O9
/rH+9MB+jHKFIKnSTXwl4lqIsF2scfkNUY9vHzJY6TSSACWMHlVUtGbUKxSIDm1+
QRfJSiHyT+QDuV+rEaoRLa0umSErzDUUVX1PYfdJGwQmRfaZjixgmPQxhuqB/yke
ObvHQZLKQlSVZwwXX1WjGyGSRdNxGEHw+0fMByR35ItKijqPvSUOHBKJJ7Ki5U0M
OhBfS+G/3LHb3bR0AA5TSNW7dVo7PY2YiGNlo7xA2dyMvfvQUJhXGRglAPuiVCE=
=62Of
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Mar_2011_13_59_10_+1100___PnwN2qbISg9nUQ--
