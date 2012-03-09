Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2CIHkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:40:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36494 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2CIHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:40:48 -0500
Date: Fri, 9 Mar 2012 18:40:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Lee <rob.lee@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the cpuidle-cons tree with the tip tree
Message-Id: <20120309184041.bd10edffa51dcd43ce069487@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_18_40_41_+1100_wPPm71vScCkQuqtX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_18_40_41_+1100_wPPm71vScCkQuqtX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the cpuidle-cons tree got a conflict in
drivers/cpuidle/cpuidle.c between commit 76027ea863fc ("cpuidle/tracing:
Denote the tracepoints as being in rcu_idle_exit() section") from the tip
tree and commit 9adbc67f6ecf ("cpuidle: Add common time keeping and irq
enabling") from the cpuidle-cons tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/cpuidle/cpuidle.c
index 6588f43,56de5f7..0000000
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@@ -92,15 -109,13 +109,13 @@@ int cpuidle_idle_call(void
  		return 0;
  	}
 =20
- 	target_state =3D &drv->states[next_state];
-=20
 -	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 -	trace_cpu_idle(next_state, dev->cpu);
 +	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
 +	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 =20
- 	entered_state =3D target_state->enter(dev, drv, next_state);
+ 	entered_state =3D cpuidle_enter_ops(dev, drv, next_state);
 =20
 -	trace_power_end(dev->cpu);
 -	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 +	trace_power_end_rcuidle(dev->cpu);
 +	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 =20
  	if (entered_state >=3D 0) {
  		/* Update cpuidle counters */

--Signature=_Fri__9_Mar_2012_18_40_41_+1100_wPPm71vScCkQuqtX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWbP5AAoJEECxmPOUX5FEMH8P/iNNw7ZbILnnNBwBGOo3QV7+
AVeUla19wawrg+0P/X8MYl61MVq5a8sO/YLXBIq06XFPsIYXRaEoDajO8vwzGs7I
ZCHepC0XwgT9YmjAAgUGGLtxbjpI4T6G2m7i+br04vYebROiGGExcy8G10De63MD
fpTzFXIFdFCAm+39Zf/n5rYGq7DGwYgELl+jqE1aoNWAwZ30oUuuqNBso5cLn69b
KNFSNZr7uF1RseJj5rfeOmkxIMhUJqhR/5EHn6gS7YuR/px81DrJAaaCTfhmnBcA
O3sFvyHe6j/BC9cdntb5IiqwZ384STdxoxbS5ImBf2jogpk7Dgs5uwLWV95QYcaY
2Qu4wX3F63UFTGDLID/8Kiwl6fFnvXUUPPH43qYmNdqfNRQTsnMYnBJVaVZcoOQ4
FE1667YDsb0/7A0bl3Mmc2iwGNmEYa21x+fU+b3T+dXkkEDXFDBQx2jH4YqRQkQ+
+n9vuWgY2oMEZnGA1OPWQxA2DVHFaxYOgSLxXfXxf88IJkjMvtWD8g7I+K/NhIsr
k3yUbWnxg5rJSGiijcnOAna468+EF8NXjlOVtxENVooGg/vxNXQGTyKKzGg7RlQ4
0Yeq2Kxizekoe5+Fvw4xRq7MauOAGA5bqCPT8jFxCIHGKC0jDZevgHwe+42Pcubh
gczOswDXiuObve8dsJtk
=b7FB
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_18_40_41_+1100_wPPm71vScCkQuqtX--
