Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2IJMMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:12:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49647 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2IJMMA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 10 Sep 2012 08:12:00 -0400
Message-Id: <504DF52C020000780009A301@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:11:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Borislav Petkov" <borislav.petkov@amd.com>,
        <herbert@gondor.hengli.com.au>, <james.t.kukunas@linux.intel.com>,
        <neilb@suse.de>
Subject: [PATCH] add further __init annotations to crypto/xor.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow particularly do_xor_speed() to be discarded post-init.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 crypto/xor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.6-rc5/crypto/xor.c
+++ 3.6-rc5-sections-xor/crypto/xor.c
@@ -56,11 +56,11 @@ xor_blocks(unsigned int src_count, unsig
 EXPORT_SYMBOL(xor_blocks);
 
 /* Set of all registered templates.  */
-static struct xor_block_template *template_list;
+static struct xor_block_template *__initdata template_list;
 
 #define BENCH_SIZE (PAGE_SIZE)
 
-static void
+static void __init
 do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 {
 	int speed;



