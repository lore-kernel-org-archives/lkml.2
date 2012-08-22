Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2HVVXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:23:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55263 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2HVVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:23:17 -0400
Date: Wed, 22 Aug 2012 14:22:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 19/36] autonuma: memory follows CPU algorithm and
 task/mm_autonuma stats collection
In-Reply-To: <m2sjbe7k93.fsf@firstfloor.org>
Message-ID: <alpine.LSU.2.00.1208221414450.2114@eggly.anvils>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com> <1345647560-30387-20-git-send-email-aarcange@redhat.com> <m2sjbe7k93.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Andi Kleen wrote:
> Andrea Arcangeli <aarcange@redhat.com> writes:
> > +		/*
> > +		 * Take the lock with irqs disabled to avoid a lock
> > +		 * inversion with the lru_lock. The lru_lock is taken
> > +		 * before the autonuma_migrate_lock in
> > +		 * split_huge_page. If we didn't disable irqs, the
> > +		 * lru_lock could be taken by interrupts after we have
> > +		 * obtained the autonuma_migrate_lock here.
> > +		 */
> 
> Which interrupt code takes the lru_lock? That sounds like a bug.

Not a bug: the clearest example is end_page_writeback() calling
rotate_reclaimable_page(); but I think once you probe deeper, you
find some other mm/swap.c pagevec operations which may get called
from interrupt, and end up freeing unrelated PageLRU pages.

Hugh
