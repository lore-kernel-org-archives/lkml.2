Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1IWBBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:01:51 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:61256 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1IWBBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:01:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1316739705!28689081!4
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/mempolicy.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:01:40 -0700
User-Agent: KMail/1.9.9
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wilsons@start.ca>,
        <aarcange@redhat.com>, <mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221801.41253.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the spares noise:

warning: symbol 'default_policy' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>

---

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 905f202..b7667a7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -111,7 +111,7 @@ enum zone_type policy_zone = 0;
 /*
  * run-time system-wide default policy => local allocation
  */
-struct mempolicy default_policy = {
+static struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
 	.mode = MPOL_PREFERRED,
 	.flags = MPOL_F_LOCAL,
