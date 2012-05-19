Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab2ESNgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:36:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29159 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab2ESNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:36:37 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=do8OVGN1zgMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=RWwY4srph8f8iK54tvEA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Zfw8p-1tqjN2tGrK30IA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120519133635.833695769@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 19 May 2012 09:35:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/3] tracing: Fix initial buffer_size_kb state
References: <20120519133551.942867137@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-initial-buffer_size_kb-state.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

Make sure that the state of buffer_size_kb is initialized correctly and
returns actual size of the ring buffer.

Link: http://lkml.kernel.org/r/1336066834-1673-1-git-send-email-vnagarnaik@=
google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 08a08ba..a44d4c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5112,7 +5112,8 @@ __init static int tracer_alloc_buffers(void)
 		max_tr.data[i] =3D &per_cpu(max_tr_data, i);
 	}
=20
-	set_buffer_entries(&global_trace, ring_buf_size);
+	set_buffer_entries(&global_trace,
+			   ring_buffer_size(global_trace.buffer, 0));
 #ifdef CONFIG_TRACER_MAX_TRACE
 	set_buffer_entries(&max_tr, 1);
 #endif
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPt6HjAAoJEIy3vGnGbaoABG4P/33Vi7zVUdGiPNRD8ZLOvYla
Awxi8C+xEw7mlEFgUrcoCB7tap3Tk20A4E7PhAVsg0oTqje0pxjjHRfFY4gptDSP
quTA406T4WzWzG2Ec7wW1CKUuFOghhrEX0Ui54CSrkD5ghYNtrk+gGT0NmyIgcMI
5avJaW2pPB4E7bU7w+DWXPgB/DPi1DwnVa6+7F/UHJKIoIqFhNNC16nWl3jUspHb
HsTzM8D/RG+96qvJxrgUt/RbsTCrVjF7RxGUrE3axZ3kR9/jXPG4Rz2d8ukYzHh3
Re40aU3Ze19VzVtgNbDeYLceyMirEapR0baQ8L68lfdWmbkvtPC6ZYJmZ41V+8mo
AwgRGFl1gshCFFwZ0xJdRRmSGCrEb8zUf4B5W3O9itHmtzLrT4EkbnblbVH2yeny
oySPvQ5cEvj59DmzvypWrRkYDhh/13e0cPU8CnZZLvaty7xkDE1apXUcVKphj+39
loH0vV+yq6ZkR6sSrRchJdkd0q409bNP/e8flS0qNH0tZe4R9+Khm20uqNYyDglU
OchMBoEmTbKfxmXlT7s8V5LvhxEc+VoT7ErF7hdc3LNTGe0FdaZRwzbQS9hxLIfq
XTiuWXmUmNy9lhxN6MMSfZZNMrNdGgBvIB24J4maJltisHfSGmGWWu/V+7otrZJm
QUe/qzNAkp9eDJXtk+Su
=brqq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
