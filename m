Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab0EaTOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:14:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40844 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab0EaTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:14:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/5] perf stat: add perf stat -B to pretty print large numbers
In-Reply-To: Your message of "Tue, 18 May 2010 23:08:16 -0300."
             <1274234900-12162-2-git-send-email-acme@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <1274234900-12162-1-git-send-email-acme@infradead.org>
            <1274234900-12162-2-git-send-email-acme@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275333099_6730P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 31 May 2010 15:11:39 -0400
Message-ID: <52092.1275333099@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C0409EC.0119,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275333099_6730P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 18 May 2010 23:08:16 -0300, Arnaldo Carvalho de Melo said:

(Sorry for late reply)

> instance LC_NUMERIC=3Den_US.UTF8. You need to pass -B to activate this
> feature. This way existing scripts parsing the output do not need to be=

> changed. Here is an example.
>=20
> =24 perf stat noploop 2
> noploop for 2 seconds
>=20
>  Performance counter stats for 'noploop 2':
>=20
>         1998.347031  task-clock-msecs         =23      0.998 CPUs
>                  61  context-switches         =23      0.000 M/sec
>                   0  CPU-migrations           =23      0.000 M/sec
>                 118  page-faults              =23      0.000 M/sec
>       4,138,410,900  cycles                   =23   2070.917 M/sec  (sc=
aled from 70.01%)
>       2,062,650,268  instructions             =23      0.498 IPC    (sc=
aled from 70.01%)
>       2,057,653,466  branches                 =23   1029.678 M/sec  (sc=
aled from 70.01%)
>              40,267  branch-misses            =23      0.002 %      (sc=
aled from 30.04%)
>       2,055,961,348  cache-references         =23   1028.831 M/sec  (sc=
aled from 30.03%)
>              53,725  cache-misses             =23      0.027 M/sec  (sc=
aled from 30.02%)
>=20
>         2.001393933  seconds time elapsed
>=20
> =24 perf stat -B  noploop 2
> noploop for 2 seconds
>=20
>  Performance counter stats for 'noploop 2':
>=20
>         1998.297883  task-clock-msecs         =23      0.998 CPUs
>                  59  context-switches         =23      0.000 M/sec
>                   0  CPU-migrations           =23      0.000 M/sec
>                 119  page-faults              =23      0.000 M/sec
>       4,131,380,160  cycles                   =23   2067.450 M/sec  (sc=
aled from 70.01%)
>       2,059,096,507  instructions             =23      0.498 IPC    (sc=
aled from 70.01%)
>       2,054,681,303  branches                 =23   1028.216 M/sec  (sc=
aled from 70.01%)
>              25,650  branch-misses            =23      0.001 %      (sc=
aled from 30.05%)
>       2,056,283,014  cache-references         =23   1029.017 M/sec  (sc=
aled from 30.03%)
>              47,097  cache-misses             =23      0.024 M/sec  (sc=
aled from 30.02%)
>=20
>         2.001391016  seconds time elapsed

Is it me, or did -B not make any difference for these two examples?
I'm confused.

> -	fprintf(stderr, =22 %14.6f  %-24s=22, msecs, event_name(counter));
> +	fprintf(stderr, =22 %18.6f  %-24s=22, msecs, event_name(counter));

> -	fprintf(stderr, =22 %14.0f  %-24s=22, avg, event_name(counter));
> +	if (big_num)
> +		fprintf(stderr, =22 %'18.0f  %-24s=22, avg, event_name(counter));
> +	else
> +		fprintf(stderr, =22 %18.0f  %-24s=22, avg, event_name(counter));

> -		fprintf(stderr, =22 %14s  %-24s=5Cn=22,
> +		fprintf(stderr, =22 %18s  %-24s=5Cn=22,
>  			=22<not counted>=22, event_name(counter));

> -	fprintf(stderr, =22 %14.9f  seconds time elapsed=22,
> +	fprintf(stderr, =22 %18.9f  seconds time elapsed=22,

Why is the 'if (big_num)' applied to only one of the 4 sites, and the
other 3 blindly expanded from 14 to 18 characters?

--==_Exmh_1275333099_6730P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMBAnrcC3lWbTT17ARAhefAKCJabf8cOHXA5G70DfuuYI4jml01QCeJ0BG
l/Y+wkEuV99QuUgyWRU7bQY=
=/T2i
-----END PGP SIGNATURE-----

--==_Exmh_1275333099_6730P--

