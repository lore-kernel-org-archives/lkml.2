Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945962Ab2ERNK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:10:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967241Ab2ERNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:51 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=u3UgELqVZjcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=RxCtdUwsSDzekRHc3ssA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rjbL9jQAN1jjhVIQLpsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131048.948597069@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 06/15] tracing: Check return value of tracing_dentry_percpu()
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Check-return-value-of-tracing_dentry_percpu.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

If tracing_dentry_percpu() failed, tracing_init_debugfs_percpu()
will try to create each cpu directories on debugfs' root directory
as d_percpu is NULL.

Link: http://lkml.kernel.org/r/1335143517-2285-1-git-send-email-namhyung.ki=
m@lge.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dfbd86c..0ed4df0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4474,6 +4474,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
=20
+	if (!d_percpu)
+		return;
+
 	snprintf(cpu_dir, 30, "cpu%ld", cpu);
 	d_cpu =3D debugfs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpZAAoJEIy3vGnGbaoAstUQAOt9XTtKKpYuYTvtmSEFN3Ky
vdjqK6CrM4TQXRZ1tB33fMZsYQVaT80Lyzhq9ovXGHW+6za4l2nVH9R15pYISEzg
ObjCWPKXKMUmveBMTo8b1Z5gCeeybKHGiJl4pUwa28zfPM/BoVVot2tpmlgMI9VG
Z1m3rlNf3pNx5AetEhNhU9q1i1itCIWGwpYahojn8U3R90XkEPYUfDb/GGmV0e2T
8D516YdtHj2V0qvCxzzS0c0VNad/uO1M9G8s5a2AfGy8YBMg6zJvY2RYzopZYjLZ
qCDwov/kPbb730MLYtTXnmOuUN0A2J53XlTa3wZid5fOCBA2K08eV5IR0JZhQTCF
lS9PBkpX4yXf3Y3C5k8c5Rwgbyqj+75c/0mDQcd5bJQDr586o5811beJyl1PVbjR
a/DlEI1mrmYJJfij6mBS1FturnntW0G/ZxQQuJZD96/JJm+Y54hJqXszxZeVGCv/
vfdEzUe0/2+cyrW7d3Mwxigh6US5asb6tAxfMK/2Y4Xn51RBmd8ebMgA385h/6mt
0b+Lcqdc+HLs478wXqY3i+cNCmlBCXmDHNizgMJxysrz8h2+UANqPABkPlC5kT4l
OejIczJfgouGRr0pE938XgLjeQXpd+Yi6Nhk+vapH1nVkMhn4kRsM8ww8djjh0hw
IJ8CnKybp77/XsP4ubr4
=WsMe
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
