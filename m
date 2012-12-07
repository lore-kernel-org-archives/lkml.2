Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424150Ab2LGBJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:09:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423002Ab2LGAza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:55:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 15/20] s390/mm: have 16 byte aligned struct pages
Date: Thu,  6 Dec 2012 16:54:30 -0800
Message-Id: <20121207005237.110422582@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005232.756641002@linuxfoundation.org>
References: <20121207005232.756641002@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 4bffbb3455372a26816e364fb4448810f7014452 upstream.

Select HAVE_ALIGNED_STRUCT_PAGE on s390, so that the slub allocator can make
use of compare and swap double for lockless updates. This increases the size
of struct page to 64 bytes (instead of 56 bytes), however the performance gain
justifies the increased size:

- now excactly four struct pages fit into a single cache line; the
  case that accessing a struct page causes two cache line loads
  does not exist anymore.
- calculating the offset of a struct page within the memmap array
  is only a simple shift instead of a more expensive multiplication.

A "hackbench 200 process 200" run on a 32 cpu system did show an 8% runtime
improvement.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -93,6 +93,7 @@ config S390
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
+	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH


