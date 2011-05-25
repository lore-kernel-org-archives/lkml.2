Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1EYUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:32:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45783 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1EYUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iLPr2IQ3k9eldNCrTMsTKQfyiS5BG6RsDf8Wu8aqbxicQEdnrelWkM4MSudBpYJ/ne
         es0LlLRtA65WfJuX6hMvyk3GNLKckjKVyiH0vTDIgyKu++vRIIcAvOMktvFjf/l596z9
         6xb7QKrn/Gwymyvj6sIPwFAijdINP6akUQ+XE=
Date: Wed, 25 May 2011 22:31:58 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: minchan.kim@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: [PATCH v2] set_migratetype_isolate: remove unused variable.
Message-ID: <20110525203128.GA16833@nb-core2.darkstar.lan>
References: <20110524133414.GA11674@nb-core2.darkstar.lan>
 <BANLkTikEz0k8WTCAW9x7dYK2i3mm4c7tLA@mail.gmail.com>
 <BANLkTi=X1APdoMPE-P+xr-ADv8ivx90z-g@mail.gmail.com>
 <4DDCB160.8040009@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDCB160.8040009@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_idx is never read inside the function.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9d5498e..bcbdaf1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5508,10 +5508,8 @@ int set_migratetype_isolate(struct page *page)
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
-	int zone_idx;
 
 	zone = page_zone(page);
-	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
 
-- 
1.7.5.1
