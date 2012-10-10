Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2JJWyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:54:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60005 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757548Ab2JJWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:52 -0400
X-Sasl-enc: CoAF1PYo0Ay3c+ECoW/ywUZ8HQCIMRZTPlre8rzbEH5m 1349909631
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jacob Keller <jacob.e.keller@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 019/133] ixgbe: fix PTP ethtool timestamping function
Date: Thu, 11 Oct 2012 07:50:45 +0900
Message-Id: <20121010224857.900240921@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

commit 1cc92eb871d6cbb1da038b4bcd89eec3c73b9781 upstream.

This patch fixes a development issue that occurred due to invalid modes reported
in the ethtool get_ts_info function. The issue is resolved by removing
unsupported modes from the Rx supported list.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2723,10 +2723,7 @@ static int ixgbe_get_ts_info(struct net_
 			(1 << HWTSTAMP_FILTER_NONE) |
 			(1 << HWTSTAMP_FILTER_PTP_V1_L4_SYNC) |
 			(1 << HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ) |
-			(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
-			(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ) |
-			(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
-			(1 << HWTSTAMP_FILTER_SOME);
+			(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
 		break;
 #endif /* CONFIG_IXGBE_PTP */
 	default:


