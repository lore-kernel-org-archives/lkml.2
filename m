Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab2I1SzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:55:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab2I1SzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 028/262] sfc: Fix reporting of IPv4 full filters through ethtool
Date: Fri, 28 Sep 2012 11:49:17 -0700
Message-Id: <20120928183001.309913310@linuxfoundation.org>
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


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit ac70b2e9a13423b5efa0178e081936ce6979aea5 ]

ETHTOOL_GRXCLSRULE returns filters for a TCP/IPv4 or UDP/IPv4 4-tuple
with source and destination swapped.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ethtool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -863,8 +863,8 @@ static int efx_ethtool_get_class_rule(st
 				       &ip_entry->ip4dst, &ip_entry->pdst);
 	if (rc != 0) {
 		rc = efx_filter_get_ipv4_full(
-			&spec, &proto, &ip_entry->ip4src, &ip_entry->psrc,
-			&ip_entry->ip4dst, &ip_entry->pdst);
+			&spec, &proto, &ip_entry->ip4dst, &ip_entry->pdst,
+			&ip_entry->ip4src, &ip_entry->psrc);
 		EFX_WARN_ON_PARANOID(rc);
 		ip_mask->ip4src = ~0;
 		ip_mask->psrc = ~0;


