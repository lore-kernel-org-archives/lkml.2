Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab2KMDbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:31:47 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48227 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2KMDbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:31:46 -0500
MIME-Version: 1.0
Date: Tue, 13 Nov 2012 11:31:45 +0800
Message-ID: <CABawtvMsrMhGL7emsvYRXrGEB9f2Pzha2+XTVSHaYw1PVJGa-Q@mail.gmail.com>
Subject: [PATCH ] tbfadt.c: output warning only when 64bit 32bit address of
 FACS/DSDT all have value but not equal to each other
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Len Brown <len.brown@intel.com>
Cc: robert.moore@intel.com, lv.zheng@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d0447f21aae332f04ce580e3c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0447f21aae332f04ce580e3c
Content-Type: text/plain; charset=ISO-8859-1

Hi, Len, Robert,

       Please help to check the following patch, add more conditions
when validate the 64bit 32bit FACS/DSDT address in FADT to follow ACPI
spec, In the meantime, keep the compatibility and latitude.


Thanks,
Ethan



>From c1116211a7b329c26b0370565c36b084ceb08f71 Mon Sep 17 00:00:00 2001
From: ethan.zhao <ethan.kernel@gmail.com>
Date: Tue, 13 Nov 2012 22:21:12 -0800
Subject: [PATCH 642/642] To follow the ACPI spec 3,4&5 and keep the
compatibility and latitude,only
 output mismatch warning when 64bit address and 32bit address of
FACS/DSDT are all
 valid but not equal to each other.


Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/acpi/acpica/tbfadt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 3906518..f23f512 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -512,7 +512,7 @@ static void acpi_tb_validate_fadt(void)
         * the 32-bit and 64-bit address fields
(FIRMWARE_CTRL/X_FIRMWARE_CTRL and
         * DSDT/X_DSDT) would indicate the presence of two FACS or two
DSDT tables.
         */
-       if (acpi_gbl_FADT.facs &&
+       if ((acpi_gbl_FADT.facs && acpi_gbl_FADT.Xfacs) &&
            (acpi_gbl_FADT.Xfacs != (u64)acpi_gbl_FADT.facs)) {
                ACPI_BIOS_WARNING((AE_INFO,
                                   "32/64X FACS address mismatch in FADT - "
@@ -523,7 +523,7 @@ static void acpi_tb_validate_fadt(void)
                acpi_gbl_FADT.Xfacs = (u64)acpi_gbl_FADT.facs;
        }

-       if (acpi_gbl_FADT.dsdt &&
+       if ((acpi_gbl_FADT.dsdt && acpi_gbl_FADT.Xdsdt) &&
            (acpi_gbl_FADT.Xdsdt != (u64)acpi_gbl_FADT.dsdt)) {
                ACPI_BIOS_WARNING((AE_INFO,
                                   "32/64X DSDT address mismatch in FADT - "
--
1.7.1

--f46d0447f21aae332f04ce580e3c
Content-Type: application/octet-stream; 
	name="To-follow-the-ACPI-spec-3-4-5-and-keep-the-compatibi.patch"
Content-Disposition: attachment; 
	filename="To-follow-the-ACPI-spec-3-4-5-and-keep-the-compatibi.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h9ggndbr0

RnJvbSBjMTExNjIxMWE3YjMyOWMyNmIwMzcwNTY1YzM2YjA4NGNlYjA4ZjcxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBldGhhbi56aGFvIDxldGhhbi5rZXJuZWxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDEzIE5vdiAyMDEyIDIyOjIxOjEyIC0wODAwClN1YmplY3Q6IFtQQVRDSCA2NDIv
NjQyXSBUbyBmb2xsb3cgdGhlIEFDUEkgc3BlYyAzLDQmNSBhbmQga2VlcCB0aGUgY29tcGF0aWJp
bGl0eSBhbmQgbGF0aXR1ZGUsb25seQogb3V0cHV0IG1pc21hdGNoIHdhcm5pbmcgd2hlbiA2NGJp
dCBhZGRyZXNzIGFuZCAzMmJpdCBhZGRyZXNzIG9mIEZBQ1MvRFNEVCBhcmUgYWxsCiB2YWxpZCBi
dXQgbm90IGVxdWFsIHRvIGVhY2ggb3RoZXIuCgoKU2lnbmVkLW9mZi1ieTogZXRoYW4uemhhbyA8
ZXRoYW4ua2VybmVsQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2FjcGkvYWNwaWNhL3RiZmFkdC5j
IHwgICAgNCArKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvYWNwaWNhL3RiZmFkdC5jIGIvZHJpdmVy
cy9hY3BpL2FjcGljYS90YmZhZHQuYwppbmRleCAzOTA2NTE4Li5mMjNmNTEyIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2FjcGkvYWNwaWNhL3RiZmFkdC5jCisrKyBiL2RyaXZlcnMvYWNwaS9hY3BpY2Ev
dGJmYWR0LmMKQEAgLTUxMiw3ICs1MTIsNyBAQCBzdGF0aWMgdm9pZCBhY3BpX3RiX3ZhbGlkYXRl
X2ZhZHQodm9pZCkKIAkgKiB0aGUgMzItYml0IGFuZCA2NC1iaXQgYWRkcmVzcyBmaWVsZHMgKEZJ
Uk1XQVJFX0NUUkwvWF9GSVJNV0FSRV9DVFJMIGFuZAogCSAqIERTRFQvWF9EU0RUKSB3b3VsZCBp
bmRpY2F0ZSB0aGUgcHJlc2VuY2Ugb2YgdHdvIEZBQ1Mgb3IgdHdvIERTRFQgdGFibGVzLgogCSAq
LwotCWlmIChhY3BpX2dibF9GQURULmZhY3MgJiYKKwlpZiAoKGFjcGlfZ2JsX0ZBRFQuZmFjcyAm
JiBhY3BpX2dibF9GQURULlhmYWNzKSAmJgogCSAgICAoYWNwaV9nYmxfRkFEVC5YZmFjcyAhPSAo
dTY0KWFjcGlfZ2JsX0ZBRFQuZmFjcykpIHsKIAkJQUNQSV9CSU9TX1dBUk5JTkcoKEFFX0lORk8s
CiAJCQkJICAgIjMyLzY0WCBGQUNTIGFkZHJlc3MgbWlzbWF0Y2ggaW4gRkFEVCAtICIKQEAgLTUy
Myw3ICs1MjMsNyBAQCBzdGF0aWMgdm9pZCBhY3BpX3RiX3ZhbGlkYXRlX2ZhZHQodm9pZCkKIAkJ
YWNwaV9nYmxfRkFEVC5YZmFjcyA9ICh1NjQpYWNwaV9nYmxfRkFEVC5mYWNzOwogCX0KIAotCWlm
IChhY3BpX2dibF9GQURULmRzZHQgJiYKKwlpZiAoKGFjcGlfZ2JsX0ZBRFQuZHNkdCAmJiBhY3Bp
X2dibF9GQURULlhkc2R0KSAmJgogCSAgICAoYWNwaV9nYmxfRkFEVC5YZHNkdCAhPSAodTY0KWFj
cGlfZ2JsX0ZBRFQuZHNkdCkpIHsKIAkJQUNQSV9CSU9TX1dBUk5JTkcoKEFFX0lORk8sCiAJCQkJ
ICAgIjMyLzY0WCBEU0RUIGFkZHJlc3MgbWlzbWF0Y2ggaW4gRkFEVCAtICIKLS0gCjEuNy4xCgo=
--f46d0447f21aae332f04ce580e3c--
