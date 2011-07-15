Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1GOSYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:24:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1GOSYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:24:50 -0400
Subject: RE: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Shan Hai <haishan.bai@gmail.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 12:39:30 +0200
Message-ID: <1310726370.2586.312.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 11:32 +0100, David Laight wrote:
> > The fault causing futex_atomic_cmpxchg_inatomic() is
> > protected by pagefault_disable(), so the page fault handler has
> > no chance to toggle the SW dirty/young tracking.
> 
> Perhaps that is the bug!
> Whatever pagefault_disable() does, it shouldn't disable the
> SW dirty/young tracking - which should only needs bits moving
> in the page table itself (and TLB update??) rather than any
> operations on the rest of the data areas.
> 
> It looks to me as though this could happen any time a page
> is marked inaccessible by the dirty/young tracking.
> Not just as a result of COW.

I've thought of that as well, but couldn't find the actual code in the
ppc fault bits. It could be it relies on vma information to know what it
should allow due to lack of bits in the pte.

If it requires the vma, it requires mmap_sem and it thus has to avoid
the whole thing when pagefault_disabled().
