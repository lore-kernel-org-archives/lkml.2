Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2JOKDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:03:16 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55944 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727Ab2JOKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:03:15 -0400
Message-ID: <1350295389.1516.27.camel@x61.thuisdomein>
Subject: [PATCH] xen/xenbus: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Oct 2012 12:03:09 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Oct 2012 10:03:10.0468 (UTC) FILETIME=[4826AC40:01CDAABC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling xenbus_xs.o triggers this GCC warning:
    drivers/xen/xenbus/xenbus_xs.c:628:13: warning: function declaration isn’t a prototype [-Wstrict-prototypes]

Add the obvious and trivial fix.

While we're touching this function add some equally obvious and trivial
whitespace fixes.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Triggered by compiling v3.7-rc1 using (basically) Fedora 17's current
config. Compile tested only.

1) Obligatory reference: https://lwn.net/Articles/487493/ .

 drivers/xen/xenbus/xenbus_xs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 48220e1..7a2b0da 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -619,13 +619,14 @@ static struct xenbus_watch *find_watch(const char *token)
 
 	return NULL;
 }
+
 /*
  * Certain older XenBus toolstack cannot handle reading values that are
  * not populated. Some Xen 3.4 installation are incapable of doing this
  * so if we are running on anything older than 4 do not attempt to read
  * control/platform-feature-xs_reset_watches.
  */
-static bool xen_strict_xenbus_quirk()
+static bool xen_strict_xenbus_quirk(void)
 {
 	uint32_t eax, ebx, ecx, edx, base;
 
@@ -635,8 +636,8 @@ static bool xen_strict_xenbus_quirk()
 	if ((eax >> 16) < 4)
 		return true;
 	return false;
-
 }
+
 static void xs_reset_watches(void)
 {
 	int err, supported = 0;
-- 
1.7.11.7

