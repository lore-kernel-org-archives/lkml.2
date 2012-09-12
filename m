Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab2ILXmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:42:40 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab2ILXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:42:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mathias Krause <minipli@googlemail.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 84/85] dccp: check ccid before dereferencing
Date: Wed, 12 Sep 2012 16:37:07 -0700
Message-Id: <20120912233550.468230729@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 276bdb82dedb290511467a5a4fdbe9f0b52dce6f upstream.

ccid_hc_rx_getsockopt() and ccid_hc_tx_getsockopt() might be called with
a NULL ccid pointer leading to a NULL pointer dereference. This could
lead to a privilege escalation if the attacker is able to map page 0 and
prepare it with a fake ccid_ops pointer.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/dccp/ccid.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/dccp/ccid.h
+++ b/net/dccp/ccid.h
@@ -246,7 +246,7 @@ static inline int ccid_hc_rx_getsockopt(
 					u32 __user *optval, int __user *optlen)
 {
 	int rc = -ENOPROTOOPT;
-	if (ccid->ccid_ops->ccid_hc_rx_getsockopt != NULL)
+	if (ccid != NULL && ccid->ccid_ops->ccid_hc_rx_getsockopt != NULL)
 		rc = ccid->ccid_ops->ccid_hc_rx_getsockopt(sk, optname, len,
 						 optval, optlen);
 	return rc;
@@ -257,7 +257,7 @@ static inline int ccid_hc_tx_getsockopt(
 					u32 __user *optval, int __user *optlen)
 {
 	int rc = -ENOPROTOOPT;
-	if (ccid->ccid_ops->ccid_hc_tx_getsockopt != NULL)
+	if (ccid != NULL && ccid->ccid_ops->ccid_hc_tx_getsockopt != NULL)
 		rc = ccid->ccid_ops->ccid_hc_tx_getsockopt(sk, optname, len,
 						 optval, optlen);
 	return rc;


