Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab1CDNCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:02:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58321 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab1CDNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:02:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nA3Qy4Uvu0IghYTJyW/n2lyYFyz4Pu+Bt4mbbnufv6QxRFWUXRWoEyYyNnT6SJ5z/x
         +06XcPJMqB53HoM+SnGj5e4O8Q36hw5Fb6YdYVkApQKdY1GK4ZZ/QxDKC7OwrIUytBO2
         roQ0X/c9BiEVRRMNKM3wYXSv16bxk+UQowGuU=
MIME-Version: 1.0
In-Reply-To: <20110303221353.GA10366@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com>
Date: Fri, 4 Mar 2011 21:02:42 +0800
X-Google-Sender-Auth: h_jjoFoFzooegyJcYPAbkCpMZoQ
Message-ID: <AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
From: Shaohua Li <shli@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org
Content-Type: multipart/mixed; boundary=0016e6d9675ff1475b049da7c269
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d9675ff1475b049da7c269
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/3/4 Mike Snitzer <snitzer@redhat.com>:
> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
> kernel, when I try an fsync heavy workload to a request-based mpath
> device (the kernel ultimately goes down in flames, I've yet to look at
> the crashdump I took)
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> [ INFO: possible circular locking dependency detected ]
> 2.6.38-rc6-snitm+ #2
> -------------------------------------------------------
> ffsb/3110 is trying to acquire lock:
> =A0(&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff811b4c4d>] flush_p=
lug_list+0xbc/0x135
>
> but task is already holding lock:
> =A0(&rq->lock){-.-.-.}, at: [<ffffffff8137132f>] schedule+0x16a/0x725
>
> which lock already depends on the new lock.
I hit this too. Can you check if attached debug patch fixes it?

Thanks,
Shaohua

--0016e6d9675ff1475b049da7c269
Content-Type: text/x-patch; charset=US-ASCII; name="stack-plug-dbg.patch"
Content-Disposition: attachment; filename="stack-plug-dbg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkv45ppl0

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1jb3JlLmMgYi9ibG9jay9ibGstY29yZS5jCmluZGV4IDQ5
ODRiNDYuLjQ5MjRhYTAgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jsay1jb3JlLmMKKysrIGIvYmxvY2sv
YmxrLWNvcmUuYwpAQCAtMTEwMCw2ICsxMTAwLDcgQEAgc3RhdGljIGJvb2wgYXR0ZW1wdF9wbHVn
X21lcmdlKHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrLCBzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwK
IAlzdHJ1Y3QgcmVxdWVzdCAqcnE7CiAJYm9vbCByZXQgPSBmYWxzZTsKIAorCXByZWVtcHRfZGlz
YWJsZSgpOwogCXBsdWcgPSB0c2stPnBsdWc7CiAJaWYgKCFwbHVnKQogCQlnb3RvIG91dDsKQEAg
LTExMjIsNiArMTEyMyw3IEBAIHN0YXRpYyBib29sIGF0dGVtcHRfcGx1Z19tZXJnZShzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKnRzaywgc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCiAJCX0KIAl9CiBvdXQ6
CisJcHJlZW1wdF9lbmFibGUoKTsKIAlyZXR1cm4gcmV0OwogfQogCmRpZmYgLS1naXQgYS9rZXJu
ZWwvc2NoZWQuYyBiL2tlcm5lbC9zY2hlZC5jCmluZGV4IGU4MDY0NDYuLjdiNGIyZjkgMTAwNjQ0
Ci0tLSBhL2tlcm5lbC9zY2hlZC5jCisrKyBiL2tlcm5lbC9zY2hlZC5jCkBAIC0zOTM4LDYgKzM5
MzgsMTQgQEAgYXNtbGlua2FnZSB2b2lkIF9fc2NoZWQgc2NoZWR1bGUodm9pZCkKIAlzdHJ1Y3Qg
cnEgKnJxOwogCWludCBjcHU7CiAKKwkvKgorCSAqIElmIHRoaXMgdGFzayBoYXMgSU8gcGx1Z2dl
ZCwgbWFrZSBzdXJlIGl0IGdldHMgZmx1c2hlZCBvdXQgdG8gdGhlCisJICogZGV2aWNlcyBiZWZv
cmUgd2UgZ28gdG8gc2xlZXAuIE11c3QgYmUgY2FsbGVkIGJlZm9yZSBiZWxvdyBsb2NrLAorCSAq
IG90aGVyd2lzZSB0aGVyZSBpcyBkZWFkbG9jaworCSAqLworCWJsa19mbHVzaF9wbHVnKGN1cnJl
bnQpOworCUJVR19PTihjdXJyZW50LT5wbHVnICYmICFsaXN0X2VtcHR5KCZjdXJyZW50LT5wbHVn
LT5saXN0KSk7CisKIG5lZWRfcmVzY2hlZDoKIAlwcmVlbXB0X2Rpc2FibGUoKTsKIAljcHUgPSBz
bXBfcHJvY2Vzc29yX2lkKCk7CkBAIC0zOTczLDE0ICszOTgxLDYgQEAgbmVlZF9yZXNjaGVkX25v
bnByZWVtcHRpYmxlOgogCQkJCWlmICh0b193YWtldXApCiAJCQkJCXRyeV90b193YWtlX3VwX2xv
Y2FsKHRvX3dha2V1cCk7CiAJCQl9Ci0JCQkvKgotCQkJICogSWYgdGhpcyB0YXNrIGhhcyBJTyBw
bHVnZ2VkLCBtYWtlIHN1cmUgaXQKLQkJCSAqIGdldHMgZmx1c2hlZCBvdXQgdG8gdGhlIGRldmlj
ZXMgYmVmb3JlIHdlIGdvCi0JCQkgKiB0byBzbGVlcAotCQkJICovCi0JCQlibGtfZmx1c2hfcGx1
ZyhwcmV2KTsKLQkJCUJVR19PTihwcmV2LT5wbHVnICYmICFsaXN0X2VtcHR5KCZwcmV2LT5wbHVn
LT5saXN0KSk7Ci0KIAkJCWRlYWN0aXZhdGVfdGFzayhycSwgcHJldiwgREVRVUVVRV9TTEVFUCk7
CiAJCX0KIAkJc3dpdGNoX2NvdW50ID0gJnByZXYtPm52Y3N3Owo=
--0016e6d9675ff1475b049da7c269--
