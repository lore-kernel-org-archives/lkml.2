Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762Ab2DLUod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:44:33 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:9474 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab2DLUob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:44:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1334263469!8367644!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: page-writeback.c: local functions should not be exposed globally
Date: Thu, 12 Apr 2012 13:44:20 -0700
User-Agent: KMail/1.9.9
CC: <linux-mm@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204121344.20613.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function global_dirtyable_memory is only referenced in this file and
should be marked static to prevent it from being exposed globally.

This quiets the sparse warning:

warning: symbol 'global_dirtyable_memory' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 26adea8..9dec97f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -204,7 +204,7 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
  * Returns the global number of pages potentially available for dirty
  * page cache.  This is the base value for the global dirty limits.
  */
-unsigned long global_dirtyable_memory(void)
+static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
