Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0LRKyL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 05:54:11 -0500
Received: from c-98-249-9-36.hsd1.va.comcast.net ([98.249.9.36]:33976 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753439Ab0LRKyH (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 05:54:07 -0500
X-Greylist: delayed 2571 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Dec 2010 05:54:06 EST
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        linux-mm@kvack.org
Subject: mmotm 2010-12-16 - breaks mlockall() call
In-Reply-To: Your message of "Thu, 16 Dec 2010 14:56:39 PST."
             <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1292667059_131643P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 18 Dec 2010 05:10:59 -0500
Message-ID: <131961.1292667059@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1292667059_131643P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Dec 2010 14:56:39 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

The patch mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
causes this chunk of code from cryptsetup-luks to fail during the initramfs:

	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
                        log_err(ctx, _("WARNING!!! Possibly insecure memory. Are you root?\n"));
                        _memlock_count--;
                        return 0;
                }

Bisection fingered this patch, which was added after -rc4-mmotm1202, which
boots without tripping this log_err() call.  I haven't tried building a
-rc6-mmotm1216 with this patch reverted, because reverting it causes apply
errors for subsequent patches.

Ideas?



--==_Exmh_1292667059_131643P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNDIizcC3lWbTT17ARAoqyAJwJgWcv6nVI2dPt5mjCr5CFhzwa8gCfcP0p
LtHJhxD89wxagNQco+pC6js=
=8EEn
-----END PGP SIGNATURE-----

--==_Exmh_1292667059_131643P--
