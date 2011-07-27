Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1G0MVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:21:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35034 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1G0MVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:21:21 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 13:21:19 +0100
Message-ID: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
Subject: [PATCH] bitops: Use volatile in generic atomic bitops.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@kernel.org
Content-Type: multipart/mixed; boundary=000e0cd47cecf1cd8904a90c158a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd47cecf1cd8904a90c158a
Content-Type: text/plain; charset=ISO-8859-1

The generic atomic bitops currently explicitly cast away the
volatile from the pointer passed to them. This will allow the
access to the bitfield to happen outside of the critical section
thus making the bitops no longer interrupt-safe. Remove this cast
and add a volatile keyword to make sure all accesses to the
bitfield happen inside the critical section.

Signed-off-by: Will Newton <will.newton@imgtec.com>
---
 include/asm-generic/bitops/atomic.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/bitops/atomic.h
b/include/asm-generic/bitops/atomic.h
index ecc44a8..57e4b1f 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -65,7 +65,7 @@ extern arch_spinlock_t
__atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
 static inline void set_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	volatile unsigned long *p = addr + BIT_WORD(nr);
 	unsigned long flags;

 	_atomic_spin_lock_irqsave(p, flags);
@@ -86,7 +86,7 @@ static inline void set_bit(int nr, volatile unsigned
long *addr)
 static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	volatile unsigned long *p = addr + BIT_WORD(nr);
 	unsigned long flags;

 	_atomic_spin_lock_irqsave(p, flags);
@@ -107,7 +107,7 @@ static inline void clear_bit(int nr, volatile
unsigned long *addr)
 static inline void change_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	volatile unsigned long *p = addr + BIT_WORD(nr);
 	unsigned long flags;

 	_atomic_spin_lock_irqsave(p, flags);
@@ -127,7 +127,7 @@ static inline void change_bit(int nr, volatile
unsigned long *addr)
 static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	volatile unsigned long *p = addr + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;

@@ -151,7 +151,7 @@ static inline int test_and_set_bit(int nr,
volatile unsigned long *addr)
 static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	volatile unsigned long *p = addr + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;

@@ -174,7 +174,7 @@ static inline int test_and_clear_bit(int nr,
volatile unsigned long *addr)
 static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	volatile unsigned long *p = addr + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;

-- 
1.7.3.4

--000e0cd47cecf1cd8904a90c158a
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-bitops-Use-volatile-in-generic-atomic-bitops.patch"
Content-Disposition: attachment; 
	filename="0001-bitops-Use-volatile-in-generic-atomic-bitops.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqm67bl20

RnJvbSA2MmZmMTMwMjM1MGQ4OGZjZTFmN2MzMDcyNzA0NmFlYTI2OGZkOTg5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogV2VkLCAyNyBKdWwgMjAxMSAxMTo0MDoyOSArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIGJp
dG9wczogVXNlIHZvbGF0aWxlIGluIGdlbmVyaWMgYXRvbWljIGJpdG9wcy4KClRoZSBnZW5lcmlj
IGF0b21pYyBiaXRvcHMgY3VycmVudGx5IGV4cGxpY2l0bHkgY2FzdCBhd2F5IHRoZQp2b2xhdGls
ZSBmcm9tIHRoZSBwb2ludGVyIHBhc3NlZCB0byB0aGVtLiBUaGlzIHdpbGwgYWxsb3cgdGhlCmFj
Y2VzcyB0byB0aGUgYml0ZmllbGQgdG8gaGFwcGVuIG91dHNpZGUgb2YgdGhlIGNyaXRpY2FsIHNl
Y3Rpb24KdGh1cyBtYWtpbmcgdGhlIGJpdG9wcyBubyBsb25nZXIgaW50ZXJydXB0LXNhZmUuIFJl
bW92ZSB0aGlzIGNhc3QKYW5kIGFkZCBhIHZvbGF0aWxlIGtleXdvcmQgdG8gbWFrZSBzdXJlIGFs
bCBhY2Nlc3NlcyB0byB0aGUKYml0ZmllbGQgaGFwcGVuIGluc2lkZSB0aGUgY3JpdGljYWwgc2Vj
dGlvbi4KClNpZ25lZC1vZmYtYnk6IFdpbGwgTmV3dG9uIDx3aWxsLm5ld3RvbkBpbWd0ZWMuY29t
PgotLS0KIGluY2x1ZGUvYXNtLWdlbmVyaWMvYml0b3BzL2F0b21pYy5oIHwgICAxMiArKysrKyst
LS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLWdlbmVyaWMvYml0b3BzL2F0b21pYy5oIGIvaW5jbHVk
ZS9hc20tZ2VuZXJpYy9iaXRvcHMvYXRvbWljLmgKaW5kZXggZWNjNDRhOC4uNTdlNGIxZiAxMDA2
NDQKLS0tIGEvaW5jbHVkZS9hc20tZ2VuZXJpYy9iaXRvcHMvYXRvbWljLmgKKysrIGIvaW5jbHVk
ZS9hc20tZ2VuZXJpYy9iaXRvcHMvYXRvbWljLmgKQEAgLTY1LDcgKzY1LDcgQEAgZXh0ZXJuIGFy
Y2hfc3BpbmxvY2tfdCBfX2F0b21pY19oYXNoW0FUT01JQ19IQVNIX1NJWkVdIF9fbG9ja19hbGln
bmVkOwogc3RhdGljIGlubGluZSB2b2lkIHNldF9iaXQoaW50IG5yLCB2b2xhdGlsZSB1bnNpZ25l
ZCBsb25nICphZGRyKQogewogCXVuc2lnbmVkIGxvbmcgbWFzayA9IEJJVF9NQVNLKG5yKTsKLQl1
bnNpZ25lZCBsb25nICpwID0gKCh1bnNpZ25lZCBsb25nICopYWRkcikgKyBCSVRfV09SRChucik7
CisJdm9sYXRpbGUgdW5zaWduZWQgbG9uZyAqcCA9IGFkZHIgKyBCSVRfV09SRChucik7CiAJdW5z
aWduZWQgbG9uZyBmbGFnczsKIAogCV9hdG9taWNfc3Bpbl9sb2NrX2lycXNhdmUocCwgZmxhZ3Mp
OwpAQCAtODYsNyArODYsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgc2V0X2JpdChpbnQgbnIsIHZv
bGF0aWxlIHVuc2lnbmVkIGxvbmcgKmFkZHIpCiBzdGF0aWMgaW5saW5lIHZvaWQgY2xlYXJfYml0
KGludCBuciwgdm9sYXRpbGUgdW5zaWduZWQgbG9uZyAqYWRkcikKIHsKIAl1bnNpZ25lZCBsb25n
IG1hc2sgPSBCSVRfTUFTSyhucik7Ci0JdW5zaWduZWQgbG9uZyAqcCA9ICgodW5zaWduZWQgbG9u
ZyAqKWFkZHIpICsgQklUX1dPUkQobnIpOworCXZvbGF0aWxlIHVuc2lnbmVkIGxvbmcgKnAgPSBh
ZGRyICsgQklUX1dPUkQobnIpOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAKIAlfYXRvbWljX3Nw
aW5fbG9ja19pcnFzYXZlKHAsIGZsYWdzKTsKQEAgLTEwNyw3ICsxMDcsNyBAQCBzdGF0aWMgaW5s
aW5lIHZvaWQgY2xlYXJfYml0KGludCBuciwgdm9sYXRpbGUgdW5zaWduZWQgbG9uZyAqYWRkcikK
IHN0YXRpYyBpbmxpbmUgdm9pZCBjaGFuZ2VfYml0KGludCBuciwgdm9sYXRpbGUgdW5zaWduZWQg
bG9uZyAqYWRkcikKIHsKIAl1bnNpZ25lZCBsb25nIG1hc2sgPSBCSVRfTUFTSyhucik7Ci0JdW5z
aWduZWQgbG9uZyAqcCA9ICgodW5zaWduZWQgbG9uZyAqKWFkZHIpICsgQklUX1dPUkQobnIpOwor
CXZvbGF0aWxlIHVuc2lnbmVkIGxvbmcgKnAgPSBhZGRyICsgQklUX1dPUkQobnIpOwogCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7CiAKIAlfYXRvbWljX3NwaW5fbG9ja19pcnFzYXZlKHAsIGZsYWdzKTsK
QEAgLTEyNyw3ICsxMjcsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgY2hhbmdlX2JpdChpbnQgbnIs
IHZvbGF0aWxlIHVuc2lnbmVkIGxvbmcgKmFkZHIpCiBzdGF0aWMgaW5saW5lIGludCB0ZXN0X2Fu
ZF9zZXRfYml0KGludCBuciwgdm9sYXRpbGUgdW5zaWduZWQgbG9uZyAqYWRkcikKIHsKIAl1bnNp
Z25lZCBsb25nIG1hc2sgPSBCSVRfTUFTSyhucik7Ci0JdW5zaWduZWQgbG9uZyAqcCA9ICgodW5z
aWduZWQgbG9uZyAqKWFkZHIpICsgQklUX1dPUkQobnIpOworCXZvbGF0aWxlIHVuc2lnbmVkIGxv
bmcgKnAgPSBhZGRyICsgQklUX1dPUkQobnIpOwogCXVuc2lnbmVkIGxvbmcgb2xkOwogCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7CiAKQEAgLTE1MSw3ICsxNTEsNyBAQCBzdGF0aWMgaW5saW5lIGludCB0
ZXN0X2FuZF9zZXRfYml0KGludCBuciwgdm9sYXRpbGUgdW5zaWduZWQgbG9uZyAqYWRkcikKIHN0
YXRpYyBpbmxpbmUgaW50IHRlc3RfYW5kX2NsZWFyX2JpdChpbnQgbnIsIHZvbGF0aWxlIHVuc2ln
bmVkIGxvbmcgKmFkZHIpCiB7CiAJdW5zaWduZWQgbG9uZyBtYXNrID0gQklUX01BU0sobnIpOwot
CXVuc2lnbmVkIGxvbmcgKnAgPSAoKHVuc2lnbmVkIGxvbmcgKilhZGRyKSArIEJJVF9XT1JEKG5y
KTsKKwl2b2xhdGlsZSB1bnNpZ25lZCBsb25nICpwID0gYWRkciArIEJJVF9XT1JEKG5yKTsKIAl1
bnNpZ25lZCBsb25nIG9sZDsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCkBAIC0xNzQsNyArMTc0
LDcgQEAgc3RhdGljIGlubGluZSBpbnQgdGVzdF9hbmRfY2xlYXJfYml0KGludCBuciwgdm9sYXRp
bGUgdW5zaWduZWQgbG9uZyAqYWRkcikKIHN0YXRpYyBpbmxpbmUgaW50IHRlc3RfYW5kX2NoYW5n
ZV9iaXQoaW50IG5yLCB2b2xhdGlsZSB1bnNpZ25lZCBsb25nICphZGRyKQogewogCXVuc2lnbmVk
IGxvbmcgbWFzayA9IEJJVF9NQVNLKG5yKTsKLQl1bnNpZ25lZCBsb25nICpwID0gKCh1bnNpZ25l
ZCBsb25nICopYWRkcikgKyBCSVRfV09SRChucik7CisJdm9sYXRpbGUgdW5zaWduZWQgbG9uZyAq
cCA9IGFkZHIgKyBCSVRfV09SRChucik7CiAJdW5zaWduZWQgbG9uZyBvbGQ7CiAJdW5zaWduZWQg
bG9uZyBmbGFnczsKIAotLSAKMS43LjMuNAoK
--000e0cd47cecf1cd8904a90c158a--
