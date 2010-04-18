Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0DRRuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 13:50:12 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:57380 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0DRRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 13:50:11 -0400
Message-ID: <4BCB464A.702@web.de>
Date: Sun, 18 Apr 2010 19:50:02 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: user-mode-linux-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: uml: pthreads instead of manual clone()?
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB072389367F5E104741C48CB"
X-Provags-ID: V01U2FsdGVkX19xtnZijnLlU9+z1e5XaJ8KlHxPG+zDDyt0Monu
	h2uQOF+y/rMnTTMZK2GfMozotY0MZI+Jo5om4ItJMLjyok6WG6
	oejJTA+rc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB072389367F5E104741C48CB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

is there (still) any reason to use explicit clone() instead of pthreads
to spawn UML kernel threads?

While playing with a patch to finally move os_nsecs to proper
CLOCK_MONOTONIC, I noticed some subtle side-effect: We need to link
against librt for clock_gettime, but that indirectly drags in
libpthread. Now gdb gets unhappy when you try to debug the UML kernel.
It assumes that pthreads are used, but fails to find their IDs and
terminates the session. So the obvious approach appears to be converting
kernel threads to pthreads - if there aren't any know pitfalls.

Jan


--------------enigB072389367F5E104741C48CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkvLRk8ACgkQitSsb3rl5xRlWwCg0j9oWDNFXcvSva4SFWx1Uo+o
znwAn0il7aX4P3Z/to2BT7JAKCuE8TYb
=01UP
-----END PGP SIGNATURE-----

--------------enigB072389367F5E104741C48CB--
