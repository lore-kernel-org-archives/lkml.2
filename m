Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892Ab1IUUzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1IUUzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:55:11 -0400
Date: Wed, 21 Sep 2011 15:54:55 -0500
From: Clark Williams <williams@redhat.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <ce@ceag.ch>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: rt-tests-0.82 available on github
Message-ID: <20110921155455.61ab4745@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vwrDA_NmV7Mf._HrCcKIRhO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vwrDA_NmV7Mf._HrCcKIRhO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

While kernel.org is sorting out the security stuff, the rt-tests code
may be pulled from:

	git://github.com/clrkwllms/rt-tests.git

Note that we're now at version 0.82. Presently I only have the git
archive available (no tarballs).=20

While investigating latency spikes in the 3.0.x-rt kernels, Thomas
spotted a case where an Intel quad-core Xeon was going into deep
sleep states and were all fighting to come out of sleep at the same
time (and consequently causing a big latency spike in cyclictest).=20

While trying to figure out how to prevent deep cstates I remembered a
conversation I had with Arjan at the last Plumbers conference in
Boston. He mentioned the /dev/cpu_dma_latency interface to the power
managment code and that if you opened it and wrote a zero to it, you
effectively put the system into "idle=3Dpoll" mode until you closed the
file descriptor (see: Documentation/power/pm_qos_interface.txt).=20

I've added a set_latency_target() function to cyclictest that by
default opens /dev/cpu_dma_latency and writes a zero to it, then holds
the file descriptor open for the duration of the cyclictest run. This
made a *huge* difference on some Intel Xeon's. Without this option, when
I was running cyclictest with the -b option, I saw latencies over
300us. When I added it, while tracing I never saw a latency over 30us.
Turning of -b, I never saw it go over 10us. I am doing further testing
now with other x86_64 systems.=20

Of course this is very architecture specific, so YMMV, but I think it's
a valid mechanism to be used when measuring latency and I believe a
technique that many latency-sensitive applications might use to good
effect.=20

Clark

--Sig_/vwrDA_NmV7Mf._HrCcKIRhO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk56TyAACgkQHyuj/+TTEp1mOwCgwVkhbSEJNGA0T3hlNHrudjEI
F6oAoLsuVcyZ6uemn2I4aRo+0gi2VwhT
=fcnr
-----END PGP SIGNATURE-----

--Sig_/vwrDA_NmV7Mf._HrCcKIRhO--
