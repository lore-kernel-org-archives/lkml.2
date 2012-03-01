Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2CAQXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:23:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59439 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2CAQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:23:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.85.35 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4F8BEE.3040806@teksavvy.com>
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
 <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
 <4F4F8BEE.3040806@teksavvy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2012 08:22:54 -0800
X-Google-Sender-Auth: Npn0IjgDRbM0mzbl_53OGbngjMc
Message-ID: <CA+55aFyij_ORw+BE-Sbkt9Y9qcUQSmW_4e-r7p3t0DNA4Sg9pA@mail.gmail.com>
Subject: Re: Linux 3.3-rc5
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d041824f67ee32d04ba30e046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d041824f67ee32d04ba30e046
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 1, 2012 at 6:47 AM, Mark Lord <kernel@teksavvy.com> wrote:
>
> It's close (after adding a missing left-paren), but not 100% working yet.
> In particular, this command fails to get valid data: =A0i8kctl bios
>
> =A0 =A0ioctl(3, I8K_BIOS_VERSION, 0xbfc543c8) =A0=3D -1 EINVAL (Invalid a=
rgument)

Hmm. That makes no sense.

I8K_BIOS_VERSION is 0x80046980 - and it already matches on both x86-64
and x86-32. I just checked by compiling to asm. And the size is '4',
so it wouldn't trigger any changes by the sizemask thing either.

Ugh. But my patch was crap. It fixed up "arg", but it *should* have
fixed up "cmd".

Stupid.

So try *this* one instead. I also fixed up the missing parenthesis,
but didn't add the actual .compat function etc.

Does *this* work? And if not, can you do an strace, but use the "-e
raw=3Dioctl" option to make it show the ioctl numbers as raw hex to
verify..

                     Linus

                        Linus

--f46d041824f67ee32d04ba30e046
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gza01iyc0

IGRyaXZlcnMvY2hhci9pOGsuYyAgfCAgICA0ICsrKysKIGluY2x1ZGUvbGludXgvaThrLmggfCAg
IDIyICsrKysrKysrKysrKysrKystLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMjAgaW5zZXJ0aW9u
cygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvaThrLmMgYi9k
cml2ZXJzL2NoYXIvaThrLmMKaW5kZXggNDBjYzBjZjJkZWQ2Li4yYmFhOTIxYWZkODQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvY2hhci9pOGsuYworKysgYi9kcml2ZXJzL2NoYXIvaThrLmMKQEAgLTMy
Niw2ICszMjYsMTAgQEAgaThrX2lvY3RsX3VubG9ja2VkKHN0cnVjdCBmaWxlICpmcCwgdW5zaWdu
ZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpCiAJaWYgKCFhcmdwKQogCQlyZXR1cm4gLUVJ
TlZBTDsKIAorCS8qIFdlIGhhZCBzb21lIGJhZCA2NC1iaXQgY29uZnVzaW9uICovCisJaWYgKCgo
Y21kID4+IF9JT0NfU0laRVNISUZUKSAmIF9JT0NfU0laRU1BU0spID09IDgpCisJCWNtZCAtPSA0
IDw8IF9JT0NfU0laRVNISUZUOworCiAJc3dpdGNoIChjbWQpIHsKIAljYXNlIEk4S19CSU9TX1ZF
UlNJT046CiAJCXZhbCA9IGk4a19nZXRfYmlvc192ZXJzaW9uKCk7CmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2k4ay5oIGIvaW5jbHVkZS9saW51eC9pOGsuaAppbmRleCAxYzQ1YmE1MDUxMTUu
LjY1MGY0MDE1Yzg5YyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pOGsuaAorKysgYi9pbmNs
dWRlL2xpbnV4L2k4ay5oCkBAIC0yMCwxNCArMjAsMjQgQEAKICNkZWZpbmUgSThLX1BST0MJCSIv
cHJvYy9pOGsiCiAjZGVmaW5lIEk4S19QUk9DX0ZNVAkJIjEuMCIKIAorLyoKKyAqIEZvciBoeXN0
ZXJpY2FsIHJhaXNpbnMgd2UgZXhwb3NlIHRoZSB3cm9uZyBzaXplIHRvIHVzZXIgc3BhY2UKKyAq
IGluIHRoZSBpb2N0bCBudW1iZXJpbmcuIFRoZSBhY3R1YWwgcmVhbCBkYXRhIHNpemUgaXMgImlu
dCIuCisgKi8KKyNpZmRlZiBfX0tFUk5FTF9fCisjZGVmaW5lIGJvcmtlZF9pOGtfYXJnIGludAor
I2Vsc2UKKyNkZWZpbmUgYm9ya2VkX2k4a19hcmcgc2l6ZV90CisjZW5kaWYKKwogI2RlZmluZSBJ
OEtfQklPU19WRVJTSU9OCV9JT1IgKCdpJywgMHg4MCwgaW50KQkvKiBicm9rZW46IG1lYW50IDQg
Ynl0ZXMgKi8KICNkZWZpbmUgSThLX01BQ0hJTkVfSUQJCV9JT1IgKCdpJywgMHg4MSwgaW50KQkv
KiBicm9rZW46IG1lYW50IDE2IGJ5dGVzICovCi0jZGVmaW5lIEk4S19QT1dFUl9TVEFUVVMJX0lP
UiAoJ2knLCAweDgyLCBzaXplX3QpCi0jZGVmaW5lIEk4S19GTl9TVEFUVVMJCV9JT1IgKCdpJywg
MHg4Mywgc2l6ZV90KQotI2RlZmluZSBJOEtfR0VUX1RFTVAJCV9JT1IgKCdpJywgMHg4NCwgc2l6
ZV90KQotI2RlZmluZSBJOEtfR0VUX1NQRUVECQlfSU9XUignaScsIDB4ODUsIHNpemVfdCkKLSNk
ZWZpbmUgSThLX0dFVF9GQU4JCV9JT1dSKCdpJywgMHg4Niwgc2l6ZV90KQotI2RlZmluZSBJOEtf
U0VUX0ZBTgkJX0lPV1IoJ2knLCAweDg3LCBzaXplX3QpCisjZGVmaW5lIEk4S19QT1dFUl9TVEFU
VVMJX0lPUiAoJ2knLCAweDgyLCBib3JrZWRfaThrX2FyZykKKyNkZWZpbmUgSThLX0ZOX1NUQVRV
UwkJX0lPUiAoJ2knLCAweDgzLCBib3JrZWRfaThrX2FyZykKKyNkZWZpbmUgSThLX0dFVF9URU1Q
CQlfSU9SICgnaScsIDB4ODQsIGJvcmtlZF9pOGtfYXJnKQorI2RlZmluZSBJOEtfR0VUX1NQRUVE
CQlfSU9XUignaScsIDB4ODUsIGJvcmtlZF9pOGtfYXJnKQorI2RlZmluZSBJOEtfR0VUX0ZBTgkJ
X0lPV1IoJ2knLCAweDg2LCBib3JrZWRfaThrX2FyZykKKyNkZWZpbmUgSThLX1NFVF9GQU4JCV9J
T1dSKCdpJywgMHg4NywgYm9ya2VkX2k4a19hcmcpCiAKICNkZWZpbmUgSThLX0ZBTl9MRUZUCQkx
CiAjZGVmaW5lIEk4S19GQU5fUklHSFQJCTAK
--f46d041824f67ee32d04ba30e046--
