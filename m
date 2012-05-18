Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946582Ab2ERXFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946531Ab2ERXFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:24 -0400
Message-Id: <20120518211604.199502615@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 52/54] pch_gbe: Fixed the issue on which PC was frozen when link was downed.
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

commit 5f3a11419099d5cc010cfbfc524ca10d8fb81f89 upstream.

When a link was downed during network use,
there is an issue on which PC freezes.

This patch fixed this issue.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

---
 drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -2128,7 +2128,7 @@ static int pch_gbe_napi_poll(struct napi
 		/* If no Tx and not enough Rx work done,
 		 * exit the polling mode
 		 */
-		if ((work_done < budget) || !netif_running(netdev))
+		if (work_done < budget)
 			poll_end_flag = true;
 	}
 


