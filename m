Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab0DIEF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:05:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48820 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0DIEFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AdJ/k0/ZP4oF5AX6X1PNLhmdIYxLsA7AxZUt58INXuYyy6b8z8Cs+SZgAq0N6KzAuW
         yhz446CA0HvOkUAllfDwO8OfxFobIUAoGx+oPvx4ePSmaa9m9+AN6swXQhsK1Lp8Ansl
         olOi7XdvWtjMoP6jOywueuF5l+hap5HohRrfI=
Message-ID: <4BBEA79A.3020307@gmail.com>
Date: Fri, 09 Apr 2010 12:05:46 +0800
From: Changli Gao <xiaosuo@gmail.com>
Reply-To: xiaosuo@gmail.com
User-Agent: Thunderbird 2.0.0.23 (X11/20091022)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
Subject: [PATCH 1/3] flex_array: fix the panic issue when calling flex_array_alloc()
 without __GFP_ZERO
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the panic issue when calling flex_array_alloc() without __GFP_ZERO.

memset is called with the wrong address, then kernel panics.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
lib/flex_array.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
index 66eef2e..6fbb514 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -99,7 +99,7 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
-		memset(ret->parts[0], FLEX_ARRAY_FREE,
+		memset(&ret->parts[0], FLEX_ARRAY_FREE,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }


