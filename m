Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1JYHkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:40:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37058 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1JYHkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:40:14 -0400
Date: Tue, 25 Oct 2011 18:40:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: manual merge of the tip tree with the cputime tree
Message-Id: <20111025184002.d70aeb245a4b9016635df242@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_18_40_02_+1100_qt6QLVT/1RvvACbB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_18_40_02_+1100_qt6QLVT/1RvvACbB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/asm-generic/cputime.h between commit f6116715d1ba ("[S390]
cputime: add sparse checking and cleanup") from the cputime tree and
commit ef0e0f5ed9bd ("cputime: Clean up cputime_to_usecs and
usecs_to_cputime macros") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/asm-generic/cputime.h
index 77202e2,62ce682..0000000
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@@ -23,10 -38,8 +23,10 @@@ typedef u64 __nocast cputime64_t
  /*
   * Convert cputime to microseconds and back.
   */
 -#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
 -#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
 +#define cputime_to_usecs(__ct)		\
- 	jiffies_to_usecs(cputime_to_jiffies(__ct));
++	jiffies_to_usecs(cputime_to_jiffies(__ct))
 +#define usecs_to_cputime(__msecs)	\
- 	jiffies_to_cputime(usecs_to_jiffies(__msecs));
++	jiffies_to_cputime(usecs_to_jiffies(__msecs))
 =20
  /*
   * Convert cputime to seconds and back.

--Signature=_Tue__25_Oct_2011_18_40_02_+1100_qt6QLVT/1RvvACbB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpmfSAAoJEECxmPOUX5FEJVEP/A5DYEthr5OhtLUsEw1S5fPO
+vDvMmersy/XOscNDkfzG+ZZLqijZgjdiwgn95EbZwuRIZVFTIDg3VcXmRj5kTRr
vP078yp3ninQcsZU8pKypeAKdWaqjKx0Z5LIh7CNwivaV2w+pZbsGxYvzE6VsLJm
sIE9z1Q2OXKI9vfOgDNRedJjXsuZbPzEF1VGr3UPMzL/eOSUG65lXWK7YLQ6TJJ7
LFyHVokvS9m8t1DkH+P0jFvlywE0B8el5aI7i+VUxy84J4uLtbeRqJREZjtL8+AC
o3HYkEn8+b2vSwPiEMc5CzSnAdgXpNy7nGbsYyt7hwJoET0rvjutCX4MwZ0vIwHM
5HwZu7KHBpXU7vrZlZFE+vfiJ/IKD9umpReoI9d8WmQvLXwIRnLu9rfGoxzv0+EC
4/EVmVE08UxQ5B7Wc5t7saTGVPRsrmP8k6huGXs6WTuRXGZbVSwTEdTWm/f77YVl
biFrVn/kjHHY2whwO2RMxpGQNFNj734GAZNPWyuqLKX0o67MS9THdwAAgXaUNQF5
lFUAURFCPojn1QyXNKTYew8upm+LK1lBLM2aW2EW9SUzuuCXdrAa9pgPbMzgk1y9
6fmH33DjPblwbdH3yMvmoHA82EbBP06yRsQDtZZJnokQgGEOWPTe+mzXoEogsScU
YMGDZMyKx0FQRXgzKNNL
=DTLS
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_18_40_02_+1100_qt6QLVT/1RvvACbB--
