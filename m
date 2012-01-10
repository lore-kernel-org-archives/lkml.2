Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2AJUqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:46:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab2AJUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:46:00 -0500
Date: Tue, 10 Jan 2012 12:45:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: hugetlb: undo change to page mapcount in fault
 handler
Message-Id: <20120110124558.a7303493.akpm@linux-foundation.org>
In-Reply-To: <20120104151632.05e6b3b0.akpm@linux-foundation.org>
References: <CAJd=RBBF=K5hHvEwb6uwZJwS4=jHKBCNYBTJq-pSbJ9j_ZaiaA@mail.gmail.com>
	<20111222163604.GB14983@tiehlicka.suse.cz>
	<CAJd=RBBY0sKdtdx9d8KXTchjaN6au0_hvMfE2+9JkdhvJe7eAw@mail.gmail.com>
	<20120104151632.05e6b3b0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012 15:16:32 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 23 Dec 2011 21:00:41 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
> 
> > Page mapcount should be updated only if we are sure that the page ends
> > up in the page table otherwise we would leak if we couldn't COW due to
> > reservations or if idx is out of bounds.
> 
> It would be much nicer if we could run vma_needs_reservation() before
> even looking up or allocating the page.
> 
> And afaict the interface is set up to do that: you run
> vma_needs_reservation() before allocating the page and then
> vma_commit_reservation() afterwards.
> 
> But hugetlb_no_page() and hugetlb_fault() appear to have forgotten to
> run vma_commit_reservation() altogether.  Why isn't this as busted as
> it appears to be?

ping?
