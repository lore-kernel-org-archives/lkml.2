Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162494Ab2GLX0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:26:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162008Ab2GLWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stone Piao <piaoyun@marvell.com>, Avinash Patil <patila@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 118/187] mwifiex: fix WPS eapol handshake failure
Date: Thu, 12 Jul 2012 15:34:34 -0700
Message-Id: <20120712191533.293706770@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stone Piao <piaoyun@marvell.com>

commit f03ba7e9a24e5e9efaad56bd1713b994ea556b16 upstream.

After association, STA will go through eapol handshake with WPS
enabled AP. It's observed that WPS handshake fails with some 11n
AP. The reason for the failure is that the eapol packet is sent
via 11n frame aggregation.

The eapol packet should be sent directly without 11n aggregation.

This patch fixes the problem by adding WPS session control while
dequeuing Tx packets for transmission.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/wmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1211,6 +1211,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex
 
 	if (!ptr->is_11n_enabled ||
 	    mwifiex_is_ba_stream_setup(priv, ptr, tid) ||
+	    priv->wps.session_enable ||
 	    ((priv->sec_info.wpa_enabled ||
 	      priv->sec_info.wpa2_enabled) &&
 	     !priv->wpa_is_gtk_set)) {


