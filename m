Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2D0F72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:59:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43287 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab2D0F7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:59:25 -0400
Date: Fri, 27 Apr 2012 15:38:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120427153806.65f5cd168dfc0ea18a954080@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_15_38_06_+1000_py7jc9K=2_qXm7dN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_15_38_06_+1000_py7jc9K=2_qXm7dN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ipc/mqueue.c: In function 'mqueue_get_inode':
ipc/mqueue.c:155:4: error: implicit declaration of function 'vmalloc' [-Wer=
ror=3Dimplicit-function-declaration]
ipc/mqueue.c:155:19: warning: assignment makes pointer from integer without=
 a cast [enabled by default]
ipc/mqueue.c: In function 'mqueue_evict_inode':
ipc/mqueue.c:268:3: error: implicit declaration of function 'vfree' [-Werro=
r=3Dimplicit-function-declaration]

Caused by commit 5d644d9d3d8f ("ipc/mqueue: update maximums for the
mqueue subsystem").  See Rule 1 from Documentation/SubmitChecklist.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Apr 2012 15:35:14 +1000
Subject: [PATCH] ipc/mqueue: using vmalloc requires including vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 ipc/mqueue.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 04cc77e..279051c 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -34,6 +34,7 @@
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
=20
 #include <net/sock.h>
 #include "util.h"
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Apr_2012_15_38_06_+1000_py7jc9K=2_qXm7dN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmjC+AAoJEECxmPOUX5FErqEQAJlRlnxKHB1uV4jSq/+7p6km
bLcw8ue3RaitLj9rXft6emH8SPY413krN24C9Apzg0OP8AG2/DVqogdBwxgO6bEu
O6mg7/3EjuQQCDttcVRmgHkPZV8uE9u73Y/2V1kTfR8qBXo1QGZh3uAf3glsRPn3
QOXbc3DkvJkKOB2VvBYVBDLDvT+OSxUXz5S4Jv1Bpx4GkfKIMbLczyECEhgRprir
NHNkWb8hUskfomMXddh8+R/l7Sds9BuuSyl6JPMXE4PEHId+j2yW22Z4FZUCiO4V
YzdE7N9fAHXi+8Bv0NVnV8AlqYXCmhwDEpdsPD1FfaeQt355OAx09FOCn7eRZWaQ
U5siROUW9Ar4XDN8YlEjZHFlXD0kEpZljUlNX5r7QPt7RTPInd6w7trPKgss/VvS
vhJDFYTlqd8w8oTfG3bVJLQ+e6/28Ap4iJ//douCeyld2TdXbCuuM+j18d/gsc6G
aYzpeUBdBYBUuzQxr3UiYPQURk2pn79Lg+pi0lB6Z8Q8pXiNmTVsUIcYtTT1eSQ8
q8CsUM3vMG03pUtz/KXdq5b46AixsYi7Eoc+Aus0R/QcApFpEpKjbEYzPJJDNuYd
qIJtoX5jGOrY+CTCIPFvxeRzoK8DPUbiLFvdte2Il/YJKw4tItQaQXRfAMe9NU2u
g2PmrCp+Fz+vk6QXKVjZ
=tfzm
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_15_38_06_+1000_py7jc9K=2_qXm7dN--
