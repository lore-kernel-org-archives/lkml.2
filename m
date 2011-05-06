Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1EFDyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 23:54:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42469 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1EFDxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 23:53:54 -0400
Date: Fri, 6 May 2011 13:53:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysock" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (suspend
 tree related)
Message-Id: <20110506135345.a885d08a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_May_2011_13_53_45_+1000_ewtuQpQzJW8wg+f7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_May_2011_13_53_45_+1000_ewtuQpQzJW8wg+f7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

drivers/built-in.o: In function `_request_firmware':
firmware_class.c:(.text+0x385c8): undefined reference to `usermodehelper_is=
_disabled'

Caused by commit 3e61c4dd3e1e ("PM: Print a warning if firmware is
requested when tasks are frozen").  usermodehelper_is_disabled is only
defined if CONFIG_PM_SLEEP is set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_May_2011_13_53_45_+1000_ewtuQpQzJW8wg+f7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNw3DJAAoJEDMEi1NhKgbsLkMIAISP1t2N1mF3gSAMp4LQ7cTr
PIz7ACM+BK2ijyRhwvmrGlMKYOWl2pC3ye7lPZjmukTmh35bWcXgLEEvZB8/t0Gi
3lKmRFrcAFK+Lz/NVNkTvIa8d+Fw3Tqw9jcSi58OlQIe3sdNRvKnxQj8dzhaPmLg
ndCVMLAKTqHnyTWGtxpAq6LCzmBYJMFuwRbzrIiKsKDNyLWQsKPjXmzek750lxFc
jVpeYxx8XkE+gneJie2vXBLfSWhz86jBr8IJolVD9ZOwDYiv4skwf5Ik8zxPeNwu
jOK08c+HwagPfltSyflh8H/E71EK+xVGlIE2CvIcnqbmgOW37CgvjNrsomFvfXs=
=WCMs
-----END PGP SIGNATURE-----

--Signature=_Fri__6_May_2011_13_53_45_+1000_ewtuQpQzJW8wg+f7--
