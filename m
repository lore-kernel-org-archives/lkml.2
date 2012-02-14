Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab2BNDle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:41:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759196Ab2BNDkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:12 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=hpxIdF7lBOIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=OLi75TEXwbsgIvBTUQgA:9 a=QEXdDO2ut3YA:10 a=Xzri-ZHCAUwA:10 a=jeBq3FmKZ4MA:10 a=MTc4dA8PcwocppFJePcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034009.136954085@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 9/9] tracing/trivial: Use kcalloc instead of kzalloc to allocate array
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-trivial-Use-kcalloc-instead-of-kzalloc-to-al.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Meyer <thomas@m3y3r.de>

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Link: http://lkml.kernel.org/r/1322600880.1534.347.camel@localhost.localdom=
ain

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c              |    2 +-
 kernel/trace/trace_events_filter.c |    7 +++----
 kernel/trace/trace_syscalls.c      |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e2e0597..d1499e9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1129,7 +1129,7 @@ static struct ftrace_hash *alloc_ftrace_hash(int size=
_bits)
 		return NULL;
=20
 	size =3D 1 << size_bits;
-	hash->buckets =3D kzalloc(sizeof(*hash->buckets) * size, GFP_KERNEL);
+	hash->buckets =3D kcalloc(size, sizeof(*hash->buckets), GFP_KERNEL);
=20
 	if (!hash->buckets) {
 		kfree(hash);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 24aee71..76afaee 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -685,7 +685,7 @@ find_event_field(struct ftrace_event_call *call, char *=
name)
=20
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
-	stack->preds =3D kzalloc(sizeof(*stack->preds)*(n_preds + 1), GFP_KERNEL);
+	stack->preds =3D kcalloc(n_preds + 1, sizeof(*stack->preds), GFP_KERNEL);
 	if (!stack->preds)
 		return -ENOMEM;
 	stack->index =3D n_preds;
@@ -826,8 +826,7 @@ static int __alloc_preds(struct event_filter *filter, i=
nt n_preds)
 	if (filter->preds)
 		__free_preds(filter);
=20
-	filter->preds =3D
-		kzalloc(sizeof(*filter->preds) * n_preds, GFP_KERNEL);
+	filter->preds =3D kcalloc(n_preds, sizeof(*filter->preds), GFP_KERNEL);
=20
 	if (!filter->preds)
 		return -ENOMEM;
@@ -1486,7 +1485,7 @@ static int fold_pred(struct filter_pred *preds, struc=
t filter_pred *root)
 	children =3D count_leafs(preds, &preds[root->left]);
 	children +=3D count_leafs(preds, &preds[root->right]);
=20
-	root->ops =3D kzalloc(sizeof(*root->ops) * children, GFP_KERNEL);
+	root->ops =3D kcalloc(children, sizeof(*root->ops), GFP_KERNEL);
 	if (!root->ops)
 		return -ENOMEM;
=20
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cb65454..4350015 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -468,8 +468,8 @@ int __init init_ftrace_syscalls(void)
 	unsigned long addr;
 	int i;
=20
-	syscalls_metadata =3D kzalloc(sizeof(*syscalls_metadata) *
-					NR_syscalls, GFP_KERNEL);
+	syscalls_metadata =3D kcalloc(NR_syscalls, sizeof(*syscalls_metadata),
+				    GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
 		return -ENOMEM;
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeZAAoJEIy3vGnGbaoAWT8QALbPLU3VNAFvJYc2vV0rG4E5
IYlmOBSYTPpNSwH/EnzW+tQu8MRNbd5brOUObKyWBmpeISE33yG46RE14eraXdfo
/xooW8RoNOoBSFe9adb7Pnbmg8HIlILDRF0fcJmh95m655ZTv0X1X2x+u5heGmL7
Ly0krG3JkHlNcXlEK/hMPCGW/7Qxn5OZqX2tgNUg12szh6zuGwMMKFyixafOfeKj
QtEvYpKVjVHem/5wVWZXONCu/ptl4o8rqj3Vc77AM2U1yfwBvylJp6Pw5cv3N20y
z+rZVYucDErQ7aLouUSAAjtcfvsYUnkQrpqeNZJ+/aIu/ggENPiuGVSO7bk+Iq5C
AYH0/fB9KZz8in706G1L9Cmz8UmXPr49jYG1t8GwVe6m79HjY8pmIF0BhFHvflRs
ecK8nDO9yjWVgObz+mL8QQNCf08bm51zDiFFE9bo+ePih3kh0SbWr70JXQUIAykC
m1FvLua1dpv45RlQbqwIZgz9BCp3uFUVFVJMW+W2nP2iAMSGCbujzgv3SCAhnb6+
y52KH3/u8iXrRfaFgdlYjWqK5GZdMMg1HNxbPC3gEjgeP4MrbgjoCZRlCYl5yQok
YmXWMzATqf1SoYuSNCGCG7htu3nkebezRP4S9MdxEJs7DKu+lM4Z/T+5OyiezWV4
BS+szn8UPT44fLIiCbJ+
=9Tk6
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
