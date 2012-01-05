Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2AEIER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:04:17 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57785 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2AEIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:04:15 -0500
Date: Thu, 5 Jan 2012 19:04:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_19_04_05_+1100_o2/8t.ny=fksk7xR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_19_04_05_+1100_o2/8t.ny=fksk7xR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from include/trace/ftrace.h:567:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/power.h:240,
                 from kernel/trace/power-traces.c:14:
include/trace/events/kmem.h: In function 'ftrace_test_probe_kmalloc':
include/trace/events/kmem.h:45:1: error: implicit declaration of function '=
check_trace_callback_type_kmalloc' [-Werror=3Dimplicit-function-declaration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_cache_allo=
c':
include/trace/events/kmem.h:53:1: error: implicit declaration of function '=
check_trace_callback_type_kmem_cache_alloc' [-Werror=3Dimplicit-function-de=
claration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_kmalloc_node':
include/trace/events/kmem.h:99:1: error: implicit declaration of function '=
check_trace_callback_type_kmalloc_node' [-Werror=3Dimplicit-function-declar=
ation]
include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_cache_allo=
c_node':
include/trace/events/kmem.h:108:1: error: implicit declaration of function =
'check_trace_callback_type_kmem_cache_alloc_node' [-Werror=3Dimplicit-funct=
ion-declaration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_kfree':
include/trace/events/kmem.h:136:1: error: implicit declaration of function =
'check_trace_callback_type_kfree' [-Werror=3Dimplicit-function-declaration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_cache_free=
':
include/trace/events/kmem.h:143:1: error: implicit declaration of function =
'check_trace_callback_type_kmem_cache_free' [-Werror=3Dimplicit-function-de=
claration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_mm_page_free':
include/trace/events/kmem.h:150:1: error: implicit declaration of function =
'check_trace_callback_type_mm_page_free' [-Werror=3Dimplicit-function-decla=
ration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_mm_page_free_ba=
tched':
include/trace/events/kmem.h:172:1: error: implicit declaration of function =
'check_trace_callback_type_mm_page_free_batched' [-Werror=3Dimplicit-functi=
on-declaration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_mm_page_alloc':
include/trace/events/kmem.h:194:1: error: implicit declaration of function =
'check_trace_callback_type_mm_page_alloc' [-Werror=3Dimplicit-function-decl=
aration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_mm_page_alloc_z=
one_locked':
include/trace/events/kmem.h:249:1: error: implicit declaration of function =
'check_trace_callback_type_mm_page_alloc_zone_locked' [-Werror=3Dimplicit-f=
unction-declaration]
include/trace/events/kmem.h: In function 'ftrace_test_probe_mm_page_alloc_e=
xtfrag':
include/trace/events/kmem.h:267:1: error: implicit declaration of function =
'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=3Dimplicit-funct=
ion-declaration]
In file included from include/trace/ftrace.h:774:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/power.h:240,
                 from kernel/trace/power-traces.c:14:
include/trace/events/kmem.h: In function 'perf_test_probe_mm_page_pcpu_drai=
n':
include/trace/events/kmem.h:256:1: error: implicit declaration of function =
'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=3Dimplicit-function=
-declaration]

I have no idea what has gone wrong here, but I did not get this error
yesterday.  The only thing that touched include/trace/events/kmem.h is
patch "mm-tracepoint: rename page-free events" from the akpm tree, but
that was there yesterday as well and doesn't look suspicious.

I just have to leave things broken for today in the hope that someone
figures something out.  This does not affect my X86_64 allmodconfig build
or my PowerPC builds (including an allyesconfig build).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_19_04_05_+1100_o2/8t.ny=fksk7xR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBVl1AAoJEECxmPOUX5FEq+AP+wdD/Lk42O4ahhgZDPlD7Ba+
Dp0+UGGtgp4jeSuefEeLgsVwmT+e7jurk00qFL191DqIlyukFC4/rhyknqcMesgf
eKX7pBNj/m6PE1MWmSTS9TOJqYMyOSH3Sfeg8VgeF66mBaFDGwRkOstg9jBVnhtC
2nWDYBepPWcHNVpKk50s0/k6URi8g00GWh9aR0ih/+dtpHBoCeg8HYE6Eq8gFcHs
o+RFZl4y3Kpr4w2a4+P2XcrP2dq5BlfUcd9Hy8DhTB8y/05CMt68k/3NWjH878K/
c5F2Qyc5fmKx5YS4qIl4Ctpw1esIedj9+70bipyKxG5dgjjXcFsOOM+GAyep0cfx
X9JMhGSu/NtNuDWq0lmfbJ/tNLieh9tA0M0WwtqpvbR4Ahzc2HzLZDD5jLck20Mt
qtjR5gYc/e2nk9Y42AMUTwT7DuqpcOc19gNNuy3zn7VlctBOnUcxl8Q5cmV5Hi6Q
NPzbFS2X/1uVfLJG6unGkIBZhId6cWHmvUuOGo6szcy7v/J+mtipQH1ccbtxp23Y
UQpUTzVlTcr7M3sPCZZJmbqXtB5HWl/6OtRqkpXsWZHgLr7BRN2rR89CaRH9CkkN
JSs2mMkABiNJfSNIJPx/J4rGVAJM3SAYeNIRLC38lc1RZeZe6/Z/N6vFk5SYfvIb
vpM0hazh9xzJXV4BFXPC
=2z+e
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_19_04_05_+1100_o2/8t.ny=fksk7xR--
