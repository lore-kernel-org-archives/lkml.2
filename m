Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0EEGtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 02:49:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45203 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0EEGs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 02:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=n5kqIQ5Ydtkv9fajRv5T32FkYSBHveGdD72kmJ7A+IKVYKyThbtv92FPydtIcd/mOe
         8f9pzB27HYNP4S9W5+xrAXmDw4gTPClUhgZJPSQIEik50YnD1CjfNsSGtqaiyEiHkgdz
         tpvAvwOxXA0WxVRwQS17dkoguOLyFAOkxgvJo=
Date: Wed, 5 May 2010 14:56:52 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@suse.de
Subject: [PATCH] Staging: Check kmalloc return value before use the buffer in ieee80211_softmac.c
Message-ID: <20100505065652.GB7495@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check kmalloc return value before use the buffer.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 27d9257..8718ac9 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1579,6 +1579,8 @@ static inline u16 auth_parse(struct sk_buff *skb, u8** challenge, int *chlen)
 		if(*(t++) == MFIE_TYPE_CHALLENGE){
 			*chlen = *(t++);
 			*challenge = (u8*)kmalloc(*chlen, GFP_ATOMIC);
+			if (!*challenge)
+				return -ENOMEM;
 			memcpy(*challenge, t, *chlen);
 		}
 	}
-- 
1.6.5.3

