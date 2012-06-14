Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2FOAKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:10:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2FNX6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:40 -0400
Message-Id: <20120614235645.845201712@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Minchan Kim <minchan@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [ 18/20] mm/vmalloc.c: change void* into explict vm_struct*
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit db1aecafef58b5dda39c4228debe2c845e4a27ab upstream.

vmap_area->private is void* but we don't use the field for various purpose
but use only for vm_struct.  So change it to a vm_struct* with naming to
improve for readability and type checking.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -256,7 +256,7 @@ struct vmap_area {
 	struct rb_node rb_node;		/* address sorted rbtree */
 	struct list_head list;		/* address sorted list */
 	struct list_head purge_list;	/* "lazy purge" list */
-	void *private;
+	struct vm_struct *vm;
 	struct rcu_head rcu_head;
 };
 
@@ -1274,7 +1274,7 @@ static void setup_vmalloc_vm(struct vm_s
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
-	va->private = vm;
+	va->vm = vm;
 	va->flags |= VM_VM_AREA;
 }
 
@@ -1397,7 +1397,7 @@ static struct vm_struct *find_vm_area(co
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA)
-		return va->private;
+		return va->vm;
 
 	return NULL;
 }
@@ -1416,7 +1416,7 @@ struct vm_struct *remove_vm_area(const v
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA) {
-		struct vm_struct *vm = va->private;
+		struct vm_struct *vm = va->vm;
 
 		if (!(vm->flags & VM_UNLIST)) {
 			struct vm_struct *tmp, **p;


