Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2FHN4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:56:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2FHN4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:56:06 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=a4xMR2lfcRIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ZlJI7upBH1w3o6mRYzkA:9 a=QEXdDO2ut3YA:10 a=yek-8vtPH7jf_aDUdqoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120608135200.371649691@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 09:52:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/3] [GIT PULL][3.6] x86: cr2 and cmpxchg issues of NMI
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

As Avi brought to attention, there may be issues with NMIs and page faults
as if a NMI takes a page fault it can corrupt the cr2 for a page fault
handler that it preempted. The first and third patch fixes this for x86_64
and i386 respectively.

The second patch is to fix the cmpxchg issue brought up by someone on LWN.
The NMI handler for i386 uses cmpxchg to handle nested NMIs. But some
older i386 boxes do not have a true cmpxchg and this will fail for them.
Luckily, there is a simple fix that also makes the code cleaner.

Please pull the latest tip/x86/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/core

Head SHA1: 7fefda3109021f98926d76a13f90d0b116ce3db5


Steven Rostedt (3):
      x86: Save cr2 in NMI in case NMIs take a page fault
      x86: Remove cmpxchg from i386 NMI nesting code
      x86: Save cr2 in NMI in case NMIs take a page fault (for i386)

----
 arch/x86/kernel/entry_64.S |   20 +++++++++++++++++
 arch/x86/kernel/nmi.c      |   51 +++++++++++++++++++++++++++++++---------=
----
 2 files changed, 56 insertions(+), 15 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0gRvAAoJEIy3vGnGbaoASO8P/2VJuWuibFtAnB5CRyr5hhWA
SA34NufCG9aiKifJsmL/xPWD8NU5+3pyoD9aMM7uBntHT2Ui0Wz0PKC2BZJM7boe
60BX7MtoVlJN+uHS9D68TG0USxn3qBIN1TgEC/w2pEbn3upWaA9HQdgU0+ItOaBx
UB9IWjkF/oN6n0a5LM3r4bqwjJt9QqKziAsHHkeM/sFMYymXJGSV9JpfadiASuSN
1eU65jDE5XmO5ulH8fnE6UzksqsiSCsOsNrfGuJUSC29q41ARyhO1cZ0Db6x7LSn
+TEYqmIteUqs/sbV6likh8xKs2HJadug9DN10eAjeYd00A+bA3MWy9mNASYlSuGo
/ouGVIQUKHIH/kJgY9cAM8Rl0tGMJw/EIDNJeztrwYumhTNxuJEpsGMNvRtzrmAX
gQIBwUS2cJZ78Tww2aSmHn3poU+h7SSs1pzS9npJ8MZy2fH8KAYLbw3UWROMCNCH
nsyq6k5bCC2WEcjNotnTXbBIwBdeyWALJY+Roy0Ui3k3Bodq3qJWahVtKt0Y9XLU
/mKYej/VE9KCW0d/QJM+MeML2Lsft0zrUGmPzZ9DyL1QhBErN34tHJkNmeU2kOBE
W5tcKLBCsGtsMmevn+U4MBj7vR6x/c3VgAIaKraBv17Mg+ESWRHBXRwPeAr8VWrq
ZaNr5NZ4q1ZegrTnKfwA
=0Kva
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
