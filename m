Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0KSVxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:53:16 -0500
Received: from kroah.org ([198.145.64.141]:51753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab0KSVp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:26 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:10 2010
Message-Id: <20101119214410.572906410@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cliff Wickman <cpw@sgi.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Ingo Molnar <mingo@elte.hu>
Subject: [14/45] x86, kdump: Change copy_oldmem_page() to use cached addressing
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit 37a2f9f30a360fb03522d15c85c78265ccd80287 upstream.

The copy of /proc/vmcore to a user buffer proceeds much faster
if the kernel addresses memory as cached.

With this patch we have seen an increase in transfer rate from
less than 15MB/s to 80-460MB/s, depending on size of the
transfer. This makes a big difference in time needed to save a
system dump.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: kexec@lists.infradead.org
LKML-Reference: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/crash_dump_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -34,7 +34,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 


