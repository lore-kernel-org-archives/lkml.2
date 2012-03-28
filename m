Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2C1Qon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:44:43 -0400
Received: from narfation.org ([79.140.41.39]:37166 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab2C1Qol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:44:41 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2012 12:44:41 EDT
From: Sven Eckelmann <sven@narfation.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: simon.wunderlich@s2003.tu-chemnitz.de,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Using nested locking for spin_lock_bh
Date: Wed, 28 Mar 2012 18:36:39 +0200
Message-ID: <2108147.Aqyix6xDmB@bentobox>
User-Agent: KMail/4.7.4 (Linux/3.2.0-2-amd64; KDE/4.7.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1377973.Og34iP4ssK"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1377973.Og34iP4ssK
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I started to run some experimental batman-adv code inside some virtual 
machines with different debugging functions enabled. One of them was lockdep. 
There we noticed a false positive for a lock class that is actually used in 
two different data structures. Therefore, lockdep noticed that there could be 
a deadlock for this class in a function that locks the two different data 
structures.

To resolve this problem, I wanted to define two different subclasses and 
replace the spin_lock_bh with its nested version. The only problem now is the 
absence of spin_lock_bh_nested. I could only find spin_lock_bh and 
spin_lock_irqsave_nested.

Is there another way how this should be done or is there a general problem why 
there is no nested support for this incarnation of spin_lock?

Kind regards,
	Sven
--nextPart1377973.Og34iP4ssK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJPcz4XAAoJEF2HCgfBJntGXmkQALWelTOEcM2XPUfC5RGSm6EM
pe+CefcvdvLks/qXlNaVM7L6+ttlh/oGTD9ffVKIQRYY9iBy+xHQ1tcb7hU2TxQo
ZsYiCycMPq0Zeio50VbMpYBoOQbnZBOyIMosL3zymlyjV4QiRS12Lu3qMAY4gguK
Qkj33Y93pPri/7bOfYGKkakokINxllJt5XlhZf9OnvqPV9p+ylQWOdGuaQ5u/hMa
T8vnoFRxD5vpD7vHXyrhWJJk/MAwvzenS9tXpC9P58l+vwLgNBEDFTYWbZIl4441
+Dc+NBBuIiQhV1xTz3jm9Jp5n0/ed8g0DjL4HEmAAgiItDKzWz6bFQo2fZU1KauM
ekPXAxhHpSwtJDRmVYNXv6AtSC/bS7hFGRnipUGOw7aezeDbcM4G2wrnIsvuG/7f
9T9xazgEQDoc8+j3SOLcF4zpz0njniKJZ6awZqrBcyAQaknLgbt5mbENnSm81azs
MmzkUvEUi7HudeP/vAJ2kNZBUdztMhQcxxSIK/GryzsDZqEC5I8257DfC7GUoH/T
FDRcirkvFNANwPSK9/+ZCg+0Y3bU/BjDsE9AxrWys4hZavgliHyVmh+PUvST+P+A
nYEJpNf4PUNpQn4Ru6KbAcw7V0BsdqTAwDHmYkD3QFsQObSQfuZW8Fi2ghnyyXa6
92Lz5vSa2R1Pg8sfOiSC
=MrXm
-----END PGP SIGNATURE-----

--nextPart1377973.Og34iP4ssK--

