Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0DAGHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:07:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60321 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab0DAGGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:06:48 -0400
Date: Thu, 1 Apr 2010 17:06:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IkJydW5vIFByw6ltb250Ig==?= <bonbons@linux-vserver.org>
Subject: linux-next: build failure after merge of the final tree (hid tree
 related)
Message-Id: <20100401170639.9f2fe605.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Apr_2010_17_06_39_+1100_NCsV.QWPQe6Bg5gy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Apr_2010_17_06_39_+1100_NCsV.QWPQe6Bg5gy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/hid/hid-picolcd.c: In function 'picolcd_debug_reset_write':
drivers/hid/hid-picolcd.c:1343: error: implicit declaration of function 'co=
py_from_user'
drivers/hid/hid-picolcd.c: In function 'picolcd_debug_eeprom_read':
drivers/hid/hid-picolcd.c:1407: error: implicit declaration of function 'co=
py_to_user'

Caused by commit 9bbf2b98ba11d00bd73e3254e15cfe17ccaff6ba ("HID: add
experimental access to PicoLCD device's EEPROM and FLASH").  Using copy_
{to,from}_user requires the include of linux/uaccess.h.

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Apr_2010_17_06_39_+1100_NCsV.QWPQe6Bg5gy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku0N+8ACgkQjjKRsyhoI8wvWACeOaOufsE4iYe1kUAzZ4wEpAjN
45YAn3Oy3v52hLTgB/njOsVMNjSB+g1z
=8Djm
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Apr_2010_17_06_39_+1100_NCsV.QWPQe6Bg5gy--
