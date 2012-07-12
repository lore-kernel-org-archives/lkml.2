Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2GLByb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 21:54:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46610 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab2GLBya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 21:54:30 -0400
Date: Thu, 12 Jul 2012 11:54:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lu@amd.com>, Jeff Garzik <jeff@garzik.org>,
        Lin Ming <ming.m.lin@intel.com>, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: linux-next: manual merge of the scsi tree with the libata tree
Message-Id: <20120712115418.c85da6d6dfc7825172cd58ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jul_2012_11_54_18_+1000_OQBXDRaZLQZwxcSq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jul_2012_11_54_18_+1000_OQBXDRaZLQZwxcSq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
include/scsi/scsi_device.h between commits 166a2967b45e ("libata: tell
scsi layer device supports runtime power off") and a4120295a40a ("sr:
support zero power ODD") from the libata tree and commit 2516034c2270
("[SCSI] set to WCE if usb cache quirk is present") from the scsi tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/scsi/scsi_device.h
index cfd951b,7539f52..0000000
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@@ -153,8 -154,7 +154,9 @@@ struct scsi_device=20
  	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
  	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
  	unsigned is_visible:1;	/* is the device visible in sysfs */
 +	unsigned can_power_off:1; /* Device supports runtime power off */
 +	unsigned wakeup_by_user:1;	/* user wakes up the ODD */
+ 	unsigned wce_default_on:1;	/* Cache is ON by default */
 =20
  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events =
*/
  	struct list_head event_list;	/* asserted events */

--Signature=_Thu__12_Jul_2012_11_54_18_+1000_OQBXDRaZLQZwxcSq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/i5KAAoJEECxmPOUX5FEQhoP/jzixMfhpv3fMVP/GFvjd5kf
2rCgBaZT2XipmRrCtR5PkRoE8euj6HNULNXgGIGAziG458oIoGUgp1tSnXt8A0AU
A6w+uM8gx6tGYkWV90HNHPowRx1escHDP269TkkAPvnPP+4ooR7gHdZca2MfcvxH
3q18VuDguDFlbkz5XgmnyLDwXRVZQRUcepJ43trKB+Ci/gtHRTQnw2EBudDi0tGK
YZmj8ptMiwMR77YKOgBdakZNu8BYcAbxpgGCox4QirO+lm5szOxkgLzdi7KRNGA5
1AjIAvqdZ6EURSq5iLDguCD2rONBjSfiHv+T4PQvyUEpFfIebxArkNTPJjta+ZWU
9dHgaL5vDDLp9p5AbNyc6otQRP8cmDVeRxn6Jp+QvlaOqFdxIOHcd5ryrv8K22p0
pc83umDfZhOiT04dbMPuIlHEjV3rQqhArUnplsedczkP6HmiEOs72peAIfJ8U8Me
8X0kdr0mWfAKwRu5WRIdDdsT2pLBbaxOnkl6/8CERk66+k3RYsBy88R76xP/2PS3
qK66zxlBcs16LKyp3527jYOBrNHTVBWqZ3sBONRkQk+WIScr/R5Fv5PArzvnJSL7
dHVVuUy6RvIE0+cGUoPm96ehOg1Rv+oep4oqYt7cR+tTJNfwameWHulb0U7K+K1X
VzHfQEBvr14QncMTizVM
=xvOh
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jul_2012_11_54_18_+1000_OQBXDRaZLQZwxcSq--
