Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0ICCfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:35:25 -0400
Received: from claw.goop.org ([74.207.240.146]:54431 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab0ICCfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:35:24 -0400
Message-ID: <4C805EEA.1080205@goop.org>
Date: Thu, 02 Sep 2010 19:35:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: add RESERVE_BRK_ARRAY() helper
Content-Type: multipart/mixed;
 boundary="------------070207080705080002020503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070207080705080002020503
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



Useful when converting static arrays into boot-time brk allocated objects.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 4093d1e..632cafd 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -126,6 +126,11 @@ void *extend_brk(size_t size, size_t align);
 			: : "i" (sz));					\
 	}
 
+/* Helper for reserving space for arrays of things */
+#define RESERVE_BRK_ARRAY(type, name, entries)		\
+	type *name;					\
+	RESERVE_BRK(name, sizeof(type) * entries)
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);



--------------070207080705080002020503
Content-Type: text/plain;
 name="x86-brk-array.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="x86-brk-array.patch"

RnJvbSA5MDBkOTc3ZTZjZTAwNGM1OWI5ODZhNDk0ODM4ZGFkZGVjYmUxMDZhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0
emhhcmRpbmdlQGNpdHJpeC5jb20+CkRhdGU6IFRodSwgMjYgQXVnIDIwMTAgMTU6MzE6MzYg
LTA3MDAKU3ViamVjdDogW1BBVENIXSB4ODY6IGFkZCBSRVNFUlZFX0JSS19BUlJBWSgpIGhl
bHBlcgoKVXNlZnVsIHdoZW4gY29udmVydGluZyBzdGF0aWMgYXJyYXlzIGludG8gYm9vdHRp
bWUgYnJrIGFsbG9jYXRlZCBvYmplY3RzLgoKU2lnbmVkLW9mZi1ieTogSmVyZW15IEZpdHpo
YXJkaW5nZSA8amVyZW15LmZpdHpoYXJkaW5nZUBjaXRyaXguY29tPgoKZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3NldHVwLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9z
ZXR1cC5oCmluZGV4IDQwOTNkMWUuLjYzMmNhZmQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3NldHVwLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc2V0dXAuaApA
QCAtMTI2LDYgKzEyNiwxMSBAQCB2b2lkICpleHRlbmRfYnJrKHNpemVfdCBzaXplLCBzaXpl
X3QgYWxpZ24pOwogCQkJOiA6ICJpIiAoc3opKTsJCQkJCVwKIAl9CiAKKy8qIEhlbHBlciBm
b3IgcmVzZXJ2aW5nIHNwYWNlIGZvciBhcnJheXMgb2YgdGhpbmdzICovCisjZGVmaW5lIFJF
U0VSVkVfQlJLX0FSUkFZKHR5cGUsIG5hbWUsIGVudHJpZXMpCQlcCisJdHlwZSAqbmFtZTsJ
CQkJCVwKKwlSRVNFUlZFX0JSSyhuYW1lLCBzaXplb2YodHlwZSkgKiBlbnRyaWVzKQorCiAj
aWZkZWYgX19pMzg2X18KIAogdm9pZCBfX2luaXQgaTM4Nl9zdGFydF9rZXJuZWwodm9pZCk7
Cg==
--------------070207080705080002020503--
