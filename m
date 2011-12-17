Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1LQEmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:42:36 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50852 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1LQEm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:42:27 -0500
Date: Sat, 17 Dec 2011 15:42:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20111217154219.5f3d476c25e648b1b4239857@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__17_Dec_2011_15_42_19_+1100_LCCPiHoCyKZDcayS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Dec_2011_15_42_19_+1100_LCCPiHoCyKZDcayS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (m68k allmodconfig)
failed like this:

drivers/leds/leds-tca6507.c:158: error: field 'gpio' has incomplete type
drivers/leds/leds-tca6507.c: In function 'tca6507_gpio_set_value':
drivers/leds/leds-tca6507.c:534: warning: type defaults to 'int' in declara=
tion of '__mptr'
drivers/leds/leds-tca6507.c:534: warning: initialization from incompatible =
pointer type
drivers/leds/leds-tca6507.c: In function 'tca6507_probe':
drivers/leds/leds-tca6507.c:618: error: implicit declaration of function 'g=
piochip_add'
drivers/leds/leds-tca6507.c: In function 'tca6507_remove':
drivers/leds/leds-tca6507.c:651: error: implicit declaration of function 'g=
piochip_remove'

Caused by commit 7a9244d89523 ("leds: add driver for TCA6507 LED controller=
").

Maybe this driver needs some dependencies ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Dec_2011_15_42_19_+1100_LCCPiHoCyKZDcayS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7B2rAAoJEECxmPOUX5FE1VcP/1uCPeTEy07bzLdzgMugqfEv
nB7J2Z/E376UlydCoHBaVZBdtXb3aqlPUSRdV12chFyVWMEg2RXk4155PaOyXED8
y2wMx21s1B5dupfIxBb8r5OIigkOGFu3l9pVUt+TUM8FejgQgN6tH+2Q/EJEANzS
bqLkeXV6Q6QXaB1OCwZhMBAaC9Y/pEQcEBMRqPHubEOzkT8MG68ZhGHBPAOOqaT9
bVM0W0hfZRT4tz0UVzjTD2UtIZnZc+dCZj2q9mLgJD3HeTL64M3gLyfQkrLbkXea
GzxzYIyhTzlyelYzIi4yU2f2XDDnQtu0UVNlcgTQOSHQd/mPmceGAmVCOzf2+PND
ILBfilNOd5ATsL023QKQsoBpkHZZPjB+AeblO2gsR9cv2NGxlDCgOPdT0TRccn30
fvwUXabHzhCjo1RvEJf5qEstF5nBzzqFlvxtfn/4tRG0lC/p8UbCURdl88+5JhGc
CtAvaLz7qeDlG6yb3Z00IC7dbzQ5WBqjcxjXn/Fwv7CSK0WHPKRZH1tE6qGEZWcs
7GxtDQZrBIn/Pti7Q1J/xY2o7YSguAQmGnV+Ex/UlA9/1JTh4taSfhCpbEelEIdf
D9ATq4Rx6tXrQMT0EtVtGa5jSmQ5x5nTH1JPWw5BxvMPzAG75O3mqNazBkky47E4
GEOKSfiGoCploMsspxzu
=C8x7
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Dec_2011_15_42_19_+1100_LCCPiHoCyKZDcayS--
