Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161800Ab1FAIO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:14:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161772Ab1FAIOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:14:22 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:58 2011
Message-Id: <20110601080357.803628210@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:27 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg@redhat.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [091/146] ips: use interruptible waits in ips-monitor
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit a3424216e4935221fdaa5ca3c26e024f11297164 upstream.

This is what I intended to do since:
  1) the driver handles variable waits just fine, and
  2) interruptible waits aren't reported as load in the load avg.

Reported-and-tested-by: Andreas Hartmann <andihartmann@freenet.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/intel_ips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1111,7 +1111,7 @@ static int ips_monitor(void *data)
 		last_msecs = jiffies_to_msecs(jiffies);
 		expire = jiffies + msecs_to_jiffies(IPS_SAMPLE_PERIOD);
 
-		__set_current_state(TASK_UNINTERRUPTIBLE);
+		__set_current_state(TASK_INTERRUPTIBLE);
 		mod_timer(&timer, expire);
 		schedule();
 


