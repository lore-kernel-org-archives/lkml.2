Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0DVTzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:55:21 -0400
Received: from kroah.org ([198.145.64.141]:40841 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab0DVT2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:34 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190914.564316354@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [080/197] eeepc-laptop: disable wireless hotplug for 1005PE
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit ced69c59811f05b2f8378467cbb82ac6ed3c6a5a upstream.

The wireless hotplug code is not needed on this model, and it disables
the wired ethernet card.  (Like on the 1005HA and 1201N).

[bwh: Backported to 2.6.32]

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Reported-by: Ansgar Burchardt <ansgar@43-1.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -660,7 +660,8 @@ static void eeepc_dmi_check(void)
 	 * hotplug code. In fact, current hotplug code seems to unplug another
 	 * device...
 	 */
-	if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0) {
+	if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0 ||
+	    strcmp(model, "1005PE") == 0) {
 		ehotk->hotplug_disabled = true;
 		pr_info("wlan hotplug disabled\n");
 	}


