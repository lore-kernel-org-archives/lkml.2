Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876Ab2HQHsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:48:05 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:59030
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab2HQHrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:47:07 -0400
X-IronPort-AV: E=Sophos;i="4.77,783,1336341600"; 
   d="scan'208";a="153240437"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-wimax@intel.com,
        wimax@linuxwimax.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/net/wimax/i2400m/fw.c: fix error return code
Date: Fri, 17 Aug 2012 09:46:56 +0200
Message-Id: <1345189618-13758-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345189618-13758-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345189618-13758-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret;
expression e1,e2;
@@

if (ret < 0)
 { ... return ret; }
 ... when != ret = e1
     when forall
*if(...)
 {
  ... when != ret = e2
* return ret;
 }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wimax/i2400m/fw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index 283237f..def12b3 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -326,8 +326,10 @@ int i2400m_barker_db_init(const char *_options)
 		unsigned barker;
 
 		options_orig = kstrdup(_options, GFP_KERNEL);
-		if (options_orig == NULL)
+		if (options_orig == NULL) {
+			result = -ENOMEM;
 			goto error_parse;
+		}
 		options = options_orig;
 
 		while ((token = strsep(&options, ",")) != NULL) {

