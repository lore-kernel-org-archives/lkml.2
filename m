Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2F2Vlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:41:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2F2VlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:41:22 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Djfh_bQ1b1oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=AFVD0DGOkx0OiVSgs0gA:9 a=QEXdDO2ut3YA:10 a=yk9LrJ0pTjsA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=n9v7UzA6wQip3km845wA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120629214119.549888792@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Jun 2012 17:35:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 2/2] ring-buffer: Fix accounting of entries when removing pages
References: <20120629213545.533870841@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Fix-accounting-of-entries-when-removing-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

When removing pages from the ring buffer, its state is not reset. This
means that the counters need to be correctly updated to account for the
pages removed.

Update the overrun counter to reflect the removed events from the pages.

Link: http://lkml.kernel.org/r/1340998301-1715-1-git-send-email-vnagarnaik@=
google.com

Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ba39cba..f765465 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1347,10 +1347,9 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buff=
er, unsigned int nr_pages)
 			 * If something was added to this page, it was full
 			 * since it is not the tail page. So we deduct the
 			 * bytes consumed in ring buffer from here.
-			 * No need to update overruns, since this page is
-			 * deleted from ring buffer and its entries are
-			 * already accounted for.
+			 * Increment overrun to account for the lost events.
 			 */
+			local_add(page_entries, &cpu_buffer->overrun);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 		}
=20
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7iD/AAoJEIy3vGnGbaoAbXYP/10GFZFu2vhbu+EVcflJdSQW
0HYNXRkBFQOzmHwZn6UqXYqZUBBBycDiqiX8R5Ly9QfH4cA3BFeFNwv+zpksuyKk
+MYTgrfzm5RkgGNvBOqWGDqvnfi8YGjTpKQtwxeW/S8WNsZVPw5ZjHTejD+PlvpL
S6xkO/S1y+yRXuGHffh69ZMG5B4r9odm+iRuWUKgIATQQPZYjFFVkIwu7VgoUxeB
nyP1GDqvhy02zpOPK9p7FI+vTlbbaRUPXw8Cvp8/oTphO5uGQ8LRq4xqRtj7aJx4
5Bux2STBMz7QVr2wV8Z+p6w9NJ0EtH437X8/EeulYBgBMh9GXiVQZk0TWJluLowo
dYPQHjvwYBdzZOr6UN72yr3nT6bZCLDpbe+txqCjfc4QAEWL682sjdeP1jzFwHDW
NIcDVqgPqmIwLGIJaB09AvbWsZd+K5bOPiOMKVWfIGbVz4OhtdngK4YVduk+jI9Z
ahVtO3bLD513KgXl49oMfOJZLV6ucF8tLq6qo+nLvvhaEsAc610jUEs3cAPWJNIR
TOlrTARUREEOU60upOMo+iqBUmbUkZ42eLNdvSxK8/R+U7JY4c0kPqN7TYINOJuI
vB0hFdXp1Qy+G1AmTV56Lp4vDW4D1GAnM+VN6m6nHYv2hD7If0DTuzwyMoTP5Fh2
+KG83ZcLiw+vrWS7TaTG
=JDSb
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
