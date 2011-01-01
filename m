Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1AAQSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 11:18:45 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59782 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1AAQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 11:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=p2xSr5yUydzipaMFahWSJfdMS5rIhWPFQ8Y8fb9g6dwh66BgE8gYxxZ7FDPVnVYBib
         EbWOGbLYadEzdv6TwisV4ezi0l5alNhI7DRfMCswGoKcKrrwsoSXw99tryAMluF2gyTo
         s0zLGTfPEIxp8PRv3L6shUVkPdl3LfMhRP7+s=
Message-ID: <4D1F53E0.9050802@gmail.com>
Date: Sat, 01 Jan 2011 17:18:40 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jic23@cam.ac.uk
Subject: [PATCH] iio: --/++ confusion in build_channel_array() error cleanup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix loop: it should decrement

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/iio/Documentation/iio_utils.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
index 0372424..4dc961c 100644
--- a/drivers/staging/iio/Documentation/iio_utils.h
+++ b/drivers/staging/iio/Documentation/iio_utils.h
@@ -398,7 +398,7 @@ inline int build_channel_array(const char *device_dir,
 	return 0;
 
 error_cleanup_array:
-	for (i = count - 1;  i >= 0; i++)
+	for (i = count - 1;  i >= 0; i--)
 		free((*ci_array)[i].name);
 	free(*ci_array);
 error_close_dir:
