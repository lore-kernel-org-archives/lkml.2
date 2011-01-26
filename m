Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1AZLsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:48:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49278 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1AZLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:48:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=grYTll/QRCVv//MdKITozwBY5rzU4Qwv59a8snjcvF60h0ghU5Hr+117mui6ZS36+O
         0OKBaD+Uau6+PdQTBdsrqhCwJxhLfIj3eWJby0jtwArLTihLz/OWWVxtr2S3ifXmRhUS
         yFc/wubeI6aGawiZ9+hLefGgoijYQQjX7+Kbw=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/5] staging: ft1000: Remove unnecessary assignment.
Date: Wed, 26 Jan 2011 12:49:12 +0100
Message-Id: <1296042555-29145-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dsp_img_info->version and requested_version have same type
so additional temporary variable creation could be omitted
because variables could be compares directly.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 9e9709a..b99553b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -1026,12 +1026,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
 
                for (image = 0; image < file_hdr->nDspImages; image++)
                {
-
-                       temp = (u16)(dsp_img_info->version);
-                       templong = temp;
-                       temp = (u16)(dsp_img_info->version >> 16);
-                       templong |= (temp << 16);
-                   if (templong == (u32)requested_version)
+                   if (dsp_img_info->version == requested_version)
                        {
                            correct_version = TRUE;
                            DEBUG("FT1000:download: correct_version is TRUE\n");
-- 
1.7.1

