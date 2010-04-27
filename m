Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0D0Te5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:34:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab0D0Te4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:34:56 -0400
Date: Tue, 27 Apr 2010 14:34:44 -0500
From: Clark Williams <williams@redhat.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH:resend] rt: Remove CONFIG_STACK_TRACER from DEBUG_COUNT,
 and fix reminder block
Message-ID: <20100427143444.6a842e26@torg>
In-Reply-To: <1272396342-12504-1-git-send-email-jkacur@redhat.com>
References: <1272396342-12504-1-git-send-email-jkacur@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Lo5FmDJY.8cYV8BiW=/=VQ7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Lo5FmDJY.8cYV8BiW=/=VQ7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Apr 2010 21:25:42 +0200
John Kacur <jkacur@redhat.com> wrote:

> This fix does two things.
>=20
> 1. It reverts commit 3e39399ef4a742d994570488994be93ef17d4ef5.
> - The above commit added back a warning about CONFIG_STACK_TRACER
> NOT because the warning was necessary but to fix-up a problem where you c=
ould
> get an empty REMINDER block in the demg.
>=20
> However, CONFIG_STACK_TRACER really should not be in the reminder block.
> Even when configured-in it is not enabled, and thus has neglible impact.
>=20
> 2. It removes CONFIG_STACK_TRACER from DEBUG_COUNT which is the proper fix
> for the empty REMINDER block problem.
>=20
> This patch is for rt only. (this code doesn't exist in mainline)
>=20
> Signed-off-by: John Kacur <jkacur@redhat.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  init/main.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>=20
> diff --git a/init/main.c b/init/main.c
> index 592c16a..f26cb63 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -908,7 +908,7 @@ static int __init kernel_init(void * unused)
>  	WARN_ON(irqs_disabled());
>  #endif
> =20
> -#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_I=
RQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRAC=
ER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST)=
 + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defin=
ed(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRA=
CE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
> +#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_I=
RQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_INTERRUPT_=
OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENC=
Y_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + de=
fined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCO=
UNT_RECORD)))
> =20
>  #if DEBUG_COUNT > 0
>  	printk(KERN_ERR "******************************************************=
***********************\n");
> @@ -928,9 +928,6 @@ static int __init kernel_init(void * unused)
>  #ifdef CONFIG_PREEMPT_TRACER
>  	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                        =
                      *\n");
>  #endif
> -#ifdef CONFIG_STACK_TRACER
> -	printk(KERN_ERR "*        CONFIG_STACK_TRACER                          =
                      *\n");
> -#endif
>  #if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
>  	printk(KERN_ERR "*        CONFIG_FTRACE                                =
                      *\n");
>  #endif
> --=20
> 1.6.6.1
>=20

Acked-by: Clark Williams <williams@redhat.com>


--Sig_/Lo5FmDJY.8cYV8BiW=/=VQ7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkvXPFkACgkQHyuj/+TTEp01jwCfbVaJJzgMzq+j5dcIjFK+uV1j
+gwAnRfshp82tsD+IiamscKTnwjTDT/V
=joMt
-----END PGP SIGNATURE-----

--Sig_/Lo5FmDJY.8cYV8BiW=/=VQ7--
