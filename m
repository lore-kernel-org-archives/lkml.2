Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0IJVu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 17:50:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0IJVu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 17:50:28 -0400
Date: Fri, 10 Sep 2010 23:50:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] hugetlb, rmap: always use anon_vma root pointer
Message-ID: <20100910235022.74ec04de@basil.nowhere.org>
In-Reply-To: <AANLkTikV9nXxMW8X9Wq+wGaJfzMEAmzTFrDNf8Aq4cTs@mail.gmail.com>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1284092586-1179-2-git-send-email-n-horiguchi@ah.jp.nec.com>
	<AANLkTikV9nXxMW8X9Wq+wGaJfzMEAmzTFrDNf8Aq4cTs@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 10:19:24 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Sep 9, 2010 at 9:23 PM, Naoya Horiguchi
> <n-horiguchi@ah.jp.nec.com> wrote:
> > This patch applies Andrea's fix given by the following patch into
> > hugepage rmapping code:
> >
> >  commit 288468c334e98aacbb7e2fb8bde6bc1adcd55e05
> >  Author: Andrea Arcangeli <aarcange@redhat.com>
> >  Date:   Mon Aug 9 17:19:09 2010 -0700
> >
> > This patch uses anon_vma->root and avoids unnecessary overwriting
> > when anon_vma is already set up.
> 
> Btw, why isn't the code in __page_set_anon_rmap() also doing this
> cleaner version (ie a single "if (PageAnon(page)) return;" up front)?

Perhaps I misunderstand the question, but __page_set_anon_rmap
should handle Anon pages, shouldn't it?

> 
> The comments in that function are also some alien language translated
> to english by some broken automatic translation service. Could
> somebody clean up that function and come up with a comment that
> actually parses as English and makes sense?

I'll do that.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
