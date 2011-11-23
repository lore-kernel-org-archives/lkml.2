Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1KWAeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:34:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab1KWAeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:34:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:07 2011
Message-Id: <20111123002207.563573094@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:20:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [06/25] PM / Suspend: Off by one in pm_suspend()
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 833
Lines: 29

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 528f7ce6e439edeac38f6b3f8561f1be129b5e91 upstream.

In enter_state() we use "state" as an offset for the pm_states[]
array.  The pm_states[] array only has PM_SUSPEND_MAX elements so
this test is off by one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/power/suspend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -293,7 +293,7 @@ int enter_state(suspend_state_t state)
  */
 int pm_suspend(suspend_state_t state)
 {
-	if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX)
+	if (state > PM_SUSPEND_ON && state < PM_SUSPEND_MAX)
 		return enter_state(state);
 	return -EINVAL;
 }


