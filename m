Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2KZLzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:55:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39995 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2KZLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:55:00 -0500
Date: Mon, 26 Nov 2012 22:54:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: linux-next: manual merge of the signal tree with the cris tree
Message-Id: <20121126225448.7589f3cb8f6fffe15a22a365@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_22_54_48_+1100_2mIPsA/A5NR3_Yaz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_22_54_48_+1100_2mIPsA/A5NR3_Yaz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/cris/include/asm/signal.h between commit e717abac8a9f ("UAPI:
(Scripted) Disintegrate arch/cris/include/asm") from the cris tree and
commit 7407ba05050c ("unify default ptrace_signal_deliver") from the
signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/cris/include/asm/signal.h
index b3c5ef0,72dbbf5..0000000
--- a/arch/cris/include/asm/signal.h
+++ b/arch/cris/include/asm/signal.h
@@@ -33,11 -126,32 +33,6 @@@ struct sigaction=20
  struct k_sigaction {
  	struct sigaction sa;
  };
 -#else
 -/* Here we must cater to libcs that poke about in kernel headers.  */
 -
 -struct sigaction {
 -	union {
 -	  __sighandler_t _sa_handler;
 -	  void (*_sa_sigaction)(int, struct siginfo *, void *);
 -	} _u;
 -	sigset_t sa_mask;
 -	unsigned long sa_flags;
 -	void (*sa_restorer)(void);
 -};
 -
 -#define sa_handler	_u._sa_handler
 -#define sa_sigaction	_u._sa_sigaction
 -
 -#endif /* __KERNEL__ */
 -
 -typedef struct sigaltstack {
 -	void *ss_sp;
 -	int ss_flags;
 -	size_t ss_size;
 -} stack_t;
 -
 -#ifdef __KERNEL__
  #include <asm/sigcontext.h>
 -#endif /* __KERNEL__ */
 =20
- /* here we could define asm-optimized sigaddset, sigdelset etc. operation=
s.=20
-  * if we don't, generic ones are used from linux/signal.h
-  */
- #define ptrace_signal_deliver(regs, cookie) do { } while (0)
-=20
  #endif

--Signature=_Mon__26_Nov_2012_22_54_48_+1100_2mIPsA/A5NR3_Yaz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs1iIAAoJEECxmPOUX5FEUYAQAInTVZ4nl9Tl3mR3dpg4v50Z
HMxM/5ayCrjY1mcOk7L8r1KELBk2fPFe+lN4lOhLk0OYtz7ZPLO7ZsCiCoobY8Yl
X5EGr7+WIw2CEz9T4M5YFGi6aDKPICSysM6UonbnFyNjCD/Sw4FAPpGxoN7pBLe/
eqk0ILd9etu7ldquaNV6B8SEJ8IiWjLv+0TTTfpUVbt+fXk9FWDbu0zSStjbDCLD
Dm8DfsNlCVrLLNrj5Rv/zbFokiK5xFBJzzEuQnnsf4fcRuVQ6lsZ0ilu7pmP9VSP
G3ldnEtbvHnmIlkbuFADhUq1OSGLz69UgXj0iqs1OmNNvqCk8i0bpbN9+JQdQ/Ja
hsBzpMhJQSCJoFzQ9VbAtTRDJkPA2VvvKa6g9b77qOtD0ntHulmt4zmEAS3my1x8
6/wno/8GaPm6Uc3ZEcqoyFgPspCR2VRXOtKjypHvqH1o9o0IMFfQ79aNKgOVo/a+
GRP6vr0EL400w6Nx7uWJsQLEoRUElwVysz910AtrxyiHnE6lg5o2fYyEJRjQ2uZL
FBn5TIZT0vwXEYIrIScrrj1oJSZVUo2r2cL9MNeYPCF/ItptIWUUZu0CzEtSQQcx
WefigZOn8ibqVrkZpt5pqSEzbPi28LtcTxnuIrLM19ai2CbFP+u90InV13rf+9f5
8w7P63Mn+AYhwBw/Rr0D
=L+oG
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_22_54_48_+1100_2mIPsA/A5NR3_Yaz--
