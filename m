Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965327Ab2JAXjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:39:40 -0400
Received: from 1wt.eu ([62.212.114.60]:35040 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab2JAW7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:53 -0400
Message-Id: <20121001225200.531889623@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 069/180] sparc64: Fix bootup crash on sun4v.
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

commit 9e0daff30fd7ecf698e5d20b0fa7f851e427cca5 upstream.

The DS driver registers as a subsys_initcall() but this can be too
early, in particular this risks registering before we've had a chance
to allocate and setup module_kset in kernel/params.c which is
performed also as a subsyts_initcall().

Register DS using device_initcall() insteal.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/sparc/kernel/ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 4a700f4..6a831bd 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -1242,4 +1242,4 @@ static int __init ds_init(void)
 	return vio_register_driver(&ds_driver);
 }
 
-subsys_initcall(ds_init);
+fs_initcall(ds_init);
-- 
1.7.2.1.45.g54fbc



