Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0FCSMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:12:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab0FCSMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:12:41 -0400
Date: Thu, 3 Jun 2010 11:11:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Doan <dougd@cray.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "rientjes@google.com" <rientjes@google.com>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>, Andrea Arcangeli <andrea@redhat.com>
Subject: Re: [PATCH] hugetlb: call mmu notifiers on hugepage cow
Message-Id: <20100603111125.8cd6a787.akpm@linux-foundation.org>
In-Reply-To: <4C07E800.5010701@cray.com>
References: <4BFED954.8060807@cray.com>
	<20100601231600.3b3bf499.akpm@linux-foundation.org>
	<4C06E5A6.6@cray.com>
	<20100602163346.b8f8b8a4.akpm@linux-foundation.org>
	<4C07E800.5010701@cray.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 10:36:00 -0700
Doug Doan <dougd@cray.com> wrote:

> > Well, specifically it means that
> > mmu_notifier_invalidate_range_start/end() implemetnations can no longer
> > take page_table_lock or any lock which nests outside page_table_lock.
> > That lessens flexibility.
> >
> > As the other mmu_notifier_invalidate_range_start/end() callsite in this
> > function carefully nested those calls outside page_table_lock, perhaps
> > that was thought to be a significant thing.
> 
> Here's my rationale: for the normal page case, the invalidation call is done 
> inside a page_table_lock,

It is?  Where does that happen?

> so the same should also be done in the huge page case. 
> Does it really make sense to call invalidation on one hugepage and have another 
> call invalidate the same hugepage while the first call is still not finished?
