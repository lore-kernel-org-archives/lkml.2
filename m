Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2FLQbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:31:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62802 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2FLQbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120612142012.GB20467@suse.de>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
 <1339406250-10169-6-git-send-email-kosaki.motohiro@gmail.com> <20120612142012.GB20467@suse.de>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 12 Jun 2012 12:31:29 -0400
Message-ID: <CAHGf_=omc4g_JHu+mr-HKmoH=juhcXKgPGOKamAOrJCWkbdEMQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] mempolicy: fix a memory corruption by refcount
 imbalance in alloc_pages_vma()
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why does dequeue_huge_page_vma() not need to be changed as well? It's
> currently using mpol_cond_put() but if there is a goto retry_cpuset then
> will it have not take an additional reference count and leak?

dequeue_huge_page_vma() also uses get_vma_policy() and mpol_cond_put()
pair. thus we don't need special concern.


> Would it be more straight forward to put the mpol_cond_put() and __mpol_put()
> calls after the "goto retry_cpuset" checks instead?

I hope to keep symmetric. Sane design prevent a lot of unintentional breakage.
Frankly says, now all caller assume the symmetric. It's natural.
