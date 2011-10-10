Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1JJOen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:34:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:45631 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1JJOem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,517,1312182000"; 
   d="scan'208";a="24863714"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCHv2 3/5] security: follow rename pack_hex_byte to hex_byte_pack
Date: Mon, 10 Oct 2011 17:33:37 +0300
Message-Id: <7a5226e5f0aa2ca9ff18de66f64091840cb077da.1318257114.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
References: <CAKiorj5MJ8_ZH-J-7GjNQLoPNTshFdrrHfjptgpgi_4mchHJYw@mail.gmail.com>
 <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
References: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
---
 security/keys/encrypted-keys/encrypted.c |    2 +-
 security/keys/trusted.c                  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index f33804c..dcc843c 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -293,7 +293,7 @@ static char *datablob_format(struct encrypted_key_payload *epayload,
 	/* convert the hex encoded iv, encrypted-data and HMAC to ascii */
 	bufp = &ascii_buf[len];
 	for (i = 0; i < (asciiblob_len - len) / 2; i++)
-		bufp = pack_hex_byte(bufp, iv[i]);
+		bufp = hex_byte_pack(bufp, iv[i]);
 out:
 	return ascii_buf;
 }
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 0964fc2..0ed5fdf 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1098,7 +1098,7 @@ static long trusted_read(const struct key *key, char __user *buffer,
 
 	bufp = ascii_buf;
 	for (i = 0; i < p->blob_len; i++)
-		bufp = pack_hex_byte(bufp, p->blob[i]);
+		bufp = hex_byte_pack(bufp, p->blob[i]);
 	if ((copy_to_user(buffer, ascii_buf, 2 * p->blob_len)) != 0) {
 		kfree(ascii_buf);
 		return -EFAULT;
-- 
1.7.6.3

