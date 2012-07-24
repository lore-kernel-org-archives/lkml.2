Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2GXPGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:06:23 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:35994 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313Ab2GXPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:06:20 -0400
X-IronPort-AV: E=Sophos;i="4.77,646,1336341600"; 
   d="scan'208";a="167987675"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tony Olech <tony.olech@elandigitalsystems.com>
Cc: kernel-janitors@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/mmc/host/vub300.c: add missing usb_free_urb
Date: Tue, 24 Jul 2012 17:06:10 +0200
Message-Id: <1343142370-27876-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing usb_free_urb on failure path after usb_alloc_urb.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@km exists@
local idexpression e;
expression e1,e2,e3;
type T,T1;
identifier f;
@@

* e = usb_alloc_urb(...)
... when any
    when != e = e1
    when != e1 = (T)e
    when != e1(...,(T)e,...)
    when != &e->f
if(...) { ... when != e2(...,(T1)e,...)
                 when != e3 = e
                 when forall
(
             return <+...e...+>;
|
*             return ...;
) }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mmc/host/vub300.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 3135a1a..6c39bf1 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2358,9 +2358,9 @@ error5:
 	 * which is contained at the end of struct mmc
 	 */
 error4:
-	usb_free_urb(command_out_urb);
-error1:
 	usb_free_urb(command_res_urb);
+error1:
+	usb_free_urb(command_out_urb);
 error0:
 	return retval;
 }

