Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0KHQCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:02:34 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53092 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0KHQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tsMqmb01lcQmy85/d0F4I3bLMA+sHbK1mWijEy3ud+qSPTjOwWamB7M17HuXuuucpo
         EMw0b9Nf1GdiQ5KFWG+bbLhnmdjoeh6HxtdrsBgRs3qBOUmeWQ3Ho94HxlKmOMKxy5F1
         fJNKtgrWxfW8tKr0MUf1D6Wz+D5Q0HHU6pBMI=
Message-ID: <4CD81EDD.1000309@gmail.com>
Date: Mon, 08 Nov 2010 21:31:33 +0530
From: Atul Sowani <sowani@gmail.com>
Reply-To: sowani@gmail.com
Organization: Digital Reality Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.36 1/1] mac80211: fix for tx.c compiler warnings.
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added conditional compilation with CONFIG_MAC80211_MESH to avoid compile time
warning about declared but unused variable.

Signed-off-by: Atul Sowani <sowani@gmail.com>
---
diff -uprN a/net/mac80211/tx.c b/net/mac80211/tx.c
--- a/net/mac80211/tx.c	2010-10-21 02:00:22.000000000 +0530
+++ b/net/mac80211/tx.c	2010-11-08 10:37:42.331750460 +0530
@@ -1699,7 +1699,9 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
 	struct ieee80211_hdr hdr;
+#ifdef CONFIG_MAC80211_MESH
 	struct ieee80211s_hdr mesh_hdr;
+#endif
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;

-- 
Atul Sowani (sowani@gmail.com)
http://savannah.gnu.org/users/atul
------------------------------------------------------------------------
