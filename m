Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0G3REb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:04:31 -0400
Received: from kroah.org ([198.145.64.141]:35573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab0G3RDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:42 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:55 2010
Message-Id: <20100730165955.048101505@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Or Gerlitz <ogerlitz@voltaire.com>, Roland Dreier <rolandd@cisco.com>
Subject: [14/17] IPoIB: Fix world-writable child interface control sysfs attributes
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Or Gerlitz <ogerlitz@voltaire.com>

commit 7a52b34b07122ff5f45258d47f260f8a525518f0 upstream.

Sumeet Lahorani <sumeet.lahorani@oracle.com> reported that the IPoIB
child entries are world-writable; however we don't want ordinary users
to be able to create and destroy child interfaces, so fix them to be
writable only by root.

Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1158,7 +1158,7 @@ static ssize_t create_child(struct devic
 
 	return ret ? ret : count;
 }
-static DEVICE_ATTR(create_child, S_IWUGO, NULL, create_child);
+static DEVICE_ATTR(create_child, S_IWUSR, NULL, create_child);
 
 static ssize_t delete_child(struct device *dev,
 			    struct device_attribute *attr,
@@ -1178,7 +1178,7 @@ static ssize_t delete_child(struct devic
 	return ret ? ret : count;
 
 }
-static DEVICE_ATTR(delete_child, S_IWUGO, NULL, delete_child);
+static DEVICE_ATTR(delete_child, S_IWUSR, NULL, delete_child);
 
 int ipoib_add_pkey_attr(struct net_device *dev)
 {


