Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2AKMGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:06:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63593 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab2AKMGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:06:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120104151632.05e6b3b0.akpm@linux-foundation.org>
References: <CAJd=RBBF=K5hHvEwb6uwZJwS4=jHKBCNYBTJq-pSbJ9j_ZaiaA@mail.gmail.com>
	<20111222163604.GB14983@tiehlicka.suse.cz>
	<CAJd=RBBY0sKdtdx9d8KXTchjaN6au0_hvMfE2+9JkdhvJe7eAw@mail.gmail.com>
	<20120104151632.05e6b3b0.akpm@linux-foundation.org>
Date: Wed, 11 Jan 2012 20:06:30 +0800
Message-ID: <CAJd=RBDOn22=CAFcEx9try8onsaHsweny_B1ZvnGJO-0h7eZAQ@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: undo change to page mapcount in fault handler
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 7:16 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 23 Dec 2011 21:00:41 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
>
>> Page mapcount should be updated only if we are sure that the page ends
>> up in the page table otherwise we would leak if we couldn't COW due to
>> reservations or if idx is out of bounds.
>
> It would be much nicer if we could run vma_needs_reservation() before
> even looking up or allocating the page.
>
> And afaict the interface is set up to do that: you run
> vma_needs_reservation() before allocating the page and then
> vma_commit_reservation() afterwards.
>
> But hugetlb_no_page() and hugetlb_fault() appear to have forgotten to
> run vma_commit_reservation() altogether.  Why isn't this as busted as
> it appears to be?

Hi Andrew

IIUC the two operations, vma_{needs, commit}_reservation, are folded in
alloc_huge_page(), need to break the pair?

Thanks
Hillf
