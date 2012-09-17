Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2IQBYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:24:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55831 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2IQBYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 21:24:15 -0400
Date: Mon, 17 Sep 2012 11:24:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the arm64 tree
Message-Id: <20120917112405.4f7b7555209ad024e0531b21@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_11_24_05_+1000_jaVoA9cDuJm_G6+g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_11_24_05_+1000_jaVoA9cDuJm_G6+g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

After merging the arm64 tree, today's linux-next build ()
failed like this:

arch/powerpc/kernel/sys_ppc32.c:146:17: error: conflicting types for 'compa=
t_sys_sendfile'
include/linux/compat.h:593:16: note: previous declaration of 'compat_sys_se=
ndfile' was here
arch/powerpc/kernel/sys_ppc32.c:231:17: error: conflicting types for 'compa=
t_sys_sched_rr_get_interval'
include/linux/compat.h:596:16: note: previous declaration of 'compat_sys_sc=
hed_rr_get_interval' was here

Caused by commits 2a23f0dba0c6 ("fs: Add generic compat_sys_sendfile
implementation") and a0c6fc489bf6 ("compat: Add generic
compat_sys_sched_rr_get_interval implementation").  Grep is your friend.

I have used the arm64 tree from next-20120914 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_11_24_05_+1000_jaVoA9cDuJm_G6+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVnu1AAoJEECxmPOUX5FElD0P/262i1yPK6caz4lxmzLEULfe
fqtjKTrlFj2+Xk2r2ZbHTmB0S1kK6Sh41TSFmdweYUWsDjzjtBsc6tgbyEGyPNMT
fayn1dw5cT9kyQpDvDtYEI+EwgT7ZrcwQtEJ1kukSqoF+3Eq8sic/z8JvCv6Rs8M
RBxVEXNTPNOc6Hj0jpk/VNPJgguqaQGiaVF3+pvrSy1hPF0IWthxcSb0EVKoCKoW
OHNL1ZN7Y1MAo5E1DaMaUF/0PrY8EURdqO6EWwyyf0EMndleD4zn414jVC5W0eH0
nDdGf8zdc635AEnOo69UI/57e11pzyac26G5tGPlGiW4rHx5YwRPuk/hPydohSHj
f3ln/hqY6u8xYX3cQgvvE207L9PBDgTLfSFnrOZRzX4of597i54Ihqrt9ZjQkhVg
+74rOBWlPQPUePQQlraIp4/j5Jq2TG6cPw2ucIf3N8z3bPQs5oynD0UZwfkQia0q
OuIqJvsfuPVdaD+GSloFu/ktBfExiEDSn129NmHCAWWI1f8z94Wk57ETvI5LN8uT
PRM7ekPJwYYZNQKdzef6Us8n2rg7vJl/HHV9qcG4ZzYuut3zs7E9HrnJ4BQ1GgvE
JV9OemQX04Og01tAFtpuLCdne2yYwbgo9x+FivooaAgFYMxFp8E2O9d9rHMCNPCW
4QWwXrRBWYOJoo1/qBBb
=RFHk
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_11_24_05_+1000_jaVoA9cDuJm_G6+g--
