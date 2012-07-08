Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2GHXka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:40:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40855 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2GHXk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:40:28 -0400
Date: Mon, 9 Jul 2012 09:40:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: linux-next: comment on pm tree commit
Message-Id: <20120709094013.88a1117c9ef4510555147280@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jul_2012_09_40_13_+1000_aI/1g8FqOhZNB/sp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jul_2012_09_40_13_+1000_aI/1g8FqOhZNB/sp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

I noticed commit b8eec56cd8e5 ("PM / cpuidle: System resume hang fix with
cpuidle") in the pm tree needs some work (I noticed it because it was
changed in a rebase ...).

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index a6b3f2e..b90ccb2 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -146,6 +146,8 @@ extern void cpuidle_unregister_device(struct cpuidle_de=
vice *dev);
=20
 extern void cpuidle_pause_and_lock(void);
 extern void cpuidle_resume_and_unlock(void);
+extern void cpuidle_pause(void);
+extern void cpuidle_resume(void);
 extern int cpuidle_enable_device(struct cpuidle_device *dev);
 extern void cpuidle_disable_device(struct cpuidle_device *dev);
 extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
@@ -169,6 +171,8 @@ static inline void cpuidle_unregister_device(struct cpu=
idle_device *dev) { }
=20
 static inline void cpuidle_pause_and_lock(void) { }
 static inline void cpuidle_resume_and_unlock(void) { }
+static inline cpuidle_pause(void) { }
+static inline cpuidle_resume(void) { }

These need to be "static inline void".  I wonder what review and build
testing this went through (the above should produce warnings since they
are non void returning functions with no return statements).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Jul_2012_09_40_13_+1000_aI/1g8FqOhZNB/sp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+hpdAAoJEECxmPOUX5FEieYP/1ARW6uSbPcfEOpAynMyvaTU
A8KiMQUvoU9UYkAJ5TUPJMJ/Es8lEbVKwqLVhJmpq+02QdeuO+bFiMNUX5BbGZUO
ZHqMlAhT3r6vbFPh1XDVfBEGwAmYTOk8h8Zh7B5z8NGu0cHtFLYKFScPPP6GFOaw
s+UD51/ufwQHz73yA8ogDmRcHGpEtRH3LevtSptcQW6fO4lIo9Qx517QY9GI0bvs
A2EWqVQR29w8CDLzXfu6rdDPFTyI6WHR+5HsZ5Xu8Hhg3p5Fa5okqMQjFg6WZaHt
aDnBEypT9X09RHRd2A9C6pSKMklpVIvkZdQPH+wDj5qy6zd43J+HUFy9aKPmn+tz
BsyGqgHISD7Z6frseDHCjPvpUVfu2XiVrSRAMrGMbhMsWDOk7NaF1dSA/m5UkAOJ
ESt3erEje0mSYJtc+OTc8lhu16xEIuUh5HcxAZZ4uJjzwdxQZto8Yxkg+M2yqRnF
xNC85UyRbgTdDifUDktLn0zPuVa1xXlXURVErogOMUz9TbkHGLpCvwyN2/I8RfNM
V+9ay+tphLg5rSwmTQmiB0Wc5OYhfgtNzsgbTxG8kdMJW4NxxyMyUWnOqaVBVcto
8rjqgZMwcKIyMAvPZoj8nZDcyxxkuFlLmPawpoEXCuBwzLp+oBt7ha4ADwBQQdb8
yKxzZtQk6/5h/mmoJQCQ
=HkOY
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jul_2012_09_40_13_+1000_aI/1g8FqOhZNB/sp--
