Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1I1PV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:21:27 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53660 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1I1PV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:21:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110928120630.GB9456@netboy.at.omicron.at>
References: <20110928120630.GB9456@netboy.at.omicron.at>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 08:21:05 -0700
X-Google-Sender-Auth: ZjBIxjxAJPLj_IAkI05iTPa76GI
Message-ID: <CA+55aFy4aZPdUNBR0O3SP1iRRJyeF9kPZxH9G_eYdxueYskF4g@mail.gmail.com>
Subject: Re: MAC firmware does not load due to (commit 288d5abe usermodehelper)
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: multipart/mixed; boundary=0016e649d9b603c2e204ae01f215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e649d9b603c2e204ae01f215
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 28, 2011 at 5:06 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
>
> A warning appears on the console, shown below. =A0I don't know what
> commit 288d5abe was trying to fix, but it sure made a regression for
> me. It probably would also spoil using NFS boot, too.
>
> Any ideas what to do about this?

Something seems to be calling ioctl() befor rest_init() has even
completed. Which sounds odd, but I wonder if the schedule() there
before it might have let 'init' get going.

Does something like the attached (UNTESTED) fix it?

                             Linus

--0016e649d9b603c2e204ae01f215
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt4gmxy70

IGluaXQvbWFpbi5jIHwgICAgNCArLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbml0L21haW4uYyBiL2luaXQvbWFpbi5j
CmluZGV4IDJhOWI4OGFhNWU3Ni4uMjM3MDJiYmRiYzFkIDEwMDY0NAotLS0gYS9pbml0L21haW4u
YworKysgYi9pbml0L21haW4uYwpAQCAtMzgxLDkgKzM4MSw2IEBAIHN0YXRpYyBub2lubGluZSB2
b2lkIF9faW5pdF9yZWZvayByZXN0X2luaXQodm9pZCkKIAlwcmVlbXB0X2VuYWJsZV9ub19yZXNj
aGVkKCk7CiAJc2NoZWR1bGUoKTsKIAotCS8qIEF0IHRoaXMgcG9pbnQsIHdlIGNhbiBlbmFibGUg
dXNlciBtb2RlIGhlbHBlciBmdW5jdGlvbmFsaXR5ICovCi0JdXNlcm1vZGVoZWxwZXJfZW5hYmxl
KCk7Ci0KIAkvKiBDYWxsIGludG8gY3B1X2lkbGUgd2l0aCBwcmVlbXB0IGRpc2FibGVkICovCiAJ
cHJlZW1wdF9kaXNhYmxlKCk7CiAJY3B1X2lkbGUoKTsKQEAgLTczNCw2ICs3MzEsNyBAQCBzdGF0
aWMgdm9pZCBfX2luaXQgZG9fYmFzaWNfc2V0dXAodm9pZCkKIAlpbml0X2lycV9wcm9jKCk7CiAJ
ZG9fY3RvcnMoKTsKIAlkb19pbml0Y2FsbHMoKTsKKwl1c2VybW9kZWhlbHBlcl9lbmFibGUoKTsK
IH0KIAogc3RhdGljIHZvaWQgX19pbml0IGRvX3ByZV9zbXBfaW5pdGNhbGxzKHZvaWQpCg==
--0016e649d9b603c2e204ae01f215--
