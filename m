Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030513Ab2CGV6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:58:55 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57574 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030450Ab2CGV6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:50 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 10/13] android: persistent_ram: add notrace to persistent_ram_write
Date: Wed,  7 Mar 2012 13:58:20 -0800
Message-Id: <1331157503-3413-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-2398-0000-0000-000004DDB942
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Add the notrace attribute to persistent_ram_write and the
non-ecc functions that it calls to allow persistent_ram to
be used for ftracing (only when ecc is disabled).

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: I9c96039d9a6281fc6a62ddb1c7128c26627cc258
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/persistent_ram.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index 3eb2fb4..e08f257 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -96,7 +96,7 @@ static inline ssize_t buffer_size_add_clamp(struct persistent_ram_zone *prz,
 	return 0;
 }
 
-static void persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
+static void notrace persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
 	uint8_t *data, size_t len, uint8_t *ecc)
 {
 	int i;
@@ -121,7 +121,7 @@ static int persistent_ram_decode_rs8(struct persistent_ram_zone *prz,
 				NULL, 0, NULL, 0, NULL);
 }
 
-static void persistent_ram_update_ecc(struct persistent_ram_zone *prz,
+static void notrace persistent_ram_update_ecc(struct persistent_ram_zone *prz,
 	unsigned int start, unsigned int count)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
@@ -258,7 +258,7 @@ ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
 	return ret;
 }
 
-static void persistent_ram_update(struct persistent_ram_zone *prz,
+static void notrace persistent_ram_update(struct persistent_ram_zone *prz,
 	const void *s, unsigned int start, unsigned int count)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
@@ -288,7 +288,7 @@ persistent_ram_save_old(struct persistent_ram_zone *prz)
 	memcpy(prz->old_log + size - start, &buffer->data[0], start);
 }
 
-int persistent_ram_write(struct persistent_ram_zone *prz,
+int notrace persistent_ram_write(struct persistent_ram_zone *prz,
 	const void *s, unsigned int count)
 {
 	int rem;
-- 
1.7.3.2.146.gca209

