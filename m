Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032010Ab2I1UXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:23:00 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46787 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031983Ab2I1UWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 026/218] sfc: Fix reporting of IPv4 full filters through ethtool
Date: Fri, 28 Sep 2012 13:14:03 -0700
Message-Id: <20120928201504.387557862@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit ac70b2e9a13423b5efa0178e081936ce6979aea5 ]

ETHTOOL_GRXCLSRULE returns filters for a TCP/IPv4 or UDP/IPv4 4-tuple
with source and destination swapped.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
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


