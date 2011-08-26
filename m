Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1HZVuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:50:23 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36499 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1HZVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <0ad5d75e1d238d186a3beadefd9de80316409867.1314291910.git.jbaron@redhat.com>
References: <cover.1314291909.git.jbaron@redhat.com> <0ad5d75e1d238d186a3beadefd9de80316409867.1314291910.git.jbaron@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 26 Aug 2011 15:47:49 -0600
Message-ID: <CAJfuBxyyiGYJ-DmtJG2fy0HDZ6BbpYpXwnA02uetS_0RRuh+0w@mail.gmail.com>
Subject: Re: [PATCH 3/4] dynamic_debug: use a single printk() to emit msgs
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd2a0d2e6ced904ab6f8057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2a0d2e6ced904ab6f8057
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 25, 2011 at 11:34 AM, Jason Baron <jbaron@redhat.com> wrote:

> + =A0 =A0 =A0 if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D snprintf(buf + pos, LEFT(pos), "%s=
:", desc->modname);
> + =A0 =A0 =A0 if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D snprintf(buf + pos, LEFT(pos), "%s=
:", desc->function);
> + =A0 =A0 =A0 if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D snprintf(buf + pos, LEFT(pos), "%d=
 ", desc->lineno);

this inserts a space after lineno, but not otherwize.

I have patch to fix it, but maybe you want to fix it it here ?

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 9c8e133..122246f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -439,7 +439,9 @@ static char *dynamic_emit_prefix(const struct
_ddebug *desc, char *buf)
 	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
 		pos +=3D snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		pos +=3D snprintf(buf + pos, LEFT(pos), "%d ", desc->lineno);
+		pos +=3D snprintf(buf + pos, LEFT(pos), "%d:", desc->lineno);
+	if (pos - strlen(KERN_DEBUG))
+		pos +=3D snprintf(buf + pos, LEFT(pos), " ");

 	return buf;
 }
--=20
1.7.4.4


also attached.
If it doesnt apply, or you defer, I'll resend once Greg's accepted
your whole set.

--000e0cd2a0d2e6ced904ab6f8057
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0003-dynamic_debug-add-space-at-end-of-non-null-dynamic-p.patch"
Content-Disposition: attachment; 
	filename="0003-dynamic_debug-add-space-at-end-of-non-null-dynamic-p.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grtozdcw0

RnJvbSBlYzc1Y2Q1MGJhODliZWQxZjBhZDc0Yjg5YzlhNDNlODdiMmJkNzY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKaW0gQ3JvbWllIDxqaW0uY3JvbWllQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAyIEF1ZyAyMDExIDE1OjEyOjU1IC0wNjAwClN1YmplY3Q6IFtQQVRDSCAwMy8yOF0g
ZHluYW1pY19kZWJ1ZzogYWRkIHNwYWNlIGF0IGVuZCBvZiBub24tbnVsbAogZHluYW1pYy1wcmVm
aXgKCmR5bmFtaWNfZW1pdF9wcmVmaXgoKSBjdXJyZW50bHkgYWRkcyBhIHNwYWNlIGFmdGVyIGxp
bmUtbnVtYmVyLApidXQgbm90IG90aGVyd2l6ZS4gIEZvciByZWFkYWJpbGl0eSwgYWRkIHNwYWNl
IHdoZW5ldmVyIGFueSBwcmVmaXgKKGJlc2lkZXMgdGhlICI8Nz4iIGxvZ2xldmVsKSBoYXMgYmVl
biB3cml0dGVuLgoKU2lnbmVkLW9mZi1ieTogSmltIENyb21pZSA8amltLmNyb21pZUBnbWFpbC5j
b20+Ci0tLQogbGliL2R5bmFtaWNfZGVidWcuYyB8ICAgIDQgKysrLQogMSBmaWxlcyBjaGFuZ2Vk
LCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbGliL2R5bmFt
aWNfZGVidWcuYyBiL2xpYi9keW5hbWljX2RlYnVnLmMKaW5kZXggOWM4ZTEzMy4uMTIyMjQ2ZiAx
MDA2NDQKLS0tIGEvbGliL2R5bmFtaWNfZGVidWcuYworKysgYi9saWIvZHluYW1pY19kZWJ1Zy5j
CkBAIC00MzksNyArNDM5LDkgQEAgc3RhdGljIGNoYXIgKmR5bmFtaWNfZW1pdF9wcmVmaXgoY29u
c3Qgc3RydWN0IF9kZGVidWcgKmRlc2MsIGNoYXIgKmJ1ZikKIAlpZiAoZGVzYy0+ZmxhZ3MgJiBf
RFBSSU5US19GTEFHU19JTkNMX0ZVTkNOQU1FKQogCQlwb3MgKz0gc25wcmludGYoYnVmICsgcG9z
LCBMRUZUKHBvcyksICIlczoiLCBkZXNjLT5mdW5jdGlvbik7CiAJaWYgKGRlc2MtPmZsYWdzICYg
X0RQUklOVEtfRkxBR1NfSU5DTF9MSU5FTk8pCi0JCXBvcyArPSBzbnByaW50ZihidWYgKyBwb3Ms
IExFRlQocG9zKSwgIiVkICIsIGRlc2MtPmxpbmVubyk7CisJCXBvcyArPSBzbnByaW50ZihidWYg
KyBwb3MsIExFRlQocG9zKSwgIiVkOiIsIGRlc2MtPmxpbmVubyk7CisJaWYgKHBvcyAtIHN0cmxl
bihLRVJOX0RFQlVHKSkKKwkJcG9zICs9IHNucHJpbnRmKGJ1ZiArIHBvcywgTEVGVChwb3MpLCAi
ICIpOwogCiAJcmV0dXJuIGJ1ZjsKIH0KLS0gCjEuNy40LjQKCg==
--000e0cd2a0d2e6ced904ab6f8057--
