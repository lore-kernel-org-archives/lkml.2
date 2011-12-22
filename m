Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1LVF7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:59:01 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43339 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab1LVF67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:58:59 -0500
Date: Thu, 22 Dec 2011 16:58:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>, Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20111222165849.df5ea3e2997375de24f1490b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Dec_2011_16_58_49_+1100_YAObj.MuTJT6uYWE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Dec_2011_16_58_49_+1100_YAObj.MuTJT6uYWE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: expected ')' before=
 'KBUILD_MODNAME'
drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' un=
declared here (not in a function)
drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: expected ',' or ';'=
 before string constant
drivers/net/wireless/ath/ath6kl/init.c:32:1: error: expected ')' before 'KB=
UILD_MODNAME'
drivers/net/wireless/ath/ath6kl/init.c:32:1: error: 'KBUILD_MODNAME' undecl=
ared here (not in a function)
drivers/net/wireless/ath/ath6kl/init.c:32:1: error: expected ',' or ';' bef=
ore string constant
drivers/net/wireless/ath/ath6kl/init.c:33:1: error: expected ')' before 'KB=
UILD_MODNAME'
drivers/net/wireless/ath/ath6kl/init.c:33:1: error: invalid initializer
drivers/net/wireless/ath/ath6kl/init.c:33:1: error: expected ',' or ';' bef=
ore string constant
drivers/net/wireless/ath/ath6kl/init.c:34:1: error: expected ')' before 'KB=
UILD_MODNAME'
drivers/net/wireless/ath/ath6kl/init.c:34:1: error: invalid initializer
drivers/net/wireless/ath/ath6kl/init.c:34:1: error: expected ',' or ';' bef=
ore string constant

I can't figure out what goes wrong here.  On the compile command line,
KBUILD_MODNAME is not defined, but KBUILD_BASE_NAME is.

However, reverting commit fde57764ef87 ("ath6kl: enable USB support")
made the problem go away.  That commit caused the above two files to be
built into two separate modules.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Dec_2011_16_58_49_+1100_YAObj.MuTJT6uYWE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8scZAAoJEECxmPOUX5FEVr4P/3nqrG7OJ7R92D0uTEzgD4uX
664SYUGxK8yXjmIs6H5e1gYyeYg/2sj2xP4EKW+8NzHdmqXji27KIVexLsBLK1YZ
OmFNQaBFSqfdpz09TrhPl23xM9SxJN1E4bmdLbg4xCYfq+5kVHGgSBFTXVeRHNpg
QC5OXP2f5xpQ9VkjLJ4EZyRHdpjkP9IifRXfj0+jx7I/Go2AWWo8JyP31PllNQv2
8OZcirzluLT0oYLChFVQu3oqHTd6UHBEFict5KMPVXLQByQrjBIu+wo9RIQ2+nsw
ZiBiNZ9wmdXtMje5rh/I4nekvd79rz1nKwriB7odQFxypMpaFmXPACa0b3u2MQus
W16Qq6qEFYAl4b3+CtJULpm1iDKEYJI7mt4jgsvgEc6y0foS5xvdvlsrYoYa1qOr
xT6ZqrhiA1duOPtcaO2rJx9kge6E+Jf2XzgLagYHN8TQJkudjhTcGfwIQuZNio+2
YosfeVIiVp86/chH/zfbQnQurbs9lx2Fqpnita2cKUQ+5oz9dickzCaFSNGSyOER
/tPNo9vEaCoLxfKSvYASVGfdObDDe2XfwYmNo9ZP3qNH3j/bysp5a/VVCJ7big5b
AiWfbIOcqBXaglSN9sbPTqkqFoPt7cS5dXKu+pbygpiP5NFeGuSetGJ9Y2Al131N
bQC6TzBb2rXGvnGqFM+Y
=0kbt
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Dec_2011_16_58_49_+1100_YAObj.MuTJT6uYWE--
