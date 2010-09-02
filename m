Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0IBDzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:55:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45640 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab0IBDy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:54:58 -0400
Date: Thu, 2 Sep 2010 13:54:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        =?UTF-8?B?Ik1pY2hhxYIgTmF6YXJld2ljeiI=?= <m.nazarewicz@samsung.com>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20100902135450.59d6b96a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Sep_2010_13_54_50_+1000_JSC.PW_mJ6myYlzB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Sep_2010_13_54_50_+1000_JSC.PW_mJ6myYlzB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/usb/gadget/nokia.c:244: error: unknown field 'bind' specified in in=
itializer
drivers/usb/gadget/nokia.c:244: warning: initialization makes integer from =
pointer without a cast
drivers/usb/gadget/nokia.c:244: error: initializer element is not computabl=
e at load time
drivers/usb/gadget/nokia.c:244: error: (near initialization for 'nokia_driv=
er.needs_serial')
drivers/usb/gadget/nokia.c: In function 'nokia_init':
drivers/usb/gadget/nokia.c:250: error: implicit declaration of function 'us=
b_composite_register'

Caused by commit cc604fa9db859b7d6899de807d6bd8df80fc0a1a ("usb gadget:
don't save bind callback in struct usb_configuration").  The 'bind' and
'usb_composite_register' references above were added before 2.6.34-rc1
but missed in this patch.

Please make every attempt to (at least) build every file that gets
modified when testing a patch.  (and grep is your friend)

I have used the usb tree from next-20100901 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Sep_2010_13_54_50_+1000_JSC.PW_mJ6myYlzB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMfyAKAAoJEDMEi1NhKgbsRTEH+wRNQo8345579LL+iSBADqo/
iQz1x2Lh1hCwm4QG6mdQaPhSGeQB8nNRrRfBfTQtDBTzR3rJA5wreQgl3Gxyg886
iZ+1Okx8l239v+dYOI/J1gmfxFZy88p7EswFi5A28uXwu49Ohkp0yceaqY2f2RDy
xb/Wc8OsOZGYoIrGE/C0p9lUEf3cqp0GjyWgw8ArCRj6G+xNzSkxguzCKuG/qxsV
Zq7ZObwXAE5U4vOoeWaDpEcONbwq3tDMYjHq3yBXqNTzug2UGDTpBsykYlqQuMCJ
ZQHukrtimaiCwz1lpQSHJtGI3gq/XXJDO9zOPKImBLzEL/rmsBjf7M6pnSzMj1s=
=8Jbx
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Sep_2010_13_54_50_+1000_JSC.PW_mJ6myYlzB--
