Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1DMCTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:19:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43705 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1DMCTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:19:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/3] mm: add __nocast attribute to vm_flags
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <20110413084047.41DD.A69D9226@jp.fujitsu.com>
References: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com> <20110413084047.41DD.A69D9226@jp.fujitsu.com>
Message-Id: <20110413112002.41E8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 11:19:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > After next year? All developers don't have to ignore compiler warnings!
> > 
> > At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.
> 
> Good idea.

Alexy, I have to deeply thank you. Your suggestion help to find two
hidden vm_flags usage. (I'll post them as reply of this mail)

Now, i386 allyesconfig build doesn't detect nocast violation. Then, I
believe we don't have a big overlooking anymore.



>From 254787536ac871d313a02db5dfe8c539e0bbf605 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 13 Apr 2011 09:26:37 +0900
Subject: [PATCH 1/3] mm: add __nocast attribute to vm_flags

Now, We are converting vm_flags to 64bit. so nocast attribute help to
find hidden wrong vm_flags usage.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mm_types.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 4b0b990..ca01ab2 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -109,7 +109,7 @@ struct page {
  */
 struct vm_region {
 	struct rb_node	vm_rb;		/* link in global region tree */
-	unsigned long long vm_flags;	/* VMA vm_flags */
+	unsigned long long __nocast vm_flags;	/* VMA vm_flags */
 	unsigned long	vm_start;	/* start address of region */
 	unsigned long	vm_end;		/* region initialised to here */
 	unsigned long	vm_top;		/* region allocated to here */
@@ -137,7 +137,7 @@ struct vm_area_struct {
 	struct vm_area_struct *vm_next, *vm_prev;
 
 	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long long vm_flags;		/* Flags, see mm.h. */
+	unsigned long long __nocast vm_flags;	/* Flags, see mm.h. */
 
 	struct rb_node vm_rb;
 
-- 
1.7.3.1



