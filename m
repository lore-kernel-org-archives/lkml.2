Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1EJATX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 20:19:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27551 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1EJATW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 20:19:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:organization;
	b=PYF33KhAmrlUmBR3wIYHiICkFFuWOHOnWWapIdob5aTmQg7QSzkPjm2JnHFrmeNOF
	4ODDEWWVVZzobfGtOd+2A==
From: David Decotigny <decot@google.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Decotigny <decot@google.com>
Subject: [PATCH 0/2] Minor autonegociation changes, testers welcome
Date: Mon,  9 May 2011 17:19:06 -0700
Message-Id: <1304986748-15809-1-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following 2 patches fix a few minor issues noticed by Ben and that
I tried to address here. The code compiles and "looks" good but I
don't have the required hardware to test. If you have access to the
affected NICs, I would really appreciate your help testing the
patches:
 - stmmac: ethtool -a ethX
           ethtool -A ethX [same params except:] autoneg off
 - dl2k: ethtool -s ethX speed 10 autoneg off # should work
         likewise with 100, but not with 1000 (ethtool error)

IMHO, the main differences that could be experienced relate to the
return value of ethtool, which should now report errors more
frequently than before (most were ignored).

David Decotigny (2):
  net/stmmac: don't go through ethtool to start autonegociation
  net/dl2k: Don't reconfigure link @100Mbps when disabling autoneg
    @1Gbps

 drivers/net/dl2k.c                  |   19 ++++++-------------
 drivers/net/stmmac/stmmac_ethtool.c |   13 ++-----------
 2 files changed, 8 insertions(+), 24 deletions(-)

-- 
1.7.3.1

