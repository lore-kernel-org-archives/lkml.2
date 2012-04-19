Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab2DSVJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:09:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091Ab2DSVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:45 -0400
Message-Id: <20120419210612.219220137@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [ 13/59] sparc64: Fix bootup crash on sun4v.
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 9e0daff30fd7ecf698e5d20b0fa7f851e427cca5 upstream.

The DS driver registers as a subsys_initcall() but this can be too
early, in particular this risks registering before we've had a chance
to allocate and setup module_kset in kernel/params.c which is
performed also as a subsyts_initcall().

Register DS using device_initcall() insteal.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/kernel/ds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -1269,4 +1269,4 @@ static int __init ds_init(void)
 	return vio_register_driver(&ds_driver);
 }
 
-subsys_initcall(ds_init);
+fs_initcall(ds_init);


