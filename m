Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777Ab2DLUug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:50:36 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:60859 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab2DLUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:50:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1334263824!3692459!16
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: resource.c: local functions should not be exposed globally
Date: Thu, 12 Apr 2012 13:50:24 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204121350.24335.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function reallocate_resource is only referenced in this file and
should be marked static to prevent it from being exposed globally.

This quiets the sparse warning:

warning: symbol 'reallocate_resource' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/kernel/resource.c b/kernel/resource.c
index 7e8ea66..1e3031e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -470,7 +470,7 @@ static int find_resource(struct resource *root, struct resource *new,
  * @newsize: new size of the resource descriptor
  * @constraint: the size and alignment constraints to be met.
  */
-int reallocate_resource(struct resource *root, struct resource *old,
+static int reallocate_resource(struct resource *root, struct resource *old,
 			resource_size_t newsize,
 			struct resource_constraint  *constraint)
 {
