Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2GIK3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:29:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34572 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2GIK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:29:46 -0400
Date: Mon, 9 Jul 2012 15:58:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] uprobes: __replace_page() should not use
 page_address_in_vma()
Message-ID: <20120709102837.GC32393@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120624145936.GA23269@redhat.com>
 <20120624150021.GB23277@redhat.com>
 <20120706161857.GA9218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120706161857.GA9218@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070910-7408-0000-0000-00000698C409
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ------------------------------------------------------------------------------
> Subject: [PATCH v2 2/5] uprobes: __replace_page() should not use page_address_in_vma()
> 
> page_address_in_vma(old_page) in __replace_page() is ugly and wrong.
> The caller already knows the correct virtual address, this page was
> found by get_user_pages(vaddr).
> 
> However, page_address_in_vma() can actually fail if page->mapping was
> cleared by __delete_from_page_cache() after get_user_pages() returns.
> But this means the race with page reclaim, write_opcode() should not
> fail, it should retry and read this page again. Probably the race with
> remove_mapping() is not possible due to page_freeze_refs() logic, but
> afaics at least shmem_writepage()->shmem_delete_from_page_cache() can
> clear ->mapping.
> 
> We could change __replace_page() to return -EAGAIN in this case, but
> it would be better to simply use the caller's vaddr and rely on
> page_check_address().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

