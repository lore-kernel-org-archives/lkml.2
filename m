Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2L1Tny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:43:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55261 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733Ab2L1TST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:19 -0500
Message-Id: <20121228190353.304422319@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 110/173] pnpacpi: fix incorrect TEST_ALPHA() test
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

commit cdc87c5a30f407ed1ce43d8a22261116873d5ef1 upstream.

TEST_ALPHA() is broken and always returns 0.

[akpm@linux-foundation.org: return false for '@' as well, per Bjorn]
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pnp/pnpacpi/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index ec8e914..767f526 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -58,7 +58,7 @@ static inline int __init is_exclusive_device(struct acpi_device *dev)
 	if (!(('0' <= (c) && (c) <= '9') || ('A' <= (c) && (c) <= 'F'))) \
 		return 0
 #define TEST_ALPHA(c) \
-	if (!('@' <= (c) || (c) <= 'Z')) \
+	if (!('A' <= (c) && (c) <= 'Z')) \
 		return 0
 static int __init ispnpidacpi(const char *id)
 {


