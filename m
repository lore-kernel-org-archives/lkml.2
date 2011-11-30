Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1K3Emn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:42:43 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:41464 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1K3Eml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:42:41 -0500
Date: Wed, 30 Nov 2011 15:42:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20111130154231.42db05b2eb2baa11f3e7c561@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Nov_2011_15_42_31_+1100_tUYSXQ/JJqPqRx+n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Nov_2011_15_42_31_+1100_tUYSXQ/JJqPqRx+n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

kernel/cpuset.c: In function 'cpuset_change_task_nodemask':
kernel/cpuset.c:971:17: error: 'struct task_struct' has no member named 'me=
mpolicy'

Caused by commit abf5d6d23d83 ("cpusets: stall when updating mems_allowed
for mempolicy or disjoint nodemask") from the akpm tree.  The mempolicy
member is only available when CONFIG_NUMA is set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Nov_2011_15_42_31_+1100_tUYSXQ/JJqPqRx+n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1bQ3AAoJEECxmPOUX5FE5cEQAIlEwVYRfdas+90GhOp6MD/f
LvVh+FBIy2SFJQQ4KzkOvAFbsrJccSTy6bn/SbaXLNjcm+EWQ8iQvqXFKl2Op+a0
nz96Y7D0viAofaj6kKQYSXpnuTwK73W1FnpF/MZ2h5kwzEPx2/s9/+GcRRHmpxFy
Icqlfo9C2F90cuRp7KQAcu2yV+O1e/dK3nA2fv2hK23Kt51iaotUrbiyRXcS3Rg6
S280vlnZSjwmTcoHItYZ2bOGsP7xamR52RjDeZuWyZBEwmO2FA8yOesSHBXEuygH
i70tSX3vvQXKmBEDr94eaJSRO0Vr3Se2/MAzotfKwzDxdQL6ojehOd5ltokWutJM
4Yd75e+FYRz9SgYHTZbhIk+4wuUv8Z8Jol3ZtimNT79uyOfr/NUqaspHKFScCB9N
oNCo5T59qZtrpYWWdIumwBzUYlLLi/aqkUItfNK8et6AE4NZbcHAxwCweUKQUurp
nH48zcQNVakbdEgUWetb7EVClMK2QXjPIsl/JHbhsEDj5va9aBnQGt6mfziM3Nab
0c0BLRjVbiVwLwEk+nIKiGNXbiGuVyM8qs6W2ypozxSewXc+JeozTQnTpLgsN9ia
Pb2uIPtCu3lz3oNJZT7ld+AQdfTySoKrgMqmreLPffE0AzNfToSFzt7sFfdrykW9
k1AAA/LYybZQQHa4JmZH
=qv7U
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Nov_2011_15_42_31_+1100_tUYSXQ/JJqPqRx+n--
