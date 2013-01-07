Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3AGDim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 22:38:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48216 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3AGDik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 22:38:40 -0500
Date: Sun, 6 Jan 2013 19:38:35 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: oops in copy_page_rep()
In-Reply-To: <20130107003718.GA1336@redhat.com>
Message-ID: <alpine.LNX.2.00.1301061928450.9484@eggly.anvils>
References: <20130105152208.GA3386@redhat.com> <CA+55aFwkP=nA32pBO0gNm51nPxqWiq1e1zWzGEJoVQ1gP=CgDQ@mail.gmail.com> <20130107003718.GA1336@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2013, Dave Jones wrote:
> 
> investigating the huge page theory a little further I'm a bit confused.
> The kernel on that machine has THP enabled, and the cpu supports it (an old amd64), but..
> 
> $ cat /sys/kernel/mm/hugepages/hugepages-2048kB/*
> 0
> 0
> 0
> 0
> 0
> 0
> 
> I was expecting at least one of those to be non-zero.
> 
> /sys/kernel/mm/transparent_hugepage/khugepaged/full_scans and pages_collapsed
> are both non-zero, so it's been busy doing _something_.
> 
> Is this expected behaviour ?

Yes.  /sys/kernel/mm/hugepages/ is all about those dusty old opaque
hugepages you might have got from fs/hugetlbfs and mm/hugetlb.c; whereas
the splitting issue we suspect is peculiar to the dazzling new transparent
hugepages you get from mm/huge_memory.c.

Hugh
