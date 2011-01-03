Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1ACICA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 03:02:00 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:53295 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1ACIB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 03:01:59 -0500
Date: Mon, 3 Jan 2011 09:03:03 +0100
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [34-longterm 078/260] x86, tsc: Fix a preemption leak in
 restore_sched_clock_state()
Message-ID: <20110103080301.GC3611@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>, stable@kernel.org,
	linux-kernel@vger.kernel.org, stable-review@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Florian Pritz <flo@xssn.at>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <1293952756-15010-79-git-send-email-paul.gortmaker@windriver.com>
 <20110102101721.GA2277@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.36-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning,

Paul Gortmaker [Sun, Jan 02, 2011 at 02:16:14AM -0500]:
> From: Peter Zijlstra <peterz@infradead.org>
>=20
> commit 55496c896b8a695140045099d4e0175cf09d4eae upstream.
>=20
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index c65f741..4094ae0 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -655,7 +655,7 @@ void restore_sched_clock_state(void)
> =20
>  	local_irq_save(flags);
> =20
> -	get_cpu_var(cyc2ns_offset) =3D 0;
> +	__get_cpu_var(cyc2ns_offset) =3D 0;
>  	offset =3D cyc2ns_suspend - sched_clock();

If I see that correctly, this has already been merged before
2.6.37-rc7. As 2.6.37-rc7 again has the dark screen issue [0]
I assume this does not fix this issue.

I am compiling v2.6.37-rc8-33-gb518a64 right now, to give it
a try.

Cheers,

Nico

[0]: Subject: 2.6.37-rc7: screen black after several suspends


--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk0hgrUACgkQ19zI5DGHffA/cACg3v62+wL8umaLiQlDIOb5mC35
qJEAoLmV4xrOFDdevNu+bXJDsWotBrKg
=hdyv
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
