Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0IXQ6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:58:13 -0400
Received: from kroah.org ([198.145.64.141]:46104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570Ab0IXQ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:09 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.652266719@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [20/80] drivers/net/eql.c: prevent reading uninitialized stack memory
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 44467187dc22fdd33a1a06ea0ba86ce20be3fe3c upstream.

Fixed formatting (tabs and line breaks).

The EQL_GETMASTRCFG device ioctl allows unprivileged users to read 16
bytes of uninitialized stack memory, because the "master_name" member of
the master_config_t struct declared on the stack in eql_g_master_cfg()
is not altered or zeroed before being copied back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/eql.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -555,6 +555,8 @@ static int eql_g_master_cfg(struct net_d
 	equalizer_t *eql;
 	master_config_t mc;
 
+	memset(&mc, 0, sizeof(master_config_t));
+
 	if (eql_is_master(dev)) {
 		eql = netdev_priv(dev);
 		mc.max_slaves = eql->max_slaves;


