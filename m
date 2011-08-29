Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1H2FMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:12:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42687 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1H2FMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:12:14 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.174.182]
In-Reply-To: <20110829133237.80467b5d54438ace53b324df@canb.auug.org.au>
References: <20110829133237.80467b5d54438ace53b324df@canb.auug.org.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Aug 2011 08:11:53 +0300
Message-ID: <CAK=WgbbukmB_HBmfdzt9SQhHyQBbjKYb8xPZPB-vq6Pwu9gFQA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the iommu tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joerg Roedel <joro@8bytes.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00504502ac3c1772dc04ab9df0e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502ac3c1772dc04ab9df0e7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 29, 2011 at 6:32 AM, Stephen Rothwell <sfr@canb.auug.org.au> wr=
ote:
> After merging the iommu tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/iommu/omap-iommu.c:27:24: fatal error: plat/iommu.h: No such file=
 or directory
>
> Caused by commit fcf3a6ef4a58 ("omap: iommu/iovmm: move to dedicated
> iommu folder"). =A0Presumably building of this code should be restricted =
to
> just some platforms only.

Thank you, Stephen, you're completely right of course.

Here is what we're missing (patch also attached):

>From 7a7949ca60bb0d58079b669733f9aa43015ba0f0 Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Aug 2011 07:57:44 +0300
Subject: [PATCH] iommu: omap: add Kconfig OMAP dependency

Make CONFIG_OMAP_IOMMU depend on CONFIG_ARCH_OMAP so other
allmodconfig builds won't fail.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/iommu/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 432463b..d901930 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -110,6 +110,7 @@ config INTR_REMAP
 # OMAP IOMMU support
 config OMAP_IOMMU
 	bool "OMAP IOMMU Support"
+	depends on ARCH_OMAP
 	select IOMMU_API

 config OMAP_IOVMM
--=20
1.7.4.1

--00504502ac3c1772dc04ab9df0e7
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-iommu-omap-add-Kconfig-OMAP-dependency.patch"
Content-Disposition: attachment; 
	filename="0001-iommu-omap-add-Kconfig-OMAP-dependency.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grwzpok21

RnJvbSA3YTc5NDljYTYwYmIwZDU4MDc5YjY2OTczM2Y5YWE0MzAxNWJhMGYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPaGFkIEJlbi1Db2hlbiA8b2hhZEB3aXplcnkuY29tPgpEYXRl
OiBNb24sIDI5IEF1ZyAyMDExIDA3OjU3OjQ0ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gaW9tbXU6
IG9tYXA6IGFkZCBLY29uZmlnIE9NQVAgZGVwZW5kZW5jeQoKTWFrZSBDT05GSUdfT01BUF9JT01N
VSBkZXBlbmQgb24gQ09ORklHX0FSQ0hfT01BUCBzbyBvdGhlcgphbGxtb2Rjb25maWcgYnVpbGRz
IHdvbid0IGZhaWwuCgpSZXBvcnRlZC1ieTogU3RlcGhlbiBSb3Rod2VsbCA8c2ZyQGNhbmIuYXV1
Zy5vcmcuYXU+ClNpZ25lZC1vZmYtYnk6IE9oYWQgQmVuLUNvaGVuIDxvaGFkQHdpemVyeS5jb20+
Ci0tLQogZHJpdmVycy9pb21tdS9LY29uZmlnIHwgICAgMSArCiAxIGZpbGVzIGNoYW5nZWQsIDEg
aW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11
L0tjb25maWcgYi9kcml2ZXJzL2lvbW11L0tjb25maWcKaW5kZXggNDMyNDYzYi4uZDkwMTkzMCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9pb21tdS9LY29uZmlnCisrKyBiL2RyaXZlcnMvaW9tbXUvS2Nv
bmZpZwpAQCAtMTEwLDYgKzExMCw3IEBAIGNvbmZpZyBJTlRSX1JFTUFQCiAjIE9NQVAgSU9NTVUg
c3VwcG9ydAogY29uZmlnIE9NQVBfSU9NTVUKIAlib29sICJPTUFQIElPTU1VIFN1cHBvcnQiCisJ
ZGVwZW5kcyBvbiBBUkNIX09NQVAKIAlzZWxlY3QgSU9NTVVfQVBJCiAKIGNvbmZpZyBPTUFQX0lP
Vk1NCi0tIAoxLjcuNC4xCgo=
--00504502ac3c1772dc04ab9df0e7--
