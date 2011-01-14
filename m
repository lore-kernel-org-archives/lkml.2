Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab1ANBfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:35:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34060 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1ANBfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:35:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XL0usZcAAZbMKWCBOO9kSx18wMK+shpit36iD5LJGpsTkSFmVzmkRVN/PHFGPICZwp
         g1yWTdXIEzzl11S7WKlkv6gsYoVsCCPEilfjY3TJcEuxHj230gRdhukGRA/rV73jLw5J
         zNaqep7GBrbUV3GF6R2hNFpmbcRHM1H0Oes8o=
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 12:35:32 +1100
Message-ID: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
Subject: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364d2cbd3f930e0499c473e8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364d2cbd3f930e0499c473e8
Content-Type: text/plain; charset=ISO-8859-1

Hi,

While hunting down a bug in NFS's AIO, I believe I found this
buggy code...

--0016364d2cbd3f930e0499c473e8
Content-Type: application/octet-stream; name="fs-aio-race-fix.patch"
Content-Disposition: attachment; filename="fs-aio-race-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_giwf6nxn0

ZnM6IGFpbyBmaXggcmN1IGlvY3R4IGxvb2t1cAoKYWlvLWRpby1pbnZhbGlkYXRlLWZhaWx1cmUg
R1BGcyBpbiBhaW9fcHV0X3JlcSBmcm9tIGlvX3N1Ym1pdC4KCmxvb2t1cF9pb2N0eCBkb2Vzbid0
IGltcGxlbWVudCB0aGUgcmN1IGxvb2t1cCBwYXR0ZXJuIHByb3Blcmx5LgpyY3VfcmVhZF9sb2Nr
IGRvZXMgbm90IHByZXZlbnQgcmVmY291bnQgZ29pbmcgdG8gemVybywgc28gd2UKbWlnaHQgdGFr
ZSBhIHJlZmNvdW50IG9uIGEgemVybyBjb3VudCBpb2N0eC4KClNpZ25lZC1vZmYtYnk6IE5pY2sg
UGlnZ2luIDxucGlnZ2luQGtlcm5lbC5kaz4KCkluZGV4OiBsaW51eC0yLjYvZnMvYWlvLmMKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZnMvYWlvLmMJMjAxMS0wMS0xNCAwMDoyOTowMC4w
MDAwMDAwMDAgKzExMDAKKysrIGxpbnV4LTIuNi9mcy9haW8uYwkyMDExLTAxLTE0IDExOjMxOjQ3
LjAwMDAwMDAwMCArMTEwMApAQCAtMjM5LDE1ICsyMzksMjMgQEAgc3RhdGljIHZvaWQgX19wdXRf
aW9jdHgoc3RydWN0IGtpb2N0eCAqYwogCWNhbGxfcmN1KCZjdHgtPnJjdV9oZWFkLCBjdHhfcmN1
X2ZyZWUpOwogfQogCi0jZGVmaW5lIGdldF9pb2N0eChraW9jdHgpIGRvIHsJCQkJCQlcCi0JQlVH
X09OKGF0b21pY19yZWFkKCYoa2lvY3R4KS0+dXNlcnMpIDw9IDApOwkJCVwKLQlhdG9taWNfaW5j
KCYoa2lvY3R4KS0+dXNlcnMpOwkJCQkJXAotfSB3aGlsZSAoMCkKLSNkZWZpbmUgcHV0X2lvY3R4
KGtpb2N0eCkgZG8gewkJCQkJCVwKLQlCVUdfT04oYXRvbWljX3JlYWQoJihraW9jdHgpLT51c2Vy
cykgPD0gMCk7CQkJXAotCWlmICh1bmxpa2VseShhdG9taWNfZGVjX2FuZF90ZXN0KCYoa2lvY3R4
KS0+dXNlcnMpKSkgCQlcCi0JCV9fcHV0X2lvY3R4KGtpb2N0eCk7CQkJCQlcCi19IHdoaWxlICgw
KQorc3RhdGljIGlubGluZSB2b2lkIGdldF9pb2N0eChzdHJ1Y3Qga2lvY3R4ICpraW9jdHgpCit7
CisJQlVHX09OKGF0b21pY19yZWFkKCZraW9jdHgtPnVzZXJzKSA8PSAwKTsKKwlhdG9taWNfaW5j
KCZraW9jdHgtPnVzZXJzKTsKK30KKworc3RhdGljIGlubGluZSBpbnQgdHJ5X2dldF9pb2N0eChz
dHJ1Y3Qga2lvY3R4ICpraW9jdHgpCit7CisJcmV0dXJuIGF0b21pY19pbmNfbm90X3plcm8oJmtp
b2N0eC0+dXNlcnMpOworfQorCitzdGF0aWMgaW5saW5lIHZvaWQgcHV0X2lvY3R4KHN0cnVjdCBr
aW9jdHggKmtpb2N0eCkKK3sKKwlCVUdfT04oYXRvbWljX3JlYWQoJmtpb2N0eC0+dXNlcnMpIDw9
IDApOworCWlmICh1bmxpa2VseShhdG9taWNfZGVjX2FuZF90ZXN0KCZraW9jdHgtPnVzZXJzKSkp
CisJCV9fcHV0X2lvY3R4KGtpb2N0eCk7Cit9CiAKIC8qIGlvY3R4X2FsbG9jCiAgKglBbGxvY2F0
ZXMgYW5kIGluaXRpYWxpemVzIGFuIGlvY3R4LiAgUmV0dXJucyBhbiBFUlJfUFRSIGlmIGl0IGZh
aWxlZC4KQEAgLTYwMSw4ICs2MDksNyBAQCBzdGF0aWMgc3RydWN0IGtpb2N0eCAqbG9va3VwX2lv
Y3R4KHVuc2lnCiAJcmN1X3JlYWRfbG9jaygpOwogCiAJaGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1
KGN0eCwgbiwgJm1tLT5pb2N0eF9saXN0LCBsaXN0KSB7Ci0JCWlmIChjdHgtPnVzZXJfaWQgPT0g
Y3R4X2lkICYmICFjdHgtPmRlYWQpIHsKLQkJCWdldF9pb2N0eChjdHgpOworCQlpZiAoY3R4LT51
c2VyX2lkID09IGN0eF9pZCAmJiAhY3R4LT5kZWFkICYmIHRyeV9nZXRfaW9jdHgoY3R4KSl7CiAJ
CQlyZXQgPSBjdHg7CiAJCQlicmVhazsKIAkJfQo=
--0016364d2cbd3f930e0499c473e8--
