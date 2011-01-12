Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1ALU1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:27:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263Ab1ALU1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <20110112114649.5365d518@jbarnes-desktop>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
 <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com> <20110112114649.5365d518@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 12:27:30 -0800
Message-ID: <AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com>
Subject: Re: [git pull] drm intel only fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: multipart/mixed; boundary=00221532c778efb5020499ac08d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00221532c778efb5020499ac08d8
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 12, 2011 at 11:46 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Since I doubt we're actually offloading to our video decode kernels for
> Flash video on your machine

It's the latest 64-bit beta flash player, so maybe it does use hw acceleration.


>                       it could very well be a memory bw issue.
> Can you try this small patch to see if one of the low power watermarks
> is giving you trouble (note: cut & pasted)?

No difference.

> It could also be the normal power watermarks though too; you could just
> make plane-wm and cursor_wm higher to test that.

I multiplied them by two, no difference. The patch I used attached.

Does nobody else see this?

                       Linus

--00221532c778efb5020499ac08d8
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_giuolu2v0

IGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYyB8ICAgIDQgKysrKwogMSBmaWxl
cyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jIGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaW50ZWxfZGlzcGxheS5jCmluZGV4IDI1ZDk2ODguLjJlYTFhNTEgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYworKysgYi9kcml2ZXJzL2dwdS9kcm0v
aTkxNS9pbnRlbF9kaXNwbGF5LmMKQEAgLTM0NDUsNiArMzQ0NSw3IEBAIHN0YXRpYyBib29sIGly
b25sYWtlX2NvbXB1dGVfd20wKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsCiAJCWVudHJpZXMgKz0g
dGxiX21pc3M7CiAJZW50cmllcyA9IERJVl9ST1VORF9VUChlbnRyaWVzLCBkaXNwbGF5LT5jYWNo
ZWxpbmVfc2l6ZSk7CiAJKnBsYW5lX3dtID0gZW50cmllcyArIGRpc3BsYXktPmd1YXJkX3NpemU7
CisqcGxhbmVfd20gKj0yOwogCWlmICgqcGxhbmVfd20gPiAoaW50KWRpc3BsYXktPm1heF93bSkK
IAkJKnBsYW5lX3dtID0gZGlzcGxheS0+bWF4X3dtOwogCkBAIC0zNDU3LDYgKzM0NTgsNyBAQCBz
dGF0aWMgYm9vbCBpcm9ubGFrZV9jb21wdXRlX3dtMChzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LAog
CQllbnRyaWVzICs9IHRsYl9taXNzOwogCWVudHJpZXMgPSBESVZfUk9VTkRfVVAoZW50cmllcywg
Y3Vyc29yLT5jYWNoZWxpbmVfc2l6ZSk7CiAJKmN1cnNvcl93bSA9IGVudHJpZXMgKyBjdXJzb3It
Pmd1YXJkX3NpemU7CisqY3Vyc29yX3dtICo9IDI7CiAJaWYgKCpjdXJzb3Jfd20gPiAoaW50KWN1
cnNvci0+bWF4X3dtKQogCQkqY3Vyc29yX3dtID0gKGludCljdXJzb3ItPm1heF93bTsKIApAQCAt
MzYwNyw2ICszNjA5LDggQEAgc3RhdGljIHZvaWQgaXJvbmxha2VfdXBkYXRlX3dtKHN0cnVjdCBk
cm1fZGV2aWNlICpkZXYsCiAJaWYgKGVuYWJsZWQgIT0gMSkKIAkJcmV0dXJuOwogCityZXR1cm47
CisKIAljbG9jayA9IHBsYW5lYV9jbG9jayA/IHBsYW5lYV9jbG9jayA6IHBsYW5lYl9jbG9jazsK
IAogCS8qIFdNMSAqLwo=
--00221532c778efb5020499ac08d8--
