Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1BPBuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:50:40 -0500
Received: from kroah.org ([198.145.64.141]:48998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758303Ab1BPBuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:59 2011
Message-Id: <20110216014659.681482261@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sven Neumann <s.neumann@raumfeld.com>, Daniel Mack <daniel@caiaq.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [054/115] ds2760_battery: Fix calculation of time_to_empty_now
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Neumann <s.neumann@raumfeld.com>

commit 86af95039b69a90db15294eb1f9c147f1df0a8ea upstream.

A check against division by zero was modified in commit b0525b48.
Since this change time_to_empty_now is always reported as zero
while the battery is discharging and as a negative value while
the battery is charging. This is because current is negative while
the battery is discharging.

Fix the check introduced by commit b0525b48 so that time_to_empty_now
is reported correctly during discharge and as zero while charging.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/power/ds2760_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -211,7 +211,7 @@ static int ds2760_battery_read_status(st
 	if (di->rem_capacity > 100)
 		di->rem_capacity = 100;
 
-	if (di->current_uA >= 100L)
+	if (di->current_uA < -100L)
 		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
 					/ (di->current_uA / 100L);
 	else


