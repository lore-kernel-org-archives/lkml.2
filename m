Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161015Ab2I1UCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:02:06 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960Ab2I1Szk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Cong Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 040/262] netconsole: remove a redundant netconsole_target_put()
Date: Fri, 28 Sep 2012 11:49:29 -0700
Message-Id: <20120928183002.704888605@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/netconsole.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -648,7 +648,6 @@ static int netconsole_netdev_event(struc
 							  flags);
 					dev_put(nt->np.dev);
 					nt->np.dev = NULL;
-					netconsole_target_put(nt);
 				}
 				nt->enabled = 0;
 				stopped = true;


