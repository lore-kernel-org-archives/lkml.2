Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab1JGLRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:17:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39132 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab1JGLRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:17:11 -0400
MIME-Version: 1.0
Date: Fri, 7 Oct 2011 13:10:52 +0200
Message-ID: <CAB5oZtBbd7N5vK-5ZxmnHcRATsZaTRFwonckTeJZrAaUV0VPZw@mail.gmail.com>
Subject: [PATCH] accessfs: move get_sb to mount
From: Harro Haan <hrhaan@gmail.com>
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        Remy Bohmer <linux@bohmer.net>
Content-Type: multipart/mixed; boundary=000e0ce0f59897cee504aeb37e37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0ce0f59897cee504aeb37e37
Content-Type: text/plain; charset=UTF-8

Olaf,

Accessfs did not work anymore for recent kernels, because there have
been a few vfs changes. This is already described by Randy Dunlap:
https://lkml.org/lkml/2011/4/24/65

The attached patch will fix this.

Regards,

Harro

On 21 August 2011 11:22, Remy Bohmer <linux@bohmer.net> wrote:
> Hi Olaf,
>
> Attached I have put 2 patches:
> - accessfs-2.6.38-0.25.patch : Patch has been forward ported to 3.0
> - accessfs-2.6.38-0.25-fix-build.patch: This patch has to be applied
> to make it compile on 3.0 when CONFIG_NET_HOOKS and CONFIG_ACCESS_FS
> both are NOT set.
> I expect that this fix-build patch has to be applied to the 2.6.38
> edition as well, since it results in unresolved externals that should
> be there on 2.6.38 as well.
>
> Kind regards,
>
> Remy
>

--000e0ce0f59897cee504aeb37e37
Content-Type: application/octet-stream; 
	name="accessfs-move-get_sb-to-mount.patch"
Content-Disposition: attachment; 
	filename="accessfs-move-get_sb-to-mount.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gth2n2h72

RnJvbSA2NGIxN2ZkOTc0YTFiNmNlNDI2NTVkNDRiZjVhMzA4ODM3MzZlNmRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIYXJybyBIYWFuIDxocmhhYW5AZ21haWwuY29tPgpEYXRlOiBU
dWUsIDQgT2N0IDIwMTEgMTY6NTY6MDggKzAyMDAKU3ViamVjdDogW1BBVENIXSBhY2Nlc3Nmczog
bW92ZSBnZXRfc2IgdG8gbW91bnQKCkFjY2Vzc2ZzIGRpZCBub3QgYnVpbGQgYW55bW9yZSBmb3Ig
cmVjZW50IGtlcm5lbHMsCmJlY2F1c2UgdGhlcmUgaGF2ZSBiZWVuIGEgZmV3IHZmcyBjaGFuZ2Vz
LiBGb3IgZGV0YWlscyBzZWU6Cmh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDExLzQvMjQvNjUKCkFm
dGVyIHJlYWRpbmcgdGhlIHRocmVhZCAidmZzOiB3aGVyZSBpcyBnZXRfc2Jfc2luZ2xlKCk/Igpp
cyB3YXMgZWFzeSB0byBmaXg6IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDExLzUvMjUvMjE3CgpU
aGlzIHBhdGNoIGhhcyBiZWVuIHRlc3RlZCBvbiBsaW51eC0zLjAuNAoKU2lnbmVkLW9mZi1ieTog
SGFycm8gSGFhbiA8aHJoYWFuQGdtYWlsLmNvbT4KLS0tCiBmcy9hY2Nlc3Nmcy9pbm9kZS5jIHwg
ICAgOSArKysrLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2FjY2Vzc2ZzL2lub2RlLmMgYi9mcy9hY2Nlc3Nmcy9p
bm9kZS5jCmluZGV4IDgzMjg2N2EuLmEyMjQ3ZTIgMTAwNjQ0Ci0tLSBhL2ZzL2FjY2Vzc2ZzL2lu
b2RlLmMKKysrIGIvZnMvYWNjZXNzZnMvaW5vZGUuYwpAQCAtMzU2LDExICszNTYsMTAgQEAgc3Rh
dGljIGludCBhY2Nlc3Nmc19maWxsX3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHZvaWQg
KmRhdGEsIGludCBzaWxlbnQpCiAJcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyBpbnQgYWNjZXNzZnNf
Z2V0X3NiKHN0cnVjdCBmaWxlX3N5c3RlbV90eXBlICpmc190eXBlLAotCQkJICAgaW50IGZsYWdz
LCBjb25zdCBjaGFyICpkZXZfbmFtZSwKLQkJCSAgIHZvaWQgKmRhdGEsIHN0cnVjdCB2ZnNtb3Vu
dCAqbW50KQorc3RhdGljIHN0cnVjdCBkZW50cnkgKmFjY2Vzc2ZzX21vdW50KHN0cnVjdCBmaWxl
X3N5c3RlbV90eXBlICpmc190eXBlLAorCQkJICAgaW50IGZsYWdzLCBjb25zdCBjaGFyICpkZXZf
bmFtZSwgdm9pZCAqZGF0YSkKIHsKLQlyZXR1cm4gZ2V0X3NiX3NpbmdsZShmc190eXBlLCBmbGFn
cywgZGF0YSwgYWNjZXNzZnNfZmlsbF9zdXBlciwgbW50KTsKKwlyZXR1cm4gbW91bnRfc2luZ2xl
KGZzX3R5cGUsIGZsYWdzLCBkYXRhLCBhY2Nlc3Nmc19maWxsX3N1cGVyKTsKIH0KIAogaW50IGFj
Y2Vzc2ZzX3Blcm1pdHRlZChzdHJ1Y3QgYWNjZXNzX2F0dHIgKnAsIGludCBtYXNrKQpAQCAtNDAx
LDcgKzQwMCw3IEBAIHZvaWQgYWNjZXNzZnNfdW5yZWdpc3RlcihzdHJ1Y3QgYWNjZXNzZnNfZGly
ZW50cnkgKmRpciwgY29uc3QgY2hhciAqbmFtZSkKIHN0YXRpYyBzdHJ1Y3QgZmlsZV9zeXN0ZW1f
dHlwZSBhY2Nlc3Nmc19mc190eXBlID0gewogCS5vd25lciA9CVRISVNfTU9EVUxFLAogCS5uYW1l
ID0JCSJhY2Nlc3NmcyIsCi0JLmdldF9zYiA9CWFjY2Vzc2ZzX2dldF9zYiwKKwkubW91bnQgPQlh
Y2Nlc3Nmc19tb3VudCwKIAkua2lsbF9zYiA9CWtpbGxfYW5vbl9zdXBlciwKIH07CiAKLS0gCjEu
Ny4wLjQKCg==
--000e0ce0f59897cee504aeb37e37--
