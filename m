Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1D1B1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:27:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1D1B1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:27:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:organization;
	b=o7GcYZBf3Xpi1+PzQZml1Khclb2JDxbwC5L5f38vAmBtSMrycbHCiLgbi5+66sIF/
	YJRRwy4t/P/WgUPYdGOOg==
From: David Decotigny <decot@google.com>
To: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: David Decotigny <decot@google.com>
Subject: [PATCHv3 5/7] acenic: Fix using the specified speed when configuring NIC
Date: Wed, 27 Apr 2011 18:27:21 -0700
Message-Id: <1303954043-17440-6-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303954043-17440-1-git-send-email-decot@google.com>
References: <1303954043-17440-1-git-send-email-decot@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tells the NIC to take the speed specified by ethtool into account
when configuring it instead of keeping the previous speed.

Signed-off-by: David Decotigny <decot@google.com>
---
 drivers/net/acenic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index a579899..82260ca 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -2720,7 +2720,7 @@ static int ace_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 		link |= LNK_NEGOTIATE;
 	if (ethtool_cmd_speed(ecmd) != speed) {
 		link &= ~(LNK_1000MB | LNK_100MB | LNK_10MB);
-		switch (speed) {
+		switch (ethtool_cmd_speed(ecmd)) {
 		case SPEED_1000:
 			link |= LNK_1000MB;
 			break;
-- 
1.7.3.1

