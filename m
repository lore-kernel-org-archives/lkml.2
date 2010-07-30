Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab0G3RzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:55:15 -0400
Received: from kroah.org ([198.145.64.141]:58028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759708Ab0G3Ryr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:47 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:37 2010
Message-Id: <20100730175137.296533139@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vivek Natarajan <vnatarajan@atheros.com>,
        Ranga Rao Ravuri <ranga.ravuri@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [041/205] ath9k: Avoid corrupt frames being forwarded to mac80211.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vivek Natarajan <vnatarajan@atheros.com>

commit 3a37495268ab45507b4cab9d4cb18c5496ab7a10 upstream.

If bit 29 is set, MAC H/W can attempt to decrypt the received aggregate
with WEP or TKIP, eventhough the received frame may be a CRC failed
corrupted frame. If this bit is set, H/W obeys key type in keycache.
If it is not set and if the key type in keycache is neither open nor
AES, H/W forces key type to be open.  But bit 29 should be set to 1
for AsyncFIFO feature to encrypt/decrypt the aggregate with WEP or TKIP.

Reported-by: Johan Hovold <johan.hovold@lundinova.se>
Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/initvals.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -246,7 +246,7 @@ static const u32 ar5416Common[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8000010 },
+    { 0x00008264, 0x88000010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -2766,7 +2766,7 @@ static const u32 ar9280Common_9280_2[][2
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -3936,7 +3936,7 @@ static const u_int32_t ar9285Common_9285
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -5073,7 +5073,7 @@ static const u_int32_t ar9287Common_9287
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },


