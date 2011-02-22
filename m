Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1BVWWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:44 -0500
Received: from kroah.org ([198.145.64.141]:33022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1BVWWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:43 2011
Message-Id: <20110222221843.639313966@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [66/70] net: can: janz-ican3: world-writable sysfs termination file
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 1e6d93e45b231b3ae87c01902ede2315aacfe976 upstream.

Don't allow everybody to set terminator via sysfs.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/can/janz-ican3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1627,7 +1627,7 @@ static ssize_t ican3_sysfs_set_term(stru
 	return count;
 }
 
-static DEVICE_ATTR(termination, S_IWUGO | S_IRUGO, ican3_sysfs_show_term,
+static DEVICE_ATTR(termination, S_IWUSR | S_IRUGO, ican3_sysfs_show_term,
 						   ican3_sysfs_set_term);
 
 static struct attribute *ican3_sysfs_attrs[] = {


