Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1I1XEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:04:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933073Ab1I1WrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220144.310900838@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zheng Yan <zheng.z.yan@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [180/244] mcast: Fix source address selection for multicast listener report
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

[ Upstream commit e05c4ad3ed874ee4f5e2c969e55d318ec654332c ]

Should check use count of include mode filter instead of total number
of include mode filters.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/igmp.c  |    2 +-
 net/ipv6/mcast.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -767,7 +767,7 @@ static int igmp_xmarksources(struct ip_m
 			break;
 		for (i=0; i<nsrcs; i++) {
 			/* skip inactive filters */
-			if (pmc->sfcount[MCAST_INCLUDE] ||
+			if (psf->sf_count[MCAST_INCLUDE] ||
 			    pmc->sfcount[MCAST_EXCLUDE] !=
 			    psf->sf_count[MCAST_EXCLUDE])
 				continue;
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1059,7 +1059,7 @@ static int mld_xmarksources(struct ifmca
 			break;
 		for (i=0; i<nsrcs; i++) {
 			/* skip inactive filters */
-			if (pmc->mca_sfcount[MCAST_INCLUDE] ||
+			if (psf->sf_count[MCAST_INCLUDE] ||
 			    pmc->mca_sfcount[MCAST_EXCLUDE] !=
 			    psf->sf_count[MCAST_EXCLUDE])
 				continue;


