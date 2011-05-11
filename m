Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1EKUQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:16:06 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39759 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1EKUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=owpgZQKvp2s7RIZ9+mDxCDVF6p6pbk7Cr+TmhZL2qzqc6dZuUFoBdYNKwwsZ+vNCxi
         +S7rPuxw1ym+HJFJr+LNiupT1c/WcEWVSSnCn7RTLxQNl65c9Y1631uevZCYSJqDEMiR
         0XaeycAphnppSFpYSYJI6RXn9HBEcJVdjF/uQ=
Subject: PM / Wakeup: remove useless synchronize_rcu() call
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 22:15:59 +0200
Message-ID: <1305144959.3232.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wakeup_source_add() adds an item into wakeup_sources list.

There is no need to call synchronize_rcu() at this point.

Its only needed in wakeup_source_remove()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: David Miller <davem@davemloft.net>,
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/wakeup.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index abbbd33..84f7c7d 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -110,7 +110,6 @@ void wakeup_source_add(struct wakeup_source *ws)
 	spin_lock_irq(&events_lock);
 	list_add_rcu(&ws->entry, &wakeup_sources);
 	spin_unlock_irq(&events_lock);
-	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(wakeup_source_add);
 


