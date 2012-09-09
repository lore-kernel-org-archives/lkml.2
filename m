Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2IIX0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:26:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51347 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117Ab2IIXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:42 -0400
Message-Id: <20120909224158.159089877@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Amerigo Wang <amwang@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: [ 54/95] netconsole: remove a redundant netconsole_target_put()
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amerigo Wang <amwang@redhat.com>

commit 72d3eb13b5c0abe7d63efac41f39c5b644c7bbaa upstream.

This netconsole_target_put() is obviously redundant, and it
causes a kernel segfault when removing a bridge device which has
netconsole running on it.

This is caused by:

	commit 8d8fc29d02a33e4bd5f4fa47823c1fd386346093
	Author: Amerigo Wang <amwang@redhat.com>
	Date:   Thu May 19 21:39:10 2011 +0000

	    netpoll: disable netpoll when enslave a device

Cc: David Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/netconsole.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -652,7 +652,6 @@ static int netconsole_netdev_event(struc
 							  flags);
 					dev_put(nt->np.dev);
 					nt->np.dev = NULL;
-					netconsole_target_put(nt);
 				}
 				nt->enabled = 0;
 				stopped = true;


