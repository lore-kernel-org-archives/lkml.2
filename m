Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1HPCgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:36:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39251 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1HPCgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:36:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Subject: Re: x86 memcpy performance
In-Reply-To: Your message of "Sun, 14 Aug 2011 11:59:10 +0200."
             <20110814095910.GA18809@liondog.tnic>
From: Valdis.Kletnieks@vt.edu
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com> <20110812195220.GA29051@elte.hu>
            <20110814095910.GA18809@liondog.tnic>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313462075_2709P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Aug 2011 22:34:35 -0400
Message-ID: <6296.1313462075@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E49D741.0051,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1313462075_2709P
Content-Type: text/plain; charset=us-ascii

On Sun, 14 Aug 2011 11:59:10 +0200, Borislav Petkov said:

> Benchmarking with 10000 iterations, average results:
> size    XM              MM              speedup
> 119     540.58          449.491         0.8314969419

> 12273   2307.86         4042.88         1.751787902
> 13924   2431.8          4224.48         1.737184756
> 14335   2469.4          4218.82         1.708440514
> 15018   2675.67         1904.07         0.711622886
> 16374   2989.75         5296.26         1.771470902
> 24564   4262.15         7696.86         1.805863077
> 27852   4362.53         3347.72         0.7673805572
> 28672   5122.8          7113.14         1.388524413
> 30033   4874.62         8740.04         1.792967931

The numbers for 15018 and 27852 are *way* odd for the MM case. I don't feel
really good about this till we understand what happened for those two cases.

Also, anytime I see "10000 iterations",  I ask myself if the benchmark rigging
took proper note of hot/cold cache issues.  That *may* explain the two oddball
results we see above - but not knowing more about how it was benched, it's hard
to say.


--==_Exmh_1313462075_2709P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOSdc7cC3lWbTT17ARAr/1AJ9quwosDW/OPJDNOh40a1bS8i7QXwCgpxFh
8UCMlMWC3cBCx7YH+JUORvk=
=IvNi
-----END PGP SIGNATURE-----

--==_Exmh_1313462075_2709P--

