Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab1D0SfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:35:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9712 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1D0SfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:35:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:organization;
	b=ZcKdUD65rXtwrbyqSjP57ZFD7BE4UoTY3oUeOkLEiG58dUiiXG+3qJ8hjJdoGuPKa
	pgB0H2MmJL4J/yBzp/LgA==
From: David Decotigny <decot@google.com>
To: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: David Decotigny <decot@google.com>
Subject: [PATCHv2] acenic: Fix using the specified speed when configuring NIC
Date: Wed, 27 Apr 2011 11:34:50 -0700
Message-Id: <1303929290-21037-6-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303001651-4074-1-git-send-email-decot@google.com>
References: <1303001651-4074-1-git-send-email-decot@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tells the NIC to take the speed specified by ethtool into account
when configuring the NIC, instead of keeping the previous speed.

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

