Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0KMRoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 12:44:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42073 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab0KMRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 12:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZTKit+6SRD6QZBvhyEd7o5JtcC5ux+u0m6Sd+zB9nWus3NyE/DxBzTO75Fx/AstngS
         sfIAwF0jKX4FEvwJbuQKxvqcKD42l/HKpgJlLKgjb300ShaxF9m0k6jiNhgOO3SnTKHB
         4KVjIY7VQfgN7nP4KHaX/6v9i1s+TyiRaZAkw=
MIME-Version: 1.0
Date: Sat, 13 Nov 2010 17:44:28 +0000
Message-ID: <AANLkTi=xJb1LcGXeCcd_tJ+Q9vV5W4z3M-up_mrKeV9q@mail.gmail.com>
Subject: [PATCH 1/2] uml: Safely iterate list of winch handlers in line driver.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>
Content-Type: multipart/mixed; boundary=001485f6cd7e40e8300494f2c283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485f6cd7e40e8300494f2c283
Content-Type: text/plain; charset=ISO-8859-1

unregister_winch should use list_for_each_safe, as it can
potentially delete from the list.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 arch/um/drivers/line.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 7f7338c..5f12fef 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -820,12 +820,12 @@ void register_winch_irq(int fd, int tty_fd, int
pid, struct tty_struct *tty,

 static void unregister_winch(struct tty_struct *tty)
 {
-	struct list_head *ele;
+	struct list_head *ele, *next;
 	struct winch *winch;

 	spin_lock(&winch_handler_lock);

-	list_for_each(ele, &winch_handlers) {
+	list_for_each_safe(ele, next, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
 		if (winch->tty == tty) {
 			free_winch(winch, 1);
-- 
1.7.0.4

--001485f6cd7e40e8300494f2c283
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-uml-Safely-iterate-list-of-winch-handlers-in-line-dr.patch"
Content-Disposition: attachment; 
	filename="0001-uml-Safely-iterate-list-of-winch-handlers-in-line-dr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gggsbuvi0

RnJvbSBlNTc5ZWI1ODM1YTA3MzAxNzczODg1NDU1MjBmMjFkOWZiYzBkZTFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBTYXQsIDEzIE5vdiAyMDEwIDE2OjMwOjU4ICswMDAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IHVtbDogU2FmZWx5IGl0ZXJhdGUgbGlzdCBvZiB3aW5jaCBoYW5kbGVycyBpbiBsaW5lIGRyaXZl
ci4KCnVucmVnaXN0ZXJfd2luY2ggc2hvdWxkIHVzZSBsaXN0X2Zvcl9lYWNoX3NhZmUsIGFzIGl0
IGNhbgpwb3RlbnRpYWxseSBkZWxldGUgZnJvbSB0aGUgbGlzdC4KClNpZ25lZC1vZmYtYnk6IFdp
bGwgTmV3dG9uIDx3aWxsLm5ld3RvbkBnbWFpbC5jb20+Ci0tLQogYXJjaC91bS9kcml2ZXJzL2xp
bmUuYyB8ICAgIDQgKystLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC91bS9kcml2ZXJzL2xpbmUuYyBiL2FyY2gvdW0v
ZHJpdmVycy9saW5lLmMKaW5kZXggN2Y3MzM4Yy4uNWYxMmZlZiAxMDA2NDQKLS0tIGEvYXJjaC91
bS9kcml2ZXJzL2xpbmUuYworKysgYi9hcmNoL3VtL2RyaXZlcnMvbGluZS5jCkBAIC04MjAsMTIg
KzgyMCwxMiBAQCB2b2lkIHJlZ2lzdGVyX3dpbmNoX2lycShpbnQgZmQsIGludCB0dHlfZmQsIGlu
dCBwaWQsIHN0cnVjdCB0dHlfc3RydWN0ICp0dHksCiAKIHN0YXRpYyB2b2lkIHVucmVnaXN0ZXJf
d2luY2goc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSkKIHsKLQlzdHJ1Y3QgbGlzdF9oZWFkICplbGU7
CisJc3RydWN0IGxpc3RfaGVhZCAqZWxlLCAqbmV4dDsKIAlzdHJ1Y3Qgd2luY2ggKndpbmNoOwog
CiAJc3Bpbl9sb2NrKCZ3aW5jaF9oYW5kbGVyX2xvY2spOwogCi0JbGlzdF9mb3JfZWFjaChlbGUs
ICZ3aW5jaF9oYW5kbGVycykgeworCWxpc3RfZm9yX2VhY2hfc2FmZShlbGUsIG5leHQsICZ3aW5j
aF9oYW5kbGVycykgewogCQl3aW5jaCA9IGxpc3RfZW50cnkoZWxlLCBzdHJ1Y3Qgd2luY2gsIGxp
c3QpOwogCQlpZiAod2luY2gtPnR0eSA9PSB0dHkpIHsKIAkJCWZyZWVfd2luY2god2luY2gsIDEp
OwotLSAKMS43LjAuNAoK
--001485f6cd7e40e8300494f2c283--
