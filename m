Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab2J2WRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:17:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:47317 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510Ab2J2Vgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: =?UTF-8?q?=5B=20026/101=5D=20Staging=3A=20android=3A=20binder=3A=20Allow=20using=20highmem=20for=20binder=20buffers?=
Date: Mon, 29 Oct 2012 14:34:39 -0700
Message-Id: <20121029213243.090313858@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arve Hjønnevåg <arve@android.com>

commit 585650dcec88e704a19bb226a34b6a7166111623 upstream.

The default kernel mapping for the pages allocated for the binder
buffers is never used. Set the __GFP_HIGHMEM flag when allocating
these pages so we don't needlessly use low memory pages that may
be required elsewhere.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -655,7 +655,7 @@ static int binder_update_page_range(stru
 		page = &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 
 		BUG_ON(*page);
-		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		*page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 		if (*page == NULL) {
 			pr_err("binder: %d: binder_alloc_buf failed "
 			       "for page at %p\n", proc->pid, page_addr);


