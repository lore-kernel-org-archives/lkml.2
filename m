Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0K1VgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:36:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48516 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603Ab0K1VgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:36:09 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jonathan Nieder <jrnieder@gmail.com>,
        604755@bugs.debian.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1mN0Id3oRkyxrAyDL5v2"
Date: Sun, 28 Nov 2010 21:35:50 +0000
Message-ID: <1290980150.3292.356.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [Fwd: Bug#604755: perf timechart: segfault in
 perf_session__process_events]
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1mN0Id3oRkyxrAyDL5v2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

-------- Forwarded Message --------
From: Jonathan Nieder <jrnieder@gmail.com>
Reply-to: Jonathan Nieder <jrnieder@gmail.com>, 604755@bugs.debian.org
To: submit@bugs.debian.org
Subject: Bug#604755: perf timechart: segfault in perf_session__process_even=
ts
Date: Tue, 23 Nov 2010 21:59:45 -0600

Package: linux-tools-2.6.36
Version: 2.6.36-1~experimental.1
Tags: upstream

Can't seem to get "perf timechart" working.

  $ uname -r
  2.6.36-trunk-686
  # perf timechart record echo hi
  hi
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.079 MB perf.data (~3471 samples) ]
  # chmod a+r perf.data
  $ gdb --args perf_2.6.36 timechart
[...]
  (gdb) run
  Starting program: /usr/bin/perf_2.6.36 timechart
  [Thread debugging using libthread_db enabled]

  Program received signal SIGSEGV, Segmentation fault.
  0x08061969 in ?? ()
  (gdb) bt
  #0  0x08061969 in ?? ()
  #1  0x0808998e in ?? ()
  #2  0x080888a6 in ?? ()
  #3  0x080894b8 in __perf_session__process_events ()
  #4  0x08089890 in perf_session__process_events ()
  #5  0x08060041 in cmd_timechart ()
  #6  0x0805210e in ?? ()
  #7  0x080527cd in main ()

Also was reproducible with upstream linux and perf 2.6.37-rc3.
Valgrind trace (source line numbers refer to v2.6.37-rc3):

	Invalid read of size 4
	   at 0x805B5C1: process_sample_event (builtin-timechart.c:505)
	   by 0x808654D: process_finished_round (session.c:410)
	   by 0x8085CF5: perf_session__process_event (session.c:633)
	   by 0x808732F: __perf_session__process_events (session.c:827)
	   by 0x80875CF: perf_session__process_events (session.c:867)
	   by 0x805BDE0: cmd_timechart (builtin-timechart.c:949)
	   by 0x804CCED: run_builtin (perf.c:286)
	   by 0x804D47E: main (perf.c:357)
	 Address 0x5416558 is 8 bytes after a block of size 72 alloc'd
	   at 0x4023F50: malloc (vg_replace_malloc.c:236)
	   by 0x8085EFA: perf_session__process_event (session.c:553)
	   by 0x808732F: __perf_session__process_events (session.c:827)
	   by 0x80875CF: perf_session__process_events (session.c:867)
	   by 0x805BDE0: cmd_timechart (builtin-timechart.c:949)
	   by 0x804CCED: run_builtin (perf.c:286)
	   by 0x804D47E: main (perf.c:357)

Is this a known problem?  Where should it be reported?

(Ooh, this time it wrote a timechart before segfaulting!  Apparently
v2.6.37-rc3 userspace + debian 2.6.36 kernel is the recipe for
success...)

Ciao,
Jonathan


--=-1mN0Id3oRkyxrAyDL5v2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATPLLMue/yOyVhhEJAQLwWhAA1gnCVRCQibLaSo7tA3jDX+Vf8incqTwm
J1haaPQfM0gyqy8Wt5KcVHKBzLqnsBJ/VrDZmYKzadAsOw5ijWaBe/rYJcvsh5et
0r+uLVHdZOZSDsC5iImFG9zK8lQfSExPi+YS8sBV4wvkODoCPUFyLvYMbfmK00Zs
nHgy12qdU8KAVWekMSwDW75SE2IO5vIG5uQkQvMJGfm4rXQDwUA6RmwrNGYmrzjy
vC8EP7qLsEXUhUcMGFz5Ak9yzBk5Nk5SXaw8/LrYEGuY6bB2ALsKwm7eEsRT0qm4
NMyLHrChQfspFMGZBge8Krl7UmjHooQI26avCtISPv1TPqb3iHyKTIagTapWLJXv
2AT19viyuc0jycfIM3BxHYi2Co2N6/3Lg4QalnjssiaqkWIPrNRXY5P98e4voLc0
mUbcqbYcH1C0K7Gy8ukjNESUVxVzUnutvvJsoFvlhx+F7dUaXkjSLTA+7jFvtU/r
dcpwCNagiMSDKXp0Q7tMpBPmVCecTlTtjhNvurAlqSqV9yCyxq5F6xiwE0dQsiLX
1fxBTHI1/JyfR2Bu+2wgelab44Zg4iFkj8wueH6gcem1x3SrLbeWW3QDdlZ8cCF3
7dpPdNXz2ck9qX4z8FGrIAw01JpcSUE51VS3Xf5UhUN36eQs+kD0b3b8PvjYr6Tm
/M7JtvfpajQ=
=Y1aE
-----END PGP SIGNATURE-----

--=-1mN0Id3oRkyxrAyDL5v2--
