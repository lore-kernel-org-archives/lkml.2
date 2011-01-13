Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1AMIcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 03:32:12 -0500
Received: from outer.eatpbank.ru ([91.202.252.240]:59278 "EHLO
	outer.eatpbank.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1AMIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 03:32:08 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 03:32:07 EST
Content-Type: multipart/mixed; boundary=----------YSAAQsd5P9OieRrZbVOi2n
Subject: JSM module patch
References: <op.vo8g42gfgaomyf@pepper.eatpbank.ru>
Date: Thu, 13 Jan 2011 11:32:05 +0300
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
MIME-Version: 1.0
From: =?koi8-r?B?8MHTwdvOycvP1yDhLuEu?= <pepper@eatpbank.ru>
Organization: EATPBank
Message-ID: <op.vo8nbrx3gaomyf@pepper.eatpbank.ru>
In-Reply-To: <op.vo8g42gfgaomyf@pepper.eatpbank.ru>
User-Agent: Opera Mail/11.00 (Linux)
X-Spam_score: -2.9
X-Spam_score_int: -28
X-Spam_bar: --
X-Spam_report: Spam detection software, running on the system "outer.eatpbank.ru", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  Hello We use the OS Debian Squeeze kernel 2.6.32-5-686. There
    is a problem: We have an internal PCI card Digi Neo 4 with device ID 114F:00B0
    (has 4 COM-ports). Core module JSM doesn't support device described above,
    but support the same device with 8 COM-port and device ID 114F:00B1. Can
   you include this patches: [...] 
 Content analysis details:   (-2.9 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------YSAAQsd5P9OieRrZbVOi2n
Content-Type: text/plain; charset=koi8-r; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

Hello

We use the OS Debian Squeeze kernel 2.6.32-5-686.
There is a problem:
We have an internal PCI card Digi Neo 4 with device ID 114F:00B0 (has 4
COM-ports).
Core module JSM doesn't support device described above, but support the
same device with 8 COM-port and device ID 114F:00B1.
Can you include this patches:

linux-2.6-2.6.32/include/linux/pci_ids.h
	--- pci_ids.h	2009-12-03 06:51:21.000000000 +0300
	+++ pci_ids.h	2011-01-11 14:07:32.000000000 +0300
	@@ -1460,6 +1464,7 @@
	 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
	 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_A	0x0072
	 #define PCI_DEVICE_ID_DIGI_DF_M_A	0x0073
	+#define PCI_DEVICE_ID_DIGI_NEO_4	0x00B0
	 #define PCI_DEVICE_ID_DIGI_NEO_8	0x00B1
	 #define PCI_DEVICE_ID_NEO_2DB9          0x00C8
	 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9

linux-source-2.6.32/drivers/serial/jsm/jsm_driver.c
	--- jsm_driver.c	2009-12-03 06:51:21.000000000 +0300
	+++ jsm_driver.c	2011-01-11 16:50:57.000000000 +0300
	@@ -81,7 +81,7 @@
    			/* store the info for the board we've found */
    			brd->boardnum = adapter_count++;
	 	brd->pci_dev = pdev;
	-	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
	+	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM || pdev->device ==
PCI_DEVICE_ID_DIGI_NEO_4)
	 		brd->maxports = 4;
	 	else if (pdev->device == PCI_DEVICE_ID_DIGI_NEO_8)
	 		brd->maxports = 8;
	@@ -213,6 +213,7 @@
	 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0, 0, 3 },
	 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0, 0, 4 },
	 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_8), 0, 0, 5 },
	+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_4), 0, 0, 6 },
	 	{ 0, }
	 };
	 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);

to the source?

same diff`s attached.

Best regards
Andrey Pasashnikov
Astrakhan
Russia
------------YSAAQsd5P9OieRrZbVOi2n
Content-Disposition: attachment; filename=pci_ids.diff
Content-Type: application/octet-stream; name=pci_ids.diff
Content-Transfer-Encoding: Base64

LS0tIC91c3Ivc3JjL2xpbnV4LTIuNi0yLjYuMzIvaW5jbHVkZS9saW51eC9wY2lf
aWRzLmgJMjAwOS0xMi0wMyAwNjo1MToyMS4wMDAwMDAwMDAgKzAzMDAKKysrIHBj
aV9pZHMuaAkyMDExLTAxLTExIDE0OjA3OjMyLjAwMDAwMDAwMCArMDMwMApAQCAt
MTQ2MCw2ICsxNDY0LDcgQEAKICNkZWZpbmUgUENJX0RFVklDRV9JRF9ESUdJX0RG
X01fRQkweDAwNzEKICNkZWZpbmUgUENJX0RFVklDRV9JRF9ESUdJX0RGX01fSU9N
Ml9BCTB4MDA3MgogI2RlZmluZSBQQ0lfREVWSUNFX0lEX0RJR0lfREZfTV9BCTB4
MDA3MworI2RlZmluZSBQQ0lfREVWSUNFX0lEX0RJR0lfTkVPXzQJMHgwMEIwCiAj
ZGVmaW5lIFBDSV9ERVZJQ0VfSURfRElHSV9ORU9fOAkweDAwQjEKICNkZWZpbmUg
UENJX0RFVklDRV9JRF9ORU9fMkRCOSAgICAgICAgICAweDAwQzgKICNkZWZpbmUg
UENJX0RFVklDRV9JRF9ORU9fMkRCOVBSSSAgICAgICAweDAwQzkK

------------YSAAQsd5P9OieRrZbVOi2n
Content-Disposition: attachment; filename=jsm_driver.diff
Content-Type: application/octet-stream; name=jsm_driver.diff
Content-Transfer-Encoding: Base64

LS0tIGpzbV9kcml2ZXIuYwkyMDA5LTEyLTAzIDA2OjUxOjIxLjAwMDAwMDAwMCAr
MDMwMAorKysgL3Vzci9zcmMvbGludXgtc291cmNlLTIuNi4zMi9kcml2ZXJzL3Nl
cmlhbC9qc20vanNtX2RyaXZlci5jCTIwMTEtMDEtMTEgMTY6NTA6NTcuMDAwMDAw
MDAwICswMzAwCkBAIC04MSw3ICs4MSw3IEBACiAJLyogc3RvcmUgdGhlIGluZm8g
Zm9yIHRoZSBib2FyZCB3ZSd2ZSBmb3VuZCAqLwogCWJyZC0+Ym9hcmRudW0gPSBh
ZGFwdGVyX2NvdW50Kys7CiAJYnJkLT5wY2lfZGV2ID0gcGRldjsKLQlpZiAocGRl
di0+ZGV2aWNlID09IFBDSUVfREVWSUNFX0lEX05FT180X0lCTSkKKwlpZiAocGRl
di0+ZGV2aWNlID09IFBDSUVfREVWSUNFX0lEX05FT180X0lCTSB8fCBwZGV2LT5k
ZXZpY2UgPT0gUENJX0RFVklDRV9JRF9ESUdJX05FT180KQogCQlicmQtPm1heHBv
cnRzID0gNDsKIAllbHNlIGlmIChwZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9J
RF9ESUdJX05FT184KQogCQlicmQtPm1heHBvcnRzID0gODsKQEAgLTIxMyw2ICsy
MTMsNyBAQAogCXsgUENJX0RFVklDRShQQ0lfVkVORE9SX0lEX0RJR0ksIFBDSV9E
RVZJQ0VfSURfTkVPXzJSSjQ1UFJJKSwgMCwgMCwgMyB9LAogCXsgUENJX0RFVklD
RShQQ0lfVkVORE9SX0lEX0RJR0ksIFBDSUVfREVWSUNFX0lEX05FT180X0lCTSks
IDAsIDAsIDQgfSwKIAl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9ESUdJLCBQ
Q0lfREVWSUNFX0lEX0RJR0lfTkVPXzgpLCAwLCAwLCA1IH0sCisJeyBQQ0lfREVW
SUNFKFBDSV9WRU5ET1JfSURfRElHSSwgUENJX0RFVklDRV9JRF9ESUdJX05FT180
KSwgMCwgMCwgNiB9LAogCXsgMCwgfQogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUo
cGNpLCBqc21fcGNpX3RibCk7Cg==

------------YSAAQsd5P9OieRrZbVOi2n--

