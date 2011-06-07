Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1FGOnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:43:23 -0400
Received: from sense.xs4all.nl ([80.101.26.192]:51442 "EHLO love.zweije.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab1FGOnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:43:21 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 10:43:21 EDT
Date: Tue, 7 Jun 2011 16:37:09 +0200
From: Vincent Zweije <vincent@zweije.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Trivial Patch Monkey <trivial@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] networking: fix warning about unused label wake_up
Message-ID: <20110607143709.GA16841@love.zweije.nl>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Trivial Patch Monkey <trivial@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Vincent Zweije <vincent@zweije.nl>

Function ieee80211_reconfig in net/mac80211/util.c contains label wake_up
which is defined unconditionally, but only used with CONFIG_PM. Gcc
warns about this when CONFIG_PM is not defined.

This patch makes the label's definition dependent on CONFIG_PM too,
eliminating the warning.

The issue was apparently introduced in git commit
eecc48000afe2ca6da22122d553b7cad294e42fc.

Signed-off-by: Vincent Zweije <vincent@zweije.nl>
---
The diff below is against 3.0-rc2.

Thanks.
Vincent.

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d3fe2d2..05e3fb8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1276,7 +1276,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
=20
+#ifdef CONFIG_PM
  wake_up:
+#endif
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
=20
--=20
Vincent Zweije <vincent@zweije.nl>   | "If you're flamed in a group you
<http://www.xs4all.nl/~zweije/>      | don't read, does anybody get burnt?"
[Xhost should be taken out and shot] |            -- Paul Tomblin on a.s.r.

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN7jeSr5thWunKoTMRAiLsAKD5ZcknyOxJaAsGo7XPxPDxYWBSzgCg9WQm
wak6/xssqa5LhRmcYZeozqs=
=TL6G
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
