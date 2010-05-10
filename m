Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0EJWvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:51:50 -0400
Received: from kroah.org ([198.145.64.141]:32871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab0EJWvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:44 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:18 2010
Message-Id: <20100510223318.269846445@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Changli Gao <xiaosuo@gmail.com>, Patrick McHardy <kaber@trash.net>,
       David Rientjes <rientjes@google.com>
Subject: [012/117] flex_array: fix the panic when calling flex_array_alloc() without __GFP_ZERO
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

commit e59464c735db19619cde2aa331609adb02005f5b upstream.

memset() is called with the wrong address and the kernel panics.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/flex_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -99,7 +99,7 @@ struct flex_array *flex_array_alloc(int
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
-		memset(ret->parts[0], FLEX_ARRAY_FREE,
+		memset(&ret->parts[0], FLEX_ARRAY_FREE,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }


