Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1ELGyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:54:39 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47869 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1ELGyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oBlTl/b5JFQ/Q0LvX8MTkgHlbFPZai4WU/M0LNKtS9rAF6iS03b4ZNX3fVFhofO7wk
         cBnLWBRiZRQPeFnjNYUe9F9hcjNJE/HGnPdKXL3lg3K/nCYHQj4g8auCFcI9VseLI09p
         O3dVQJgALdK62XfimAht9vlIUeucrlH+Z2HCE=
MIME-Version: 1.0
In-Reply-To: <20110511183322.da0739c9.akpm@linux-foundation.org>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
	<20110511183322.da0739c9.akpm@linux-foundation.org>
Date: Thu, 12 May 2011 01:54:37 -0500
Message-ID: <BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
Subject: Re: Bug in MTD NAND ONFI chipsize detection
From: Nitin Garg <nitingarg98@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Content-Type: multipart/mixed; boundary=001e680f0fa89b90ba04a30ea9d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f0fa89b90ba04a30ea9d4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Here is the tested patch, pls apply.

Regards,
Nitin Garg

>From 1a73f1c3d066a491d0c806883788ab9abdc736f3 Mon Sep 17 00:00:00 2001
From: Nitin Garg <nitingarg98@gmail.com>
Date: Thu, 12 May 2011 01:31:53 -0500
Subject: [PATCH] Fix ONFI NAND flash size detection by using number of
Logical Units in device


Signed-off-by: Nitin Garg <nitingarg98@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index c54a4cb..cdf6015 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2892,7 +2892,7 @@ static int nand_flash_detect_onfi(struct
mtd_info *mtd, struct nand_chip *chip,
 	mtd->writesize =3D le32_to_cpu(p->byte_per_page);
 	mtd->erasesize =3D le32_to_cpu(p->pages_per_block) * mtd->writesize;
 	mtd->oobsize =3D le16_to_cpu(p->spare_bytes_per_page);
-	chip->chipsize =3D (uint64_t)le32_to_cpu(p->blocks_per_lun) * mtd->erases=
ize;
+	chip->chipsize =3D (uint64_t)le32_to_cpu(p->blocks_per_lun) *
le32_to_cpu(p->lun_count) * mtd->erasesize;
 	busw =3D 0;
 	if (le16_to_cpu(p->features) & 1)
 		busw =3D NAND_BUSWIDTH_16;
--=20
1.5.5.6



On Wed, May 11, 2011 at 8:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 May 2011 11:25:22 -0500 Nitin Garg <nitingarg98@gmail.com> wro=
te:
>
>> Hi All,
>>
>> The nand_flash_detect_onfi function in mtd/nand detects the NAND flash
>> device size using the ONFI parameters:
>> =A0 =A0 =A0 chip->chipsize =3D (uint64_t)le32_to_cpu(p->blocks_per_lun) =
* mtd->erasesize;
>>
>> The lun_count is not taken into consideration due to which we detect
>> wrong size for Micron MT29F8G08ADADAH4 as it has 2 logical units.
>>
>> We should change the chipsize calculation to:
>> =A0 =A0 =A0 chip->chipsize =3D (uint64_t)le32_to_cpu(p->blocks_per_lun) =
*
>> (uint64_t)le32_to_cpu(p->lun_count) * mtd->erasesize;
>>
>> Pls suggest.
>>
>
> Please send a tested, changelogged patch to fix it. =A0Be sure to cc the
> relevant maintainer and mailing list.
>
> Thanks.
>

--001e680f0fa89b90ba04a30ea9d4
Content-Type: application/octet-stream; 
	name="0001-Fix-ONFI-NAND-flash-size-detection-by-using-number-o.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-ONFI-NAND-flash-size-detection-by-using-number-o.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnlcek4j0

RnJvbSAxYTczZjFjM2QwNjZhNDkxZDBjODA2ODgzNzg4YWI5YWJkYzczNmYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaXRpbiBHYXJnIDxuaXRpbmdhcmc5OEBnbWFpbC5jb20+CkRh
dGU6IFRodSwgMTIgTWF5IDIwMTEgMDE6MzE6NTMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBGaXgg
T05GSSBOQU5EIGZsYXNoIHNpemUgZGV0ZWN0aW9uIGJ5IHVzaW5nIG51bWJlciBvZiBMb2dpY2Fs
IFVuaXRzIGluIGRldmljZQoKClNpZ25lZC1vZmYtYnk6IE5pdGluIEdhcmcgPG5pdGluZ2FyZzk4
QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL210ZC9uYW5kL25hbmRfYmFzZS5jIHwgICAgMiArLQog
MSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9tdGQvbmFuZC9uYW5kX2Jhc2UuYyBiL2RyaXZlcnMvbXRkL25hbmQvbmFu
ZF9iYXNlLmMKaW5kZXggYzU0YTRjYi4uY2RmNjAxNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tdGQv
bmFuZC9uYW5kX2Jhc2UuYworKysgYi9kcml2ZXJzL210ZC9uYW5kL25hbmRfYmFzZS5jCkBAIC0y
ODkyLDcgKzI4OTIsNyBAQCBzdGF0aWMgaW50IG5hbmRfZmxhc2hfZGV0ZWN0X29uZmkoc3RydWN0
IG10ZF9pbmZvICptdGQsIHN0cnVjdCBuYW5kX2NoaXAgKmNoaXAsCiAJbXRkLT53cml0ZXNpemUg
PSBsZTMyX3RvX2NwdShwLT5ieXRlX3Blcl9wYWdlKTsKIAltdGQtPmVyYXNlc2l6ZSA9IGxlMzJf
dG9fY3B1KHAtPnBhZ2VzX3Blcl9ibG9jaykgKiBtdGQtPndyaXRlc2l6ZTsKIAltdGQtPm9vYnNp
emUgPSBsZTE2X3RvX2NwdShwLT5zcGFyZV9ieXRlc19wZXJfcGFnZSk7Ci0JY2hpcC0+Y2hpcHNp
emUgPSAodWludDY0X3QpbGUzMl90b19jcHUocC0+YmxvY2tzX3Blcl9sdW4pICogbXRkLT5lcmFz
ZXNpemU7CisJY2hpcC0+Y2hpcHNpemUgPSAodWludDY0X3QpbGUzMl90b19jcHUocC0+YmxvY2tz
X3Blcl9sdW4pICogbGUzMl90b19jcHUocC0+bHVuX2NvdW50KSAqIG10ZC0+ZXJhc2VzaXplOwog
CWJ1c3cgPSAwOwogCWlmIChsZTE2X3RvX2NwdShwLT5mZWF0dXJlcykgJiAxKQogCQlidXN3ID0g
TkFORF9CVVNXSURUSF8xNjsKLS0gCjEuNS41LjYKCg==
--001e680f0fa89b90ba04a30ea9d4--
