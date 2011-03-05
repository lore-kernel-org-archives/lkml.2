Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546Ab1CEBH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:07:26 -0500
Received: from kroah.org ([198.145.64.141]:47707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760531Ab1CEBFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:52 2011
Message-Id: <20110305010352.785248400@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:03:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        maximilian attems <max@stro.at>
Subject: [10/18] netxen: fix set mac addr
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Kumar Salecha <amit.salecha@qlogic.com>

commit d49c9640975355c79f346869831bf9780d185de0 upstream.

o If tx and rx resources are not available, during set mac request.
  Then this request wont be passed to firmware and it will be added to
  driver mac list and will never make it to firmware.
  So if resources are not available, don't add it to driver mac list.

Signed-off-by: Amit Kumar Salecha <amit.salecha@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/netxen/netxen_nic_hw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -685,6 +685,9 @@ void netxen_p3_nic_set_multi(struct net_
 	struct list_head *head;
 	nx_mac_list_t *cur;
 
+	if (adapter->is_up != NETXEN_ADAPTER_UP_MAGIC)
+		return;
+
 	list_splice_tail_init(&adapter->mac_list, &del_list);
 
 	nx_p3_nic_add_mac(adapter, adapter->mac_addr, &del_list);


