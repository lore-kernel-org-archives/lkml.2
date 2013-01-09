Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab3AIVvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:51:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:41450 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992Ab3AIUhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 012/123] mm: highmem: export kmap_to_page for modules
Date: Wed,  9 Jan 2013 12:34:11 -0800
Message-Id: <20130109201500.098419143@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f0263d2d222e9e25f2587e51a9dc58c6fb2a9352 upstream.

Some virtio device drivers (9p) need to translate high virtual addresses
to physical addresses, which are inserted into the virtqueue for
processing by userspace.

This patch exports the kmap_to_page symbol, so that the affected drivers
can be compiled as modules.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/highmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -105,6 +105,7 @@ struct page *kmap_to_page(void *vaddr)
 
 	return virt_to_page(addr);
 }
+EXPORT_SYMBOL(kmap_to_page);
 
 static void flush_all_zero_pkmaps(void)
 {


