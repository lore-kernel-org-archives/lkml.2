Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795Ab2KBSRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:17:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab2KBSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:33 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=dPG4pZMWmFYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bAoo0TRVWEYA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=zur_hE3pW_xaBMeJ4UEA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=tQePFVSo2C1l0M4z:21 a=8injnqd8hiDfG_D6:21 a=QN9TC-Wkv769S6BzuGcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181431.404431230@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 09/19] tracing: Trivial cleanup
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Trivial-cleanup.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Sharp <dhsharp@google.com>

Remove ftrace_format_syscall() declaration; it is neither defined nor
used. Also update a comment and formatting.

Link: http://lkml.kernel.org/r/1339112785-21806-1-git-send-email-vnagarnaik=
@google.com

Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/syscall.h    |    2 --
 kernel/trace/ring_buffer.c |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 31966a4..0c95796 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -39,8 +39,6 @@ extern int reg_event_syscall_enter(struct ftrace_event_ca=
ll *call);
 extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
 extern int reg_event_syscall_exit(struct ftrace_event_call *call);
 extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
-extern int
-ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int fla=
gs,
 				      struct trace_event *event);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flag=
s,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0ebeb1d..23a384b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1821,7 +1821,7 @@ rb_add_time_stamp(struct ring_buffer_event *event, u6=
4 delta)
 }
=20
 /**
- * ring_buffer_update_event - update event type and data
+ * rb_update_event - update event type and data
  * @event: the even to update
  * @type: the type of event
  * @length: the size of the event field in the ring buffer
@@ -2723,8 +2723,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
  * and not the length of the event which would hold the header.
  */
 int ring_buffer_write(struct ring_buffer *buffer,
-			unsigned long length,
-			void *data)
+		      unsigned long length,
+		      void *data)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2HAAoJEOdOSU1xswtM6a0H/2OXY3owuXBRS97x2aTjWOo/
zm3NPNOjszH4NDjo8/Fydgu/6j2+SNyyJSQX5gWh0qBYIcVjkfMwQLtoZ2mbSjXA
sDZpUNDfMAhVuCIUDQDClbIZkwNuszPZ4vW3E+Foiu0lssCj4ed0xa3OUylEWgn3
Ictb8YJQJpFaez/Hva8s1BXkXvBDFGxVn0tdh9FYUAQNFe92A4fMFRC34IGNH8d5
oElY3yCeRoji2SP6mWbjDT/BqyG6AoAS+uzPtQrMkW4+P7rKVxq/Ci7guxilrFQF
GrOwWS7UesUk0VESfMg/MHXwtf9B537t9DSrwkCXtPHZPolT2ORaBmvOuoICpEk=
=DguO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
