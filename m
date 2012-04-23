Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2DWVjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:39:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2DWVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:39:50 -0400
Date: Mon, 23 Apr 2012 14:39:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rajman Mekaco <rajman.mekaco@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: Re: [PATCH 1/1] mmap.c: find_vma: remove unnecessary if(mm) check
Message-Id: <20120423143948.01a0ac60.akpm@linux-foundation.org>
In-Reply-To: <1335015755-2881-1-git-send-email-rajman.mekaco@gmail.com>
References: <1335015755-2881-1-git-send-email-rajman.mekaco@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2012 19:12:35 +0530
Rajman Mekaco <rajman.mekaco@gmail.com> wrote:

> The if(mm) check is not required in find_vma, as the kernel
> code calls find_vma only when it is absolutely sure that the
> mm_struct arg to it is non-NULL.
> 
> Removing the if(mm) check and adding the a WARN_ONCE(!mm)
> for now.

Lets do this as well:

--- a/mm/mmap.c~mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix
+++ a/mm/mmap.c
@@ -1639,7 +1639,7 @@ struct vm_area_struct *find_vma(struct m
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (WARN_ON_ONCE(!mm))
+	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
 		return NULL;
 
 	/* Check the cache first. */

