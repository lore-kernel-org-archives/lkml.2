Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0DNMLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:11:13 -0400
Received: from ozlabs.org ([203.10.76.45]:48732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab0DNMLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:11:11 -0400
Subject: Re: [PATCH] powerpc/perf_event: Fix oops due to
 perf_event_do_pending call
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>
In-Reply-To: <20100414064603.GA4714@drongo>
References: <20100414064603.GA4714@drongo>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PVasO5QlV5XfeYA5Awxf"
Date: Wed, 14 Apr 2010 22:11:09 +1000
Message-ID: <1271247069.3727.1.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PVasO5QlV5XfeYA5Awxf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-04-14 at 16:46 +1000, Paul Mackerras wrote:
> Anton Blanchard found that large POWER systems would occasionally
> crash in the exception exit path when profiling with perf_events.
> The symptom was that an interrupt would occur late in the exit path
> when the MSR[RI] (recoverable interrupt) bit was clear.  Interrupts
> should be hard-disabled at this point but they were enabled.  Because
> the interrupt was not recoverable the system panicked.
>=20
...
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index 1b16b9a..0441bbd 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -532,25 +532,60 @@ void __init iSeries_time_init_early(void)
>  }
>  #endif /* CONFIG_PPC_ISERIES */
> =20
> -#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_PPC32)
> -DEFINE_PER_CPU(u8, perf_event_pending);
> +#ifdef CONFIG_PERF_EVENTS
> =20
> -void set_perf_event_pending(void)
> +/*
> + * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
> + */

Any reason not to switch to per-cpu for both, now that you don't need to
access it from asm?

cheers

--=-PVasO5QlV5XfeYA5Awxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkvFsNkACgkQdSjSd0sB4dKXtwCdFSWKKxxitwjJwM+QXzgKad1z
jIIAoLprKHTqhJiKzFSAHbBV9HvoVcRs
=9xj3
-----END PGP SIGNATURE-----

--=-PVasO5QlV5XfeYA5Awxf--

