Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0IMOGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:06:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57860 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0IMOGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:06:20 -0400
Date: Tue, 14 Sep 2010 00:06:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: build failure after merge of the final tree (tip tree
 related)
Message-Id: <20100914000613.51fdba90.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_00_06_13_+1000_i+sPqdSJ1xYdleXC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_00_06_13_+1000_i+sPqdSJ1xYdleXC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (many sh configs)
failed like this:

arch/sh/kernel/perf_event.c: In function 'sh_pmu_setup':
arch/sh/kernel/perf_event.c:342: error: parameter 'cpuhw' is initialized

And it went down hill from there.

Caused by commit b0a873ebbf87bf38bf70b5e39a7cadc96099fa13 ("perf:
Register PMU implementations") which removed the opening brace of that
function.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_00_06_13_+1000_i+sPqdSJ1xYdleXC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMji/VAAoJEDMEi1NhKgbs0CQH/3to8B+slCLQrcVuBgI9jor0
nY8eyFXFcvBFPKT0yqwbnSvhLTnyvyv/RcYJWcaRxDFx2Wo+2nD4aqbQ9XYqsUA0
8q8I3I4FkvkCWwkHjljv/iaYZjmoRT9r7UaKRrHo5+lrafHuxvIgJVE3T1ISXUPX
CwVXedszijtb3uaUxtS5b8Kirg0Qv4KVAMEKrK+oVJ72bNWQ1DsEXJDb6B5NyjPX
THVg4RV6HectmocZ6ujptDbUWY8Z2vbZIVrU3qjQy0KTnZV9iBP5nJZOiqne3iYc
RMyRvUt1FB+imtNHgOH2aieGPg0CtiiXEJGj25KPcgW1eQHrHGpIO+JBqxvjfVQ=
=HXyt
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_00_06_13_+1000_i+sPqdSJ1xYdleXC--
