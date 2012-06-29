Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab2F2VlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:41:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2F2VlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:41:21 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=iQfMYkXLkUkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=SN8O6U-ji6fululoWl4A:9 a=QEXdDO2ut3YA:10 a=yk9LrJ0pTjsA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=Q-hdhuwXq49U4h9XeOYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120629214119.028387965@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Jun 2012 17:35:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 1/2] ring-buffer: Fix crash due to uninitialized new_pages list head
References: <20120629213545.533870841@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Fix-crash-due-to-uninitialized-new_pages.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

The new_pages list head in the cpu_buffer is not initialized. When
adding pages to the ring buffer, if the memory allocation fails in
ring_buffer_resize, the clean up handler tries to free up the allocated
pages from all the cpu buffers. The panic is caused by referencing the
uninitialized new_pages list head.

Initializing the new_pages list head in rb_allocate_cpu_buffer fixes
this.

Link: http://lkml.kernel.org/r/1340391005-10880-1-git-send-email-vnagarnaik=
@google.com

Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d0f6a8..ba39cba 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1075,6 +1075,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, in=
t nr_pages, int cpu)
 	rb_init_page(bpage->page);
=20
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
=20
 	ret =3D rb_allocate_pages(cpu_buffer, nr_pages);
 	if (ret < 0)
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7iD/AAoJEIy3vGnGbaoA8MMQAIn3pOnrDop8Iba2RFWkS2Ec
QVy1PvgoD/TMFLVgwVVKlASlMih8LXTBQagHwvGwWIbfZhII6wdqkUMT7E0AuTRY
urjT929o2/Cm2YsaaRjC99hOb7heDRHBqeXJ3ce9i+sToAWXCodOEA4Oxk5OZ3Jn
EkQb8fe7nvAR6FirfOnRNsFDUJpTbqxIf4dyNTjfRj3fBD5OFGs/Dq2NEOcdkFAe
RWgi8oNByNUY4pU48pckw8XhvH0+MxxRZlnoqEaQR4aRqettNItkPdc7uxJYYhLt
opFKgXM6u+QBMvKt6mdeMfhKxsgXynpB964rmMEooOxuaufm8RKUYHEvzFi4Ku//
kvb89g6p8ApPWUqJwunXZa9zsXaOym156XaW8ERFQu+nET0L6UKajrNcMHRn8JLc
JUXsGmGWvYZpPKle1Wr6wybCQjGx9yhYdM0OnK58aT4YOG9xGX7zjIiHYcNZtjiF
jm54d+yiV0I1EIqxtXdRO/p3/JdnIhFGupvDLwVtFh8hL8qDUf5RCavA2QSBYnuf
eCYRAzMuCyL4wRrAxtz1+j2RoS7jQbYnKBGsOjzsY6hHrx6WnCfLlZW1JAau1qmB
FJIyjCXohlMOPlvzWQICkmpoghPwNMe1x8D4knPzE0GRsXkiN57l5RZ5tnXPpD3I
/WgNARFiiW/Rrt3fLuqT
=hsZ0
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
