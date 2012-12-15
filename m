Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2LOGDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:03:54 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:41638 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582Ab2LOGDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:03:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 4/6] staging/fwserial: Update TODO file per reviewer comments
Date: Sat, 15 Dec 2012 01:03:18 -0500
Message-Id: <1355551400-8204-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pursuant to this review https://lkml.org/lkml/2012/11/12/500
by Stefan Richter, update the TODO file.
- Clarify purpose of TODO file
- Remove firewire item #4. As discussed in this conversation
  https://lkml.org/lkml/2012/11/13/564 knowing the AR buffer size
  is not a hard requirement. The required rx buffer size can be
  determined experimentally.
- Remove firewire item #5. This was a private note for further
  experimentation.
- Change firewire item #1. Change suggested header from uapi header
  to kernel-only header.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/TODO | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/fwserial/TODO b/drivers/staging/fwserial/TODO
index ffe47d1..8dae8fb 100644
--- a/drivers/staging/fwserial/TODO
+++ b/drivers/staging/fwserial/TODO
@@ -1,5 +1,5 @@
-TODOs
------
+TODOs prior to this driver moving out of staging
+------------------------------------------------
 1. Implement retries for RCODE_BUSY, RCODE_NO_ACK and RCODE_SEND_ERROR
    - I/O is handled asynchronously which presents some issues when error
      conditions occur.
@@ -11,14 +11,9 @@ TODOs
 -- Issues with firewire stack --
 1. This driver uses the same unregistered vendor id that the firewire core does
      (0xd00d1e). Perhaps this could be exposed as a define in
-     firewire-constants.h?
+     firewire.h?
 3. Maybe device_max_receive() and link_speed_to_max_payload() should be
      taken up by the firewire core?
-4. To avoid dropping rx data while still limiting the maximum buffering,
-     the size of the AR context must be known. How to expose this to drivers?
-5. Explore if bigger AR context will reduce RCODE_BUSY responses
-   (or auto-grow to certain max size -- but this would require major surgery
-    as the current AR is contiguously mapped)
 
 -- Issues with TTY core --
   1. Hack for alternate device name scheme
-- 
1.8.0.1

