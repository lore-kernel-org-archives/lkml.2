Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab1I1WqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874Ab1I1WqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:39 2011
Message-Id: <20110928220139.246712806@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [132/244] ibmveth: Checksum offload is always disabled
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 91aae1e5c407d4fc79f6983e6c6ba04756c004cb upstream.

Commit b9367bf3ee6d (net: ibmveth: convert to hw_features) reversed
a check in ibmveth_set_csum_offload that results in checksum offload
never being enabled.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ibmveth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -811,7 +811,7 @@ static int ibmveth_set_csum_offload(stru
 		} else
 			adapter->fw_ipv6_csum_support = data;
 
-		if (ret != H_SUCCESS || ret6 != H_SUCCESS)
+		if (ret == H_SUCCESS || ret6 == H_SUCCESS)
 			adapter->rx_csum = data;
 		else
 			rc1 = -EIO;


