Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab2AFELD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 23:11:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57733 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2AFELB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 23:11:01 -0500
Date: Fri, 6 Jan 2012 15:10:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the input tree with the rr tree
Message-Id: <20120106151051.451028e2a161f9b1b6d40535@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_15_10_51_+1100_=+DQ42.D5a6eruEb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_15_10_51_+1100_=+DQ42.D5a6eruEb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
drivers/input/touchscreen/ucb1400_ts.c between commit 8c2e30fe02e2
("module_param: make bool parameters really bool (drivers & misc)") from
the rr tree and commit c899afedf168 ("Input: ucb1400_ts - convert to
threaded IRQ") from the input tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/touchscreen/ucb1400_ts.c
index 056eea9,d2b5753..0000000
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@@ -25,12 -26,11 +26,11 @@@
  #include <linux/input.h>
  #include <linux/device.h>
  #include <linux/interrupt.h>
- #include <linux/suspend.h>
- #include <linux/kthread.h>
- #include <linux/freezer.h>
  #include <linux/ucb1400.h>
 =20
+ #define UCB1400_TS_POLL_PERIOD	10 /* ms */
+=20
 -static int adcsync;
 +static bool adcsync;
  static int ts_delay =3D 55; /* us */
  static int ts_delay_pressure;	/* us */
 =20

--Signature=_Fri__6_Jan_2012_15_10_51_+1100_=+DQ42.D5a6eruEb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBnRLAAoJEECxmPOUX5FEVuwQAIofL9/Wybsxgi0k9hzD1KHM
jk/cIKvBGeRgbezJ7TRNWNA7NXjDWaPWOEEAsLPbZRi2hJGkVEIFzB3brxWv4clJ
5e/kMjWeGsEy7R+cb/YHd+yfEFEOYvZl2MMdE3PPPUMWaC6YIGXqobA/1WyTXcGG
UIqUm4IWTIpGSMQZ/aimsh/dAyw7gdEkkEuu4afp9xbGw2QnYhc+HMqyFbxWr+9K
iEX88mH6NOrz4fSzEZmRGZOJdQIboXDGbPmL93uYwcAlLYDUsWzf+pXbrSJrJh5I
JF/Ljk4rtzEYbhLqNsMd3HrajqvxjemQXOijGfM6oIxnJ/mzwAWfAbi9CocNz3vm
f/yNzpsvZjrMK+y9qSXAXkq3zswTZAFhuq7DlOD0Bd3EZ1wnGrGNaxtWNXYTdOuw
UxayS0xiwbB8HBG3XfHu7XArkpb3/v7lKQMPBmG6dturvpFm7h0lrSgZBW+fF8Jh
1Wmwb2004Nusap4laQVGWl9ybvZw8EDHBGKJxAvWFyRbASJajlMpMlUQ6EGuF7L3
3Y8L0kJpgeZD/jqEWvHVOjdt0qouxQTzpcvcFAt4bUCN6ToTUpVlkR2o0nGlAEp0
9u+Qfv2eERdTTXqmGiGyADT1gwAqWtcl7d7ugzv2aSpQoN9DhjXTIxALlzONjPxj
TVa0ragBb79JsrF+49f0
=Jdha
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_15_10_51_+1100_=+DQ42.D5a6eruEb--
