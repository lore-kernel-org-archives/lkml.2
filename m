Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0LJD3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:29:34 -0500
Received: from mail.perches.com ([173.55.12.10]:2467 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab0LJD3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:29:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] hid: Remove __inline__ from functions
Date: Thu,  9 Dec 2010 19:29:05 -0800
Message-Id: <f25468d2916e2d673cdd88d3f40165026064476b.1291951482.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
In-Reply-To: <cover.1291951482.git.joe@perches.com>
References: <cover.1291951482.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the compiler decide instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index ff43b4a..d6dffcc 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -739,8 +739,8 @@ static u32 s32ton(__s32 value, unsigned n)
  * Search linux-kernel and linux-usb-devel archives for "hid-core extract".
  */
 
-static __inline__ __u32 extract(const struct hid_device *hid, __u8 *report,
-				unsigned offset, unsigned n)
+static __u32 extract(const struct hid_device *hid, __u8 *report,
+		     unsigned offset, unsigned n)
 {
 	u64 x;
 
@@ -763,8 +763,8 @@ static __inline__ __u32 extract(const struct hid_device *hid, __u8 *report,
  * endianness of register values by considering a register
  * a "cached" copy of the little endiad bit stream.
  */
-static __inline__ void implement(const struct hid_device *hid, __u8 *report,
-				 unsigned offset, unsigned n, __u32 value)
+static void implement(const struct hid_device *hid, __u8 *report,
+		      unsigned offset, unsigned n, __u32 value)
 {
 	u64 x;
 	u64 m = (1ULL << n) - 1;
@@ -792,7 +792,7 @@ static __inline__ void implement(const struct hid_device *hid, __u8 *report,
  * Search an array for a value.
  */
 
-static __inline__ int search(__s32 *array, __s32 value, unsigned n)
+static int search(__s32 *array, __s32 value, unsigned n)
 {
 	while (n--) {
 		if (*array++ == value)
-- 
1.7.3.3.464.gf80b6

