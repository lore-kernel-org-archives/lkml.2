Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0LOISg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:18:36 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:42413 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab0LOISf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:18:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i+gzQmN1NatM+lLv0CDPTwKrG2vJN/BquM/mF3MA6JvVH86XK9GkIVwBECQGga/2KB
         ZghYh0eNpWE+Hyoda8Wv8bMUdCQfLzvZUH3W+SgT1slSzRMDpXA6+uXcO5+e5wZG37CM
         MCm0ij+H4Tvw0spfaTd49mnY67vJt701osHGU=
MIME-Version: 1.0
In-Reply-To: <20101215011904.GA24292@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	<20101214195124.GA6010@falooley.org>
	<1292356893.29257.1.camel@koala>
	<201012141849.03926.rob@landley.net>
	<20101215011904.GA24292@falooley.org>
Date: Wed, 15 Dec 2010 09:18:33 +0100
X-Google-Sender-Auth: nD_uiXq7b8o9H_Frnu-T8SffS_g
Message-ID: <AANLkTinaXvc=3r9gRNkSnttay-2yD9BDtXo0mOmMff0H@mail.gmail.com>
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jason Lunz <lunz@acm.org>
Cc: Rob Landley <rob@landley.net>, dedekind1@gmail.com,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
Content-Type: multipart/mixed; boundary=20cf3054a4b1486d4704976e9515
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3054a4b1486d4704976e9515
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 15, 2010 at 02:19, Jason Lunz <lunz@acm.org> wrote:
> On Tue, Dec 14, 2010 at 06:49:02PM -0600, Rob Landley wrote:
>> The problem is that jffs2 is a filesystem, and thus something people wou=
ld
>> really like to be able to loopback mount, but it's hardwired to assume i=
t's
>> only ever stored on a certain type of hardware, and thus requies incestu=
ous
>> knowledge of the erase granularity of the flash layer in order to functi=
on.
>
> I assume you can turn your jffs2 image file into a block dev using
> losetup, then turn the corresponding loop device into an mtd device
> using block2mtd, at which point you ought to be able to mount it with
> jffs2. I've never tried it.

And block2mtd is part of mtd, so you have to get mtd compiled first.

BTW, the patch I used in the past was less intrusive than yours.
I attached it, as I can't send it inline from here.
Note that it was against 2.6.31-rc4.

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds

--20cf3054a4b1486d4704976e9515
Content-Type: text/x-patch; charset=US-ASCII; name="uml-mtd.diff"
Content-Disposition: attachment; filename="uml-mtd.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpy4g330

Y29tbWl0IDU3ZmNlMGYxN2Y0OTc1ODMyNjZhMjYzMjg2OTBmNDBmMzNhZjA4YzUKQXV0aG9yOiBH
ZWVydCBVeXR0ZXJob2V2ZW4gPEdlZXJ0LlV5dHRlcmhvZXZlbkBzb255Y29tLmNvbT4KRGF0ZTog
ICBNb24gRGVjIDE1IDE1OjIxOjE1IDIwMDggKzAxMDAKCiAgICBVTUw6IEVuYWJsZSBNVEQsIGJ5
IG1vdmluZyB0aGUgZGVwZW5kZW5jeSBvbiBIQVNfSU9NRU0KCiAgICBTaWduZWQtb2ZmLWJ5OiBH
ZWVydCBVeXR0ZXJob2V2ZW4gPEdlZXJ0LlV5dHRlcmhvZXZlbkBzb255Y29tLmNvbT4KCmRpZmYg
LS1naXQgYS9hcmNoL3VtL0tjb25maWcucmVzdCBiL2FyY2gvdW0vS2NvbmZpZy5yZXN0CmluZGV4
IDBjY2FkMGYuLmUzNGYzOTkgMTAwNjQ0Ci0tLSBhL2FyY2gvdW0vS2NvbmZpZy5yZXN0CisrKyBi
L2FyY2gvdW0vS2NvbmZpZy5yZXN0CkBAIC0yOCw5ICsyOCw3IEBAIHNvdXJjZSAiZHJpdmVycy9z
Y3NpL0tjb25maWciCiAKIHNvdXJjZSAiZHJpdmVycy9tZC9LY29uZmlnIgogCi1pZiBCUk9LRU4K
LQlzb3VyY2UgImRyaXZlcnMvbXRkL0tjb25maWciCi1lbmRpZgorc291cmNlICJkcml2ZXJzL210
ZC9LY29uZmlnIgogCiBzb3VyY2UgImRyaXZlcnMvbGVkcy9LY29uZmlnIgogCmRpZmYgLS1naXQg
YS9kcml2ZXJzL210ZC9LY29uZmlnIGIvZHJpdmVycy9tdGQvS2NvbmZpZwppbmRleCBiOGUzNWEw
Li4wNTJiMDBjIDEwMDY0NAotLS0gYS9kcml2ZXJzL210ZC9LY29uZmlnCisrKyBiL2RyaXZlcnMv
bXRkL0tjb25maWcKQEAgLTEsNiArMSw1IEBACiBtZW51Y29uZmlnIE1URAogCXRyaXN0YXRlICJN
ZW1vcnkgVGVjaG5vbG9neSBEZXZpY2UgKE1URCkgc3VwcG9ydCIKLQlkZXBlbmRzIG9uIEhBU19J
T01FTQogCWhlbHAKIAkgIE1lbW9yeSBUZWNobm9sb2d5IERldmljZXMgYXJlIGZsYXNoLCBSQU0g
YW5kIHNpbWlsYXIgY2hpcHMsIG9mdGVuCiAJICB1c2VkIGZvciBzb2xpZCBzdGF0ZSBmaWxlIHN5
c3RlbXMgb24gZW1iZWRkZWQgZGV2aWNlcy4gVGhpcyBvcHRpb24KQEAgLTMxNSwxNSArMzE0LDE3
IEBAIGNvbmZpZyBNVERfT09QUwogCSAgVG8gdXNlLCBhZGQgY29uc29sZT10dHlNVER4IHRvIHRo
ZSBrZXJuZWwgY29tbWFuZCBsaW5lLAogCSAgd2hlcmUgeCBpcyB0aGUgTVREIGRldmljZSBudW1i
ZXIgdG8gdXNlLgogCi1zb3VyY2UgImRyaXZlcnMvbXRkL2NoaXBzL0tjb25maWciCi0KLXNvdXJj
ZSAiZHJpdmVycy9tdGQvbWFwcy9LY29uZmlnIgoraWYgSEFTX0lPTUVNCisJc291cmNlICJkcml2
ZXJzL210ZC9jaGlwcy9LY29uZmlnIgorCXNvdXJjZSAiZHJpdmVycy9tdGQvbWFwcy9LY29uZmln
IgorZW5kaWYKIAogc291cmNlICJkcml2ZXJzL210ZC9kZXZpY2VzL0tjb25maWciCiAKLXNvdXJj
ZSAiZHJpdmVycy9tdGQvbmFuZC9LY29uZmlnIgotCi1zb3VyY2UgImRyaXZlcnMvbXRkL29uZW5h
bmQvS2NvbmZpZyIKK2lmIEhBU19JT01FTQorCXNvdXJjZSAiZHJpdmVycy9tdGQvbmFuZC9LY29u
ZmlnIgorCXNvdXJjZSAiZHJpdmVycy9tdGQvb25lbmFuZC9LY29uZmlnIgorZW5kaWYKIAogc291
cmNlICJkcml2ZXJzL210ZC9scGRkci9LY29uZmlnIgogCmRpZmYgLS1naXQgYS9kcml2ZXJzL210
ZC9NYWtlZmlsZSBiL2RyaXZlcnMvbXRkL01ha2VmaWxlCmluZGV4IDgyZDFlNGQuLjA5ZmI1NDgg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbXRkL01ha2VmaWxlCisrKyBiL2RyaXZlcnMvbXRkL01ha2Vm
aWxlCkBAIC0yOSw2ICsyOSw3IEBAIG9iai0kKENPTkZJR19NVERfT09QUykJCSs9IG10ZG9vcHMu
bwogbmZ0bC1vYmpzCQk6PSBuZnRsY29yZS5vIG5mdGxtb3VudC5vCiBpbmZ0bC1vYmpzCQk6PSBp
bmZ0bGNvcmUubyBpbmZ0bG1vdW50Lm8KIAotb2JqLXkJCSs9IGNoaXBzLyBscGRkci8gbWFwcy8g
ZGV2aWNlcy8gbmFuZC8gb25lbmFuZC8gdGVzdHMvCitvYmoteQkJCQkrPSBkZXZpY2VzLyB0ZXN0
cy8KIAorb2JqLSQoQ09ORklHX0hBU19JT01FTSkJCSs9IGNoaXBzLyBscGRkci8gbWFwcy8gbmFu
ZC8gb25lbmFuZC8KIG9iai0kKENPTkZJR19NVERfVUJJKQkJKz0gdWJpLwpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tdGQvZGV2aWNlcy9LY29uZmlnIGIvZHJpdmVycy9tdGQvZGV2aWNlcy9LY29uZmln
CmluZGV4IDMyNWZhYjkuLjg4OTM3ZDYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbXRkL2RldmljZXMv
S2NvbmZpZworKysgYi9kcml2ZXJzL210ZC9kZXZpY2VzL0tjb25maWcKQEAgLTEwNiw2ICsxMDYs
NyBAQCBjb25maWcgTTI1UFhYX1VTRV9GQVNUX1JFQUQKIAogY29uZmlnIE1URF9TTFJBTQogCXRy
aXN0YXRlICJVbmNhY2hlZCBzeXN0ZW0gUkFNIgorCWRlcGVuZHMgb24gSEFTX0lPTUVNCiAJaGVs
cAogCSAgSWYgeW91ciBDUFUgY2Fubm90IGNhY2hlIGFsbCBvZiB0aGUgcGh5c2ljYWwgbWVtb3J5
IGluIHlvdXIgbWFjaGluZSwKIAkgIHlvdSBjYW4gc3RpbGwgdXNlIGl0IGZvciBzdG9yYWdlIG9y
IHN3YXAgYnkgdXNpbmcgdGhpcyBkcml2ZXIgdG8KQEAgLTExMyw2ICsxMTQsNyBAQCBjb25maWcg
TVREX1NMUkFNCiAKIGNvbmZpZyBNVERfUEhSQU0KIAl0cmlzdGF0ZSAiUGh5c2ljYWwgc3lzdGVt
IFJBTSIKKwlkZXBlbmRzIG9uIEhBU19JT01FTQogCWhlbHAKIAkgIFRoaXMgaXMgYSByZS1pbXBs
ZW1lbnRhdGlvbiBvZiB0aGUgc2xyYW0gZHJpdmVyIGFib3ZlLgogCkBAIC0xNzksNiArMTgxLDcg
QEAgY29uZmlnIE1URF9CTE9DSzJNVEQKIAkgIFRlc3RpbmcgTVREIHVzZXJzIChlZyBKRkZTMikg
b24gbGFyZ2UgbWVkaWEgYW5kIG1lZGlhIHRoYXQgbWlnaHQKIAkgIGJlIHJlbW92ZWQgZHVyaW5n
IGEgd3JpdGUgKHVzaW5nIHRoZSBmbG9wcHkgZHJpdmUpLgogCitpZiBIQVNfSU9NRU0KIGNvbW1l
bnQgIkRpc2stT24tQ2hpcCBEZXZpY2UgRHJpdmVycyIKIAogY29uZmlnIE1URF9ET0MyMDAwCkBA
IC0yOTcsNSArMzAwLDYgQEAgY29uZmlnIE1URF9ET0NQUk9CRV81NUFBCiAJICBMaW51eEJJT1Mg
b3IgaWYgeW91IG5lZWQgdG8gcmVjb3ZlciBhIERpc2tPbkNoaXAgTWlsbGVubml1bSBvbiB3aGlj
aAogCSAgeW91IGhhdmUgbWFuYWdlZCB0byB3aXBlIHRoZSBmaXJzdCBibG9jay4KIAorZW5kaWYK
IGVuZG1lbnUKIAo=
--20cf3054a4b1486d4704976e9515--
