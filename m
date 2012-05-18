Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2EREzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:55:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48644 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab2EREzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:55:31 -0400
MIME-Version: 1.0
Date: Fri, 18 May 2012 12:55:29 +0800
Message-ID: <CAH3Oq6Rhqr+cZmYPCOhHqOP=B60zw_GRFDCkOTjEr9wp9NtFmA@mail.gmail.com>
Subject: add IRQS_PENDING for nested, simple and level handler to early abort
 suspend operation
From: Ning Jiang <ning.n.jiang@gmail.com>
To: tglx@linutronix.de, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d042f9cd88f6e8704c0485cc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d042f9cd88f6e8704c0485cc5
Content-Type: text/plain; charset=ISO-8859-1

During suspend check_wakeup_irqs() will check IRQS_PENDING flag to
abort a suspend operation, however, this only applies for edge
triggered irq. Add IRQS_PENDING for nested, simple and level handler
to mimic the same behaviour as edge irq handler.

Without this optimization, level irq can be handled correctly but there
is some penalty. It has to go through a full run/suspend power cycle for level
irq to be detected and handled. With it, we can abort the suspend operation
earlier and thus shorten the interrupt latency.

I know this is ugly as IRQS_PENDING is intended for edge irq but I don't
know how to do it in a right way. Please enlighten me if you have better ideas.

Ning

--f46d042f9cd88f6e8704c0485cc5
Content-Type: application/octet-stream; 
	name="0001-genirq-add-IRQS_PENDING-for-nested-simple-and-level-.patch"
Content-Disposition: attachment; 
	filename="0001-genirq-add-IRQS_PENDING-for-nested-simple-and-level-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2cpdqob1

RnJvbSA3YjE3ZTVhZmJlODdjNmI3ODkyYzUwOGRmMDc0OWQ5OGZmNmIwMmU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaW5nIEppYW5nIDxuaW5nLm4uamlhbmdAZ21haWwuY29tPgpE
YXRlOiBGcmksIDE4IE1heSAyMDEyIDExOjEyOjMyICswODAwClN1YmplY3Q6IFtQQVRDSF0gZ2Vu
aXJxOiBhZGQgSVJRU19QRU5ESU5HIGZvciBuZXN0ZWQsIHNpbXBsZSBhbmQgbGV2ZWwgaGFuZGxl
cgoKRHVyaW5nIHN1c3BlbmQgY2hlY2tfd2FrZXVwX2lycXMoKSB3aWxsIGNoZWNrIElSUVNfUEVO
RElORyBmbGFnIHRvCmFib3J0IGEgc3VzcGVuZCBvcGVyYXRpb24sIGhvd2V2ZXIsIHRoaXMgb25s
eSBhcHBsaWVzIGZvciBlZGdlCnRyaWdnZXJlZCBpcnEuIEFkZCBJUlFTX1BFTkRJTkcgZm9yIG5l
c3RlZCwgc2ltcGxlIGFuZCBsZXZlbCBoYW5kbGVyCnRvIG1pbWljIHRoZSBzYW1lIGJlaGF2aW91
ciBhcyBlZGdlIGlycSBoYW5kbGVyLgoKU2lnbmVkLW9mZi1ieTogTmluZyBKaWFuZyA8bmluZy5u
LmppYW5nQGdtYWlsLmNvbT4KLS0tCiBrZXJuZWwvaXJxL2NoaXAuYyB8ICAgMTIgKysrKysrKysr
LS0tCiAxIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9rZXJuZWwvaXJxL2NoaXAuYyBiL2tlcm5lbC9pcnEvY2hpcC5jCmluZGV4IDM5
MTRjMWUuLmVlYmQ2ZDUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9pcnEvY2hpcC5jCisrKyBiL2tlcm5l
bC9pcnEvY2hpcC5jCkBAIC0yNzUsOCArMjc1LDEwIEBAIHZvaWQgaGFuZGxlX25lc3RlZF9pcnEo
dW5zaWduZWQgaW50IGlycSkKIAlrc3RhdF9pbmNyX2lycXNfdGhpc19jcHUoaXJxLCBkZXNjKTsK
IAogCWFjdGlvbiA9IGRlc2MtPmFjdGlvbjsKLQlpZiAodW5saWtlbHkoIWFjdGlvbiB8fCBpcnFk
X2lycV9kaXNhYmxlZCgmZGVzYy0+aXJxX2RhdGEpKSkKKwlpZiAodW5saWtlbHkoIWFjdGlvbiB8
fCBpcnFkX2lycV9kaXNhYmxlZCgmZGVzYy0+aXJxX2RhdGEpKSkgeworCQlkZXNjLT5pc3RhdGUg
fD0gSVJRU19QRU5ESU5HOwogCQlnb3RvIG91dF91bmxvY2s7CisJfQogCiAJaXJxZF9zZXQoJmRl
c2MtPmlycV9kYXRhLCBJUlFEX0lSUV9JTlBST0dSRVNTKTsKIAlyYXdfc3Bpbl91bmxvY2tfaXJx
KCZkZXNjLT5sb2NrKTsKQEAgLTMyNCw4ICszMjYsMTAgQEAgaGFuZGxlX3NpbXBsZV9pcnEodW5z
aWduZWQgaW50IGlycSwgc3RydWN0IGlycV9kZXNjICpkZXNjKQogCWRlc2MtPmlzdGF0ZSAmPSB+
KElSUVNfUkVQTEFZIHwgSVJRU19XQUlUSU5HKTsKIAlrc3RhdF9pbmNyX2lycXNfdGhpc19jcHUo
aXJxLCBkZXNjKTsKIAotCWlmICh1bmxpa2VseSghZGVzYy0+YWN0aW9uIHx8IGlycWRfaXJxX2Rp
c2FibGVkKCZkZXNjLT5pcnFfZGF0YSkpKQorCWlmICh1bmxpa2VseSghZGVzYy0+YWN0aW9uIHx8
IGlycWRfaXJxX2Rpc2FibGVkKCZkZXNjLT5pcnFfZGF0YSkpKSB7CisJCWRlc2MtPmlzdGF0ZSB8
PSBJUlFTX1BFTkRJTkc7CiAJCWdvdG8gb3V0X3VubG9jazsKKwl9CiAKIAloYW5kbGVfaXJxX2V2
ZW50KGRlc2MpOwogCkBAIC0zNzksOCArMzgzLDEwIEBAIGhhbmRsZV9sZXZlbF9pcnEodW5zaWdu
ZWQgaW50IGlycSwgc3RydWN0IGlycV9kZXNjICpkZXNjKQogCSAqIElmIGl0cyBkaXNhYmxlZCBv
ciBubyBhY3Rpb24gYXZhaWxhYmxlCiAJICoga2VlcCBpdCBtYXNrZWQgYW5kIGdldCBvdXQgb2Yg
aGVyZQogCSAqLwotCWlmICh1bmxpa2VseSghZGVzYy0+YWN0aW9uIHx8IGlycWRfaXJxX2Rpc2Fi
bGVkKCZkZXNjLT5pcnFfZGF0YSkpKQorCWlmICh1bmxpa2VseSghZGVzYy0+YWN0aW9uIHx8IGly
cWRfaXJxX2Rpc2FibGVkKCZkZXNjLT5pcnFfZGF0YSkpKSB7CisJCWRlc2MtPmlzdGF0ZSB8PSBJ
UlFTX1BFTkRJTkc7CiAJCWdvdG8gb3V0X3VubG9jazsKKwl9CiAKIAloYW5kbGVfaXJxX2V2ZW50
KGRlc2MpOwogCi0tIAoxLjcuMQoK
--f46d042f9cd88f6e8704c0485cc5--
