Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1HaO5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:57:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab1HaO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:57:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 29/35] Hexagon: Add page table header files & etc.
Date: Wed, 31 Aug 2011 16:57:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org> <20110830190802.462665808@codeaurora.org>
In-Reply-To: <20110830190802.462665808@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311657.32735.arnd@arndb.de>
X-Provags-ID: V02:K0:WCBjKMaKXLlNPFKZccmFN3w9K0XQeohKbh5HGvXnxtG
 Z4EwrQLCLU9hFfe/BJJX/0wEj1iiReRku7evDvIiW7OSNlkQ7B
 7TLbhHF5RQ8JKKUeEM7g5EG1gOjO+/7ToWIPP4wpHxRH6+EQGj
 NewhoQA0UIDQ14OianoPciwgn4APePSbpyx35QBtu+bGCB9WIu
 vgmTPo8BSTVQkAlpldSbJez0lkKbS3moA5Qi2dhrFL+ryX+K3B
 beV72Ymh6cOZVKILmxrMnxVWS3FbcREJEYrTTHrBsMnsJOWtHG
 vjNDbjPt7RzfCnN66N/CRN+WDvwz4BBl2jCF9Rt8k3BDwDTEs3
 chTZEqtvc+Pn3b7Iz3yU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Removed highmem as we currently don't need it (and it didn't
> quite work).
>
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>

Apparently you haven't removed it completely yet:

>+/**
>+ * kunmap - unmaps a kernel mapping
>+ * @page: pointer to page struct
>+ *
>+ * If it's not in highmem, then you ain't unmapping anybody.
>+ *
>+ * If it is in highmem, it calls kunmap_high, which magically
>+ * removes the mapping or something.  Seems to only decrement pkmap_count
>+ * for the page.  If the pkmap_count was decremented to 1, that means it's
>+ * ready to be flushed.
>+ *
>+ * It also is responsible for waking anybody up that was waiting for a kmap
>+ * to free up.
>+ */
>+extern void kunmap_hexagon(struct page *page);
>+#define kunmap(p)      kunmap_hexagon((p))
>+
>+extern struct page *kmap_atomic_to_page_hexagon(void *ptr);
>+#define kmap_atomic_to_page(p) kmap_atomic_to_page_hexagon((p))
>+
>+extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
>+extern void __kunmap_atomic(void *);
>+
>+static inline void *__kmap_atomic(struct page *page)
>+{
>+       return kmap_atomic_prot(page, kmap_prot);
>+}

I think if you disable CONFIG_ARCH_HAS_KMAP you can use the trivial
functions provided by include/linux/highmem.h.

	Arnd
