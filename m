Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1JJTTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:19:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1JJTTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:19:46 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=gKh_qVmIFScA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=3nbZYyFuAAAA:8 a=20KFwNOVAAAA:8 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=0zx7FwPiojy1fBRBiaQA:9 a=nAFY3w5RRlwVPeaIFQMA:7 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=dowx1zmaLagA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=WNlz9nDMQB9av_0FHvQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010191943.804412316@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 15:17:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, stable@kernel.org
Subject: [PATCH 2/2] perf probe: Fix to show correct error string
References: <20111010191706.044816068@goodmis.org>
Content-Disposition: inline; filename=0002-perf-probe-Fix-to-show-correct-error-string.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix perf probe to show correct error string when it
fails to delete an event. The write(2) returns -1
if failed, and errno stores real error number.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/20111004104504.14591.41266.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/probe-event.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1c7bfa5..eb25900 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1956,8 +1956,10 @@ static int __del_trace_probe_event(int fd, struct st=
r_node *ent)
=20
 	pr_debug("Writing event: %s\n", buf);
 	ret =3D write(fd, buf, strlen(buf));
-	if (ret < 0)
+	if (ret < 0) {
+		ret =3D -errno;
 		goto error;
+	}
=20
 	printf("Remove event: %s\n", ent->s);
 	return 0;
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOk0VQAAoJEIy3vGnGbaoAKsEQAJGzsQy1qlr6wthDsqgSLetQ
uGjSmno5j/jj+eMfaOT+wYXidqVDRp4EVqKUGXKJa5rRapFqcO4EInreQZg7dLLf
0i29kBZbp/vDCB7mV9W4YAFWH82cYy8FYWuKQlK7DldUGiCCBm8FSnKDOwwfHcnc
DJljertJaxYp8222wsTwVv11Nz/N2fi2uYBqgvIQdFdwODorAz/bJ5T9Rwz3M5kN
EjYN2neIySdr10HJG59VhMTvq+dxiOllOTZ+IdfBJc3C8pL7T/vmAzufC3c3wGFG
v8bBiSc3DwwiSc3/jv7rYA58uLHzxSNOyCjppSz4d4woC3nhbRffaEMN/U6lvjV0
diNhHGxEQMiBBNNTDCRCR62805DLK9w/kjAV4zW3kyIgKNi1Z8pzrqaXWyz/ZYBZ
XusSuFc4jbcp9rsWlVvw6bB0lm0Y/MUt3/DmUxNHu1haCk1CwXgKFH2uu9C17KLZ
qYeAdsukqQ8UXw2XeDdvCkxyNzcpffjm/kqPbtAa2mZrGzIgKB+g6FHNZCIXI8bz
+zgDgjzZovwlFZo3IYVaMn1qnWuh0Bd27T7cOoI1tU1sa0/rLXEtEFUiF+VydqKg
6PIFCM98shvXKdoKYS3VJRL8tHubfGQCGCssnBbdsbJXhfCIRH7+D6DvDVK+RXPc
lCIsDrpAwZO4teUaO/9q
=xk+8
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
