Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2KLI3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:29:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:55465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2KLI3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:29:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,761,1344236400"; 
   d="scan'208";a="218174193"
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
To: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org
Cc: Joseph Gasparakis <joseph.gasparakis@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry@broadcom.com
Subject: [PATCH v2 net-next 0/3 ] tunneling: Add support for hardware-offloaded encapsulation
Date: Mon, 12 Nov 2012 00:36:55 -0800
Message-Id: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series contains updates to add in the NIC Rx and Tx checksumming support
for encapsulated packets.

The sk_buff needs to somehow have information of the inner packet, and adding
three fields for the inner mac, network and transport headers was the prefered
approach. 

Not adding these fields would mean that the drivers would need to parse the
sk_buff data in hot-path, having a negative impact in the performance.

Adding in sk_buff a pointer to the skbuff of the inner packet made sense, but
would be a complicated change as assumptions needed to be made with regards to
helper functions such as skb_clone() skb_copy(). Also code for the existing
encapsulation protocols (such as VXLAN and IP GRE) had to be reworked, so the
decision was to have the simple approach of adding these three fields.

v2 Makes sure that checksumming for IP GRE does not take place if the offload flag is set in the skb's netdev features
