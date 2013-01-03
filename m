Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3ACOLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:11:42 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:37269 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3ACOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:11:41 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 3 Jan 2013 15:11:40 +0100
Message-ID: <CA+icZUVEBEerN=YRSS8Rx-2Xvx4byFuBDbVcE45qq4QZ67+Q-A@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: multipart/mixed; boundary=20cf3074b59816e8c804d262f1fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3074b59816e8c804d262f1fa
Content-Type: text/plain; charset=UTF-8

Hi Daniel,

just wanted to test the fb-fix [2] from Alan and followed the thread in [1].
Me is also working with i915 KMS.

I looked at nouveau KMS driver and adapted the part for i915:

drivers/gpu/drm/nouveau/nouveau_drm.c-200-      /* remove conflicting
drivers (vesafb, efifb etc) */
drivers/gpu/drm/nouveau/nouveau_drm.c:201:      aper = alloc_apertures(3);
drivers/gpu/drm/nouveau/nouveau_drm.c-202-      if (!aper)
drivers/gpu/drm/nouveau/nouveau_drm.c-203-              return -ENOMEM;

Untested by me, feel free to test.

Maybe some of the i915 and/or fb driver experts can comment on the problem.

Regards,
- Sedat -

[1] http://marc.info/?t=135721787600001&r=1&w=2
[2] https://patchwork.kernel.org/patch/1757061/

--20cf3074b59816e8c804d262f1fa
Content-Type: application/octet-stream; 
	name="i915-Remove-conflicting-fb-drivers.patch"
Content-Disposition: attachment; 
	filename="i915-Remove-conflicting-fb-drivers.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbhz0viw0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZG1hLmMgYi9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pOTE1X2RtYS5jCmluZGV4IDk5ZGFhODkuLmQ5YWU5M2QgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZG1hLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaTkxNV9kbWEuYwpAQCAtMTM5Niw2ICsxMzk2LDExIEBAIHN0YXRpYyB2b2lkIGk5MTVfa2lj
a19vdXRfZmlybXdhcmVfZmIoc3RydWN0IGRybV9pOTE1X3ByaXZhdGUgKmRldl9wcml2KQogCXN0
cnVjdCBwY2lfZGV2ICpwZGV2ID0gZGV2X3ByaXYtPmRldi0+cGRldjsKIAlib29sIHByaW1hcnk7
CiAKKwkvKiByZW1vdmUgY29uZmxpY3RpbmcgZHJpdmVycyAodmVzYWZiLCBlZmlmYiBldGMpICov
CisJYXAgPSBhbGxvY19hcGVydHVyZXMoMyk7CisJaWYgKCFhcCkKKwkJcmV0dXJuIC1FTk9NRU07
CisKIAlhcCA9IGFsbG9jX2FwZXJ0dXJlcygxKTsKIAlpZiAoIWFwKQogCQlyZXR1cm47Cg==
--20cf3074b59816e8c804d262f1fa--
