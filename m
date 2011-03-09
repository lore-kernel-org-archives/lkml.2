Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1CIAWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:22:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33500 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706Ab1CIAWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:22:04 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-lCEVQB91eekdBOJnn8BY"
Date: Wed, 09 Mar 2011 00:21:51 +0000
Message-ID: <1299630111.4146.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 0/5] Fix build failures with binutils 2.21
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lCEVQB91eekdBOJnn8BY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

gas has been silently ignoring .size directives with typos, but this was
fixed in binutils 2.21, resulting in build failures with the new
version.

I collected a couple of fixes for x86, then saw a similar failure on
sparc and went hunting for more instances.  This series, based on
2.6.38-rc8, should cover them all.  However, my changes are not even
build-tested.

Ben.

Alan Modra (1):
  x86: Fix .size directive for async_page_fault

Ben Hutchings (3):
  sparc: Fix .size directive for do_int_load
  avr32: Fix .size directive for cpu_enter_idle
  arm: Fix .size directives for __arm{7,9}tdmi_proc_info

H.J. Lu (1):
  x86: Fix .size directive for xen_do_hypervisor_callback

 arch/arm/mm/proc-arm7tdmi.S            |    2 +-
 arch/arm/mm/proc-arm9tdmi.S            |    2 +-
 arch/avr32/mach-at32ap/pm-at32ap700x.S |    2 +-
 arch/sparc/kernel/una_asm_64.S         |    2 +-
 arch/x86/kernel/entry_32.S             |    2 +-
 arch/x86/kernel/entry_64.S             |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--=20
1.7.4.1



--=-lCEVQB91eekdBOJnn8BY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATXbIEue/yOyVhhEJAQqMPxAAuw4TGiDdsPdPjPDoMIQvcjEbV/+uK6s5
I7KXIK6LS8FGDlNDF7AZjrW5fonJXdafjKIAIq7OAQq0xAWysPHnb70pQ4E3dxdW
431DhHz1ZDnNQMd4mKWI3ONR1Na0jER2bdTe5FGTqccMXb6TVMhxswvR38wlJspk
fk3jwp2r7PMkWN1LLyWPudOEcwToJrmF8D/NIuFtkCm2q+sjvOSUcecoRYROEsib
ZtxbF1WX8FzBzrfk+zBKdayUpMo1gZvzB36zsVaWJCLWs0lbyN2HJQ7vDyfiLrFs
q09GZihLRA/0iEx9M1ZlqKsln+fP/icqjtvCrM616NioQP3aFyOdW9OxUfQMkI8q
u3irjEydxZ/xw5gLfuoqxdJsYUZVvEia3ybe4qVksN1yNAmjaATmKs0OOqsJdUTJ
5BLlvzq+a6BaAgXhfqys6g7SajwLHq4LI+D+pMnS6sNkpVoKAJkbphI0mvM/XguL
3O8SXq8TmQI/7t2NgAQlJVDbQ57hlopkS2d9riaNSb2YJo+CgEL8X+QrtfA5Lq6i
YRd51YRhgogVsTipV+GPT4OpmHvDHbVF1m7tbH7Vy3xv3lnYBdorq3INw/G2/vwk
0zKTTn9pGlxUmGN2Isbg4sD+B5DCmPhgTvMafC3sKaFUmQBni375FB5K7/YKhRxR
YCun04dSpRU=
=bGlp
-----END PGP SIGNATURE-----

--=-lCEVQB91eekdBOJnn8BY--
