Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1C1Q7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:59:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:32556 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab1C1Q7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:59:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,256,1299484800"; 
   d="scan'208";a="619972137"
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: avoid unnecessary anon_vma lock
References: <1301277532.3981.25.camel@sli10-conroe>
Date: Mon, 28 Mar 2011 09:57:39 -0700
In-Reply-To: <1301277532.3981.25.camel@sli10-conroe> (Shaohua Li's message of
	"Mon, 28 Mar 2011 09:58:52 +0800")
Message-ID: <m2fwq718u4.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> If we only change vma->vm_end, we can avoid taking anon_vma lock even 'insert'
> isn't NULL, which is the case of split_vma.
> From my understanding, we need the lock before because rmap must get the
> 'insert' VMA when we adjust old VMA's vm_end (the 'insert' VMA is linked to
> anon_vma list in __insert_vm_struct before).
> But now this isn't true any more. The 'insert' VMA is already linked to
> anon_vma list in __split_vma(with anon_vma_clone()) instead of
> __insert_vm_struct. There is no race rmap can't get required VMAs.
> So the anon_vma lock is unnecessary, and this can reduce one locking in brk
> case and improve scalability.

Looks good to me.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
