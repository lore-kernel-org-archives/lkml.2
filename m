Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3AIWEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:04:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:40920 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669Ab3AIUg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 08/47] pnpacpi: fix incorrect TEST_ALPHA() test
Date: Wed,  9 Jan 2013 12:35:03 -0800
Message-Id: <20130109201730.456812957@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

commit cdc87c5a30f407ed1ce43d8a22261116873d5ef1 upstream.

TEST_ALPHA() is broken and always returns 0.

[akpm@linux-foundation.org: return false for '@' as well, per Bjorn]
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pnp/pnpacpi/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -57,7 +57,7 @@ static inline int __init is_exclusive_de
 	if (!(('0' <= (c) && (c) <= '9') || ('A' <= (c) && (c) <= 'F'))) \
 		return 0
 #define TEST_ALPHA(c) \
-	if (!('@' <= (c) || (c) <= 'Z')) \
+	if (!('A' <= (c) && (c) <= 'Z')) \
 		return 0
 static int __init ispnpidacpi(const char *id)
 {


