Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab0D3Szy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:55:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57404 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514Ab0D3RHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:07:33 -0400
Date: Fri, 30 Apr 2010 15:52:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: build failure after merge of the staging-next tree
Message-Id: <20100430155224.ab570260.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Apr_2010_15_52_24_+1000_90rLmH_yvH3Y8Kk4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Apr_2010_15_52_24_+1000_90rLmH_yvH3Y8Kk4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/video/tlg2300/pd-main.c: In function 'poseidon_probe':
drivers/media/video/tlg2300/pd-main.c:457: error: 'struct usb_device' has n=
o member named 'autosuspend_disabled'
drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_probe':
drivers/net/wimax/i2400m/usb.c:508: error: 'struct usb_device' has no membe=
r named 'autosuspend_disabled'

Caused by commit 3a03bb2443e8fb3b35666dc598e7f626519c544a ("USB: use PM
core routines to enable/disable autosuspend") from the usb tree.  I have
reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Apr_2010_15_52_24_+1000_90rLmH_yvH3Y8Kk4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvacBgACgkQjjKRsyhoI8zhZACcDg5uQ0eV+7XsX9yDmc4KvTSO
Uu4AoJ2D3rMMtTSwGIsC4bb4DieGmSYC
=mr4q
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Apr_2010_15_52_24_+1000_90rLmH_yvH3Y8Kk4--
