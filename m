Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0JAJsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:48:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47407 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab0JAJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SKN1d+TPxQ4dYNABAWPeUxjrmaCeGQImLcp8Ra9tabjW491TLZnGdhf5RyxJlzePiG
         mKvGJLi4tmrrG7wU/d5G7hCHamn71lp7k9SpbKvf5Vy+ltRfJv9ruUtY/gFFJ2Ec2WCo
         fxl4ssRpg0c7H0ynD5RH79qX1JI7+jUr8yBpM=
Date: Fri, 1 Oct 2010 05:48:14 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later
Message-ID: <20101001094814.GA5029@roll>
References: <20101001035321.GA2360@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20101001035321.GA2360@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I was asked to do compile tests since I noticed performance regressions due
to my high loadavg issues. For these tests, I've disabled ccache so they
should be fair. The software being compiled is linux kernel 2.6.35.6 with my
normal kernel configuration file.

For the record, the only reason I have XZ_OPT="" is to disable this, from my
.bashrc:
declare -x XZ_OPT="-e --memory=1GiB"
which winds up being taken as an option to lzma, and causes unbootable
kernels for my computer. Not exactly what I want, so that's why I do that.

I was asked by con kolivas to do allnoconfig builds, but I wound up doing
the longer tests I'd been planning to originally since the differences
between the two allnoconfig kernel builds seemed to be simply noise. As you
can see from the below timed runs though, it appears I have a greater
mystery on my hands:

BAD kernel timings:
# bad: [74f5187ac873042f502227701ed1727e7c5fbfa9] sched: Cure load average vs NO_HZ woes

make mrproper && cp ../Hikaruconfig .config && XZ_OPT="" CCACHE_DISABLE="1" time make oldconfig bzImage modules
5680.36user 516.93system 1:51:34elapsed 92%CPU (0avgtext+0avgdata 738000maxresident)k
486208inputs+1991416outputs (254major+106505950minor)pagefaults 0swaps

make mrproper && XZ_OPT="" CCACHE_DISABLE="1" time make allnoconfig
5.45user 0.47system 0:06.19elapsed 95%CPU (0avgtext+0avgdata 95888maxresident)k
0inputs+1920outputs (0major+126579minor)pagefaults 0swaps


GOOD kernel timings:
# good: [09a40af5240de02d848247ab82440ad75b31ab11] sched: Fix UP update_avg() build warning

make mrproper && cp ../Hikaruconfig .config && XZ_OPT="" CCACHE_DISABLE="1" time make oldconfig bzImage modules
5669.54user 528.39system 1:51:11elapsed 92%CPU (0avgtext+0avgdata 738000maxresident)k
550632inputs+1991400outputs (335major+106506270minor)pagefaults 0swaps

make mrproper && XZ_OPT="" CCACHE_DISABLE="1" time make allnoconfig
5.44user 0.52system 0:06.32elapsed 94%CPU (0avgtext+0avgdata 95888maxresident)k
0inputs+1920outputs (0major+126547minor)pagefaults 0swaps


As you can see there is VERY little difference between the two compile
times. I wasn't expecting this - either I myself made an error when I did my
previous test compiles, there is a different bug lurking in 2.6.35.6 that I
happened to trigger at the same time, or the loadaverage bug is
inconsistently impacting performance. I really don't know; I will do
allnoconfig compile tests vs 2.6.25 and 2.6.25.6 as time permits and reply
to this thread. (I'll have to regenerate these kernels from scratch)

However it's obvious at this time that this specific commit I've singled out
from this tests results only appears to impact the loadaverage statistic and
may in fact not be causing a performance problem as I'd led myself to
believe.

Tim McGrath

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKWuXpEncCrqzVruAQKcRAgAkL5EhC8xjFX89s10ljZWAgsfF/uwf1iK
1VLppumX0Az02TLfehhYDuVhg90NJs/hMOpYZ5cFsSrNhGDGs1w/nSF+Z0VJFA0L
KjlZIbRcNqiN7FVhBYHOFQUi1Esdrk4OoY62wfvl1vvzFmfWwkx2srS/HAJDd1uL
x0p5NpWA6WYpL84KmzRfZQAeUYGrGLAZvy1DXsFmMDv75Si3pC5dy4nm9wmEGEeZ
+Csal3LVa2r68zx9W+gHPYSu/McQwy+JCYre+DQS4PQMwISVO4JRR4PJWf4m+M1w
qjzFtobLM0lpCZOkX2EUbgJ0OXkQAYNpaCfU+b5CTnYC+QZwDPdwog==
=L1PI
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
