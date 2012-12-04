Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab2LDCCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 21:02:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56111 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2LDCCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 21:02:37 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxrf=wx=fbvCRbFxt_=C4ne1-j3T=5JeLYzUG3SmpaECQ@mail.gmail.com>
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
 <874nk2u69u.fsf@silenus.orebokech.com> <CA+55aFxO+nOM--EJmrT+_54jF8AL2YZ7GhbwCT2cg2qxM2Md+A@mail.gmail.com>
 <CA+8MBbJGy7xQFqi1VXPuPNHJnoZUcxjWDkmyRKeajXGAA_Q+GA@mail.gmail.com>
 <CA+55aFyAvpCKPWV9Mh34aV6Q4DRjATQky939vYaPBfx6+65Nxw@mail.gmail.com> <CA+55aFxrf=wx=fbvCRbFxt_=C4ne1-j3T=5JeLYzUG3SmpaECQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Dec 2012 18:02:15 -0800
X-Google-Sender-Auth: gqPcUSP6Q1CgtiZfyJuZxFISpuc
Message-ID: <CA+55aFyD2c2oBPX7XFoYvFP1k6j0ScYevndh19Rj1GwkG67Dgg@mail.gmail.com>
Subject: Re: Linux 3.7-rc8
To: Tony Luck <tony.luck@intel.com>
Cc: Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d04428eae84b85604cffd4298
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04428eae84b85604cffd4298
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Dec 3, 2012 at 3:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yup, I can reproduce it with that.
>
> I'll shut the printk up some way. In the meantime, you can ignore it.

Here's a patch to handle the "buffer head crosses the end of the disk" case.

It works for me, and in fact it should allow us to basically always
set the default block size to the PAGE_CACHE_SIZE (see bd_set_size()).
But it doesn't do that part yet, this is just the "guard against
crossing bh" part.

Does that fix the printk's for you too?

                    Linus

--f46d04428eae84b85604cffd4298
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_haadub600

IGZzL2J1ZmZlci5jIHwgNTIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDUyIGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS9mcy9idWZmZXIuYyBiL2ZzL2J1ZmZlci5jCmluZGV4IDM1ODZmYjA1YzhjZS4uYzRlMTEz
OTBhNDRjIDEwMDY0NAotLS0gYS9mcy9idWZmZXIuYworKysgYi9mcy9idWZmZXIuYwpAQCAtMjg5
Myw2ICsyODkzLDU1IEBAIHN0YXRpYyB2b2lkIGVuZF9iaW9fYmhfaW9fc3luYyhzdHJ1Y3QgYmlv
ICpiaW8sIGludCBlcnIpCiAJYmlvX3B1dChiaW8pOwogfQogCisvKgorICogVGhpcyBhbGxvd3Mg
dXMgdG8gZG8gSU8gZXZlbiBvbiB0aGUgb2RkIGxhc3Qgc2VjdG9ycworICogb2YgYSBkZXZpY2Us
IGV2ZW4gaWYgdGhlIGJoIGJsb2NrIHNpemUgaXMgc29tZSBtdWx0aXBsZQorICogb2YgdGhlIHBo
eXNpY2FsIHNlY3RvciBzaXplLgorICoKKyAqIFdlJ2xsIGp1c3QgdHJ1bmNhdGUgdGhlIGJpbyB0
byB0aGUgc2l6ZSBvZiB0aGUgZGV2aWNlLAorICogYW5kIGNsZWFyIHRoZSBlbmQgb2YgdGhlIGJ1
ZmZlciBoZWFkIG1hbnVhbGx5LgorICoKKyAqIFRydWx5IG91dC1vZi1yYW5nZSBhY2Nlc3NlcyB3
aWxsIHR1cm4gaW50byBhY3R1YWwgSU8KKyAqIGVycm9ycywgdGhpcyBvbmx5IGhhbmRsZXMgdGhl
ICJ3ZSBuZWVkIHRvIGJlIGFibGUgdG8KKyAqIGRvIElPIGF0IHRoZSBmaW5hbCBzZWN0b3IiIGNh
c2UuCisgKi8KK3N0YXRpYyB2b2lkIGd1YXJkX2JoX2VvZChpbnQgcncsIHN0cnVjdCBiaW8gKmJp
bywgc3RydWN0IGJ1ZmZlcl9oZWFkICpiaCkKK3sKKwlzZWN0b3JfdCBtYXhzZWN0b3I7CisJdW5z
aWduZWQgYnl0ZXM7CisKKwltYXhzZWN0b3IgPSBpX3NpemVfcmVhZChiaW8tPmJpX2JkZXYtPmJk
X2lub2RlKSA+PiA5OworCWlmICghbWF4c2VjdG9yKQorCQlyZXR1cm47CisKKwkvKgorCSAqIElm
IHRoZSAqd2hvbGUqIElPIGlzIHBhc3QgdGhlIGVuZCBvZiB0aGUgZGV2aWNlLAorCSAqIGxldCBp
dCB0aHJvdWdoLCBhbmQgdGhlIElPIGxheWVyIHdpbGwgdHVybiBpdCBpbnRvCisJICogYW4gRUlP
LgorCSAqLworCWlmICh1bmxpa2VseShiaW8tPmJpX3NlY3RvciA+PSBtYXhzZWN0b3IpKQorCQly
ZXR1cm47CisKKwltYXhzZWN0b3IgLT0gYmlvLT5iaV9zZWN0b3I7CisJYnl0ZXMgPSBiaW8tPmJp
X3NpemU7CisJaWYgKGxpa2VseSgoYnl0ZXMgPj4gOSkgPD0gbWF4c2VjdG9yKSkKKwkJcmV0dXJu
OworCisJLyogVWhodWguIFdlJ3ZlIGdvdCBhIGJoIHRoYXQgc3RyYWRkbGVzIHRoZSBkZXZpY2Ug
c2l6ZSEgKi8KKwlieXRlcyA9IG1heHNlY3RvciA8PCA5OworCisJLyogVHJ1bmNhdGUgdGhlIGJp
by4uICovCisJYmlvLT5iaV9zaXplID0gYnl0ZXM7CisJYmlvLT5iaV9pb192ZWNbMF0uYnZfbGVu
ID0gYnl0ZXM7CisKKwkvKiAuLmFuZCBjbGVhciB0aGUgZW5kIG9mIHRoZSBidWZmZXIgZm9yIHJl
YWRzICovCisJaWYgKHJ3ICYgUkVBRCkgeworCQl2b2lkICprYWRkciA9IGttYXBfYXRvbWljKGJo
LT5iX3BhZ2UpOworCQltZW1zZXQoa2FkZHIgKyBiaF9vZmZzZXQoYmgpICsgYnl0ZXMsIDAsIGJo
LT5iX3NpemUgLSBieXRlcyk7CisJCWt1bm1hcF9hdG9taWMoa2FkZHIpOworCX0KK30KKwogaW50
IHN1Ym1pdF9iaChpbnQgcncsIHN0cnVjdCBidWZmZXJfaGVhZCAqIGJoKQogewogCXN0cnVjdCBi
aW8gKmJpbzsKQEAgLTI5MjksNiArMjk3OCw5IEBAIGludCBzdWJtaXRfYmgoaW50IHJ3LCBzdHJ1
Y3QgYnVmZmVyX2hlYWQgKiBiaCkKIAliaW8tPmJpX2VuZF9pbyA9IGVuZF9iaW9fYmhfaW9fc3lu
YzsKIAliaW8tPmJpX3ByaXZhdGUgPSBiaDsKIAorCS8qIFRha2UgY2FyZSBvZiBiaCdzIHRoYXQg
c3RyYWRkbGUgdGhlIGVuZCBvZiB0aGUgZGV2aWNlICovCisJZ3VhcmRfYmhfZW9kKHJ3LCBiaW8s
IGJoKTsKKwogCWJpb19nZXQoYmlvKTsKIAlzdWJtaXRfYmlvKHJ3LCBiaW8pOwogCg==
--f46d04428eae84b85604cffd4298--
