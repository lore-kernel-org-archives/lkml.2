Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701Ab2KBSPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:15:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317Ab2KBSOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:35 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=TYgCYjv8-y8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1IyQYr9injYA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=xlkt2v7GNePvDyzTMlMA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=EvKJbDF4Ut8A:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=TmTHwZdoeKqn7wLIer8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181432.092043418@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 13/19] ring-buffer: Change unsigned long type of
 ring_buffer_oldest_event_ts() to u64
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0013-ring-buffer-Change-unsigned-long-type-of-ring_buffer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

ring_buffer_oldest_event_ts() should return a value of u64 type, because
ring_buffer_per_cpu->buffer_page->buffer_data_page->time_stamp is u64 type.

Link: http://lkml.kernel.org/r/1349998076-15495-5-git-send-email-dhsharp@go=
ogle.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    2 +-
 kernel/trace/ring_buffer.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 2007375..519777e 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -159,7 +159,7 @@ int ring_buffer_record_is_on(struct ring_buffer *buffer=
);
 void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
=20
-unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int =
cpu);
+u64 ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 23a384b..3c7834c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2932,12 +2932,12 @@ rb_num_of_entries(struct ring_buffer_per_cpu *cpu_b=
uffer)
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to read from.
  */
-unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int =
cpu)
+u64 ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
 {
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	u64 ret;
=20
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2IAAoJEOdOSU1xswtMoGgIAJgY9rFeo/fa1adlyNPq3chw
3QCxhmctXTfrc5QqwAiCDpd3hl6fbfPxA2f/vpZhFIi7Y7+Ixnks4pqD0ffwmMsL
G73X+yOMt1dNwc7yRvtOV0s6q2DXF67alo5m1Omc5u2z1i0w/tix/xZ+0wBj+nBE
vi7jxKoITLs84NkZk9GknHBXtl8rVViVVKI2Y0ItBMfOQXPEk2IbgLvdPqHlroq/
uppG97+74atKSv0oo0s6fPNd5d0EpmDYnOEcHsyYl3TkSr+2US53zkbOjg++oHrl
KVVFH0q7Cd75fSxPW3/U7Wyo7CUNPqd6P8aZnnOwwByZHeYn7UhNAIiXBVv10EA=
=XCkK
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
