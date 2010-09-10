Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0IJRUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:20:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756010Ab0IJRUU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <1284092586-1179-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1284092586-1179-2-git-send-email-n-horiguchi@ah.jp.nec.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Sep 2010 10:19:24 -0700
Message-ID: <AANLkTikV9nXxMW8X9Wq+wGaJfzMEAmzTFrDNf8Aq4cTs@mail.gmail.com>
Subject: Re: [PATCH 1/4] hugetlb, rmap: always use anon_vma root pointer
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 9:23 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> This patch applies Andrea's fix given by the following patch into hugepage
> rmapping code:
>
>  commit 288468c334e98aacbb7e2fb8bde6bc1adcd55e05
>  Author: Andrea Arcangeli <aarcange@redhat.com>
>  Date:   Mon Aug 9 17:19:09 2010 -0700
>
> This patch uses anon_vma->root and avoids unnecessary overwriting when
> anon_vma is already set up.

Btw, why isn't the code in __page_set_anon_rmap() also doing this
cleaner version (ie a single "if (PageAnon(page)) return;" up front)?

The comments in that function are also some alien language translated
to english by some broken automatic translation service. Could
somebody clean up that function and come up with a comment that
actually parses as English and makes sense?

                                        Linus
