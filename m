Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2LTPuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:50:00 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:48371 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2LTPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:49:40 -0500
MIME-Version: 1.0
In-Reply-To: <034FBC2C8CCA484FBA5BA5FC707AC8303AD02F0D1E@EXMB02.eu.tieto.com>
References: <034FBC2C8CCA484FBA5BA5FC707AC8303AD02F0D1E@EXMB02.eu.tieto.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2012 07:49:18 -0800
X-Google-Sender-Auth: ol1-DMmk9e2EmpW10AraMPlht4o
Message-ID: <CA+55aFxbE9G+2NdA_8s1vyjrkNE5mBdYZ5Cy9tYr4AJOdvdivg@mail.gmail.com>
Subject: Re: [PATCH] mmc:core:if detect mmc card remove,don't wait for req done
To: zhenpeng.qian@tieto.com, Chris Ball <cjb@laptop.org>
Cc: Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-mmc@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7bfcf91ab3634104d14aada3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bfcf91ab3634104d14aada3
Content-Type: text/plain; charset=ISO-8859-1

Hi,

On Thu, Dec 20, 2012 at 1:32 AM,  <zhenpeng.qian@tieto.com> wrote:
>
>         I find a bug about mmc/core/core.c, and send you a patch which I fix
> this bug.
>
>         In fact, the bug is a low probability of occurrence.
>
>         Hope you help me to analyze it and discuss with me.

I've added the proper people - Chris Ball and linux-mmc - to the
participants list.

I also wanted to check with you: the commit message implies that this
can cause an IO timeout and then a call to
msmsdcc_start_command_deferred() with a NULL cmd->mrq. Which I assume
results in a NULL pointer dereference and Oops, but that wasn't
spelled out.

Chris, please give it a look, and perhaps edit the commit message a bit.

                     Linus

--047d7bfcf91ab3634104d14aada3
Content-Type: application/octet-stream; name="0001-mmc-core.patch"
Content-Disposition: attachment; filename="0001-mmc-core.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hay2ajo01

RnJvbSAwYWNiNjhkNWI3ZDA3OThlZmMzOTMyYjQwNTc3NjhkMGQ3MmRiZDBmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBaaGVucGVuZyBRaWFuIDx6aGVucGVuZy5xaWFuQHRpZXRvLmNv
bT4KRGF0ZTogVGh1LCAyMCBEZWMgMjAxMiAxNjoyMDoxMiArMDgwMApTdWJqZWN0OiBbUEFUQ0hd
IG1tYzpjb3JlOmlmIGRldGVjdCBtbWMgY2FyZCByZW1vdmUsZG9uJ3Qgd2FpdCBmb3IgcmVxIGRv
bmUKCmZ1bmN0aW9uIG1tY193YWl0X2Zvcl9yZXEgY2FsbCBfX21tY19zdGFydF9yZXEsaWYgZGV0
ZWN0IG1tYyBjYXJkIHJlbW92ZQosaXQgd2lsbCByZXR1cm4gLUVOT01FRElVTSBhbmQgZG9uJ3Qg
d2FpdCBmb3IgcmVxIGRvbmUuICBJbiB0aGlzIHdheSxpdApjYW4gcmVkdWNlIGlvX3NjaGVkdWxl
IG9uY2UuCgpBbmQgaWYgaW9fc2NoZWR1bGUgdGltZW91dCBhbmQgY2hlY2sgbW1jX2NhcmRfcmVt
b3ZlIGZhaWwsaXQgd2lsbCBjYWxsCmhvc3QtPm9wcy0+cmVxdWVzdCwoc29tZXRpbWVzIGl0IG1h
eSBvY2N1ciBieSBpbnNtb2QgYW5kIHJtbW9kIGZhc3QpLCBpdAp3aWxsIGNhbGwgbXNtc2RjY19z
dGFydF9jb21tYW5kX2RlZmVycmVkIGZpbmFsbHkgLCBhbmQgY21kLT5tcnEgaXMgTlVMTCwKaXQg
aXMgaW5pdCBpbiBtbWNfc3RhcnRfcmVxdWVzdC4gCgoxMCBbPGMwNmU4NDU4Pl0gKF9fZGFidF9z
dmMpIGZyb20gWzxjMDRjOGMyYz5dCjExIFs8YzA0YzhhNDQ+XSAobXNtc2RjY19zdGFydF9jb21t
YW5kX2RlZmVycmVkKSBmcm9tIFs8YzA0YzhjMmM+XQoxMiBbPGMwNGM4YzJjPl0gKG1zbXNkY2Nf
c3RhcnRfY29tbWFuZCkgZnJvbSBbPGMwNGQxNDI4Pl0KMTMgWzxjMDRkMTQyOD5dIChtc21zZGNj
X3JlcXVlc3QpIGZyb20gWzxjMDRiN2M4MD5dCjE0IFs8YzA0YjdjODA+XSAobW1jX3dhaXRfZm9y
X3JlcV9kb25lKSBmcm9tIFs8YzA0Yjg2MzA+XQoxNSBbPGMwNGI4NjMwPl0gKG1tY193YWl0X2Zv
cl9jbWQpIGZyb20gWzxjMDRjNDk4MD5dCjE2IFs8YzA0YzQ5ODA+XSAoZ2V0X2NhcmRfc3RhdHVz
KSBmcm9tIFs8YzA0YzUzMzg+XQoxNyBbPGMwNGM1MzM4Pl0gKG1tY19ibGtfZXJyX2NoZWNrKSBm
cm9tIFs8YzA0YjhhNzg+XQoxOCBbPGMwNGI4YTc4Pl0gKG1tY19zdGFydF9yZXEpIGZyb20gWzxj
MDRjNjAyMD5dCjE5IFs8YzA0YzYwMjA+XSAobW1jX2Jsa19pc3N1ZV9yd19ycSkgZnJvbSBbPGMw
NGM2YTFjPl0KMjAgWzxjMDRjNmExYz5dIChtbWNfYmxrX2lzc3VlX3JxKSBmcm9tIFs8YzA0YzZj
N2M+XQoyMSBbPGMwNGM2YzdjPl0gKG1tY19xdWV1ZV90aHJlYWQpIGZyb20gWzxjMDA5MWQ1ND5d
CjIyIFs8YzAwOTFkNTQ+XSAoa3RocmVhZCkgZnJvbSBbPGMwMDBmMDI4Pl0KClNpZ25lZC1vZmYt
Ynk6IFFpYW4gemhlbnBlbmcgPHpoZW5wZW5nLnFpYW5AdGlldG8uY29tPgotLS0KIGRyaXZlcnMv
bW1jL2NvcmUvY29yZS5jIHwgNyArKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2NvcmUvY29yZS5j
IGIvZHJpdmVycy9tbWMvY29yZS9jb3JlLmMKaW5kZXggYWFlZDc2OC4uZmFjMDE4YyAxMDA2NDQK
LS0tIGEvZHJpdmVycy9tbWMvY29yZS9jb3JlLmMKKysrIGIvZHJpdmVycy9tbWMvY29yZS9jb3Jl
LmMKQEAgLTQ3MCw4ICs0NzAsMTEgQEAgRVhQT1JUX1NZTUJPTChtbWNfc3RhcnRfcmVxKTsKICAq
Lwogdm9pZCBtbWNfd2FpdF9mb3JfcmVxKHN0cnVjdCBtbWNfaG9zdCAqaG9zdCwgc3RydWN0IG1t
Y19yZXF1ZXN0ICptcnEpCiB7Ci0JX19tbWNfc3RhcnRfcmVxKGhvc3QsIG1ycSk7Ci0JbW1jX3dh
aXRfZm9yX3JlcV9kb25lKGhvc3QsIG1ycSk7CisJaW50IGVycjsKKwllcnI9X19tbWNfc3RhcnRf
cmVxKGhvc3QsIG1ycSk7CisJLyogaWYgZGV0ZWN0IG1tYyBjYXJkIHJlbW92ZSxkb24ndCB3YWl0
IGZvciByZXEgZG9uZSovCisJaWYgKCFlcnIpCisJCW1tY193YWl0X2Zvcl9yZXFfZG9uZShob3N0
LCBtcnEpOwogfQogRVhQT1JUX1NZTUJPTChtbWNfd2FpdF9mb3JfcmVxKTsKIAotLSAKMS43LjEx
LjMKCg==
--047d7bfcf91ab3634104d14aada3--
