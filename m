Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0J0RrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab0J0RrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:47:11 -0400
Message-ID: <4CC86587.6010506@redhat.com>
Date: Wed, 27 Oct 2010 13:46:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFT][PATCH] mm: Fix race in kunmap_atomic()
References: <20101027125154.GA23679@infradead.org> <1288191261.15336.1953.camel@twins>
In-Reply-To: <1288191261.15336.1953.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 10:54 AM, Peter Zijlstra wrote:

> Christoph reported a nice splat which illustrated a race in the new
> stack based kmap_atomic implementation.
>
> The problem is that we pop our stack slot before we're completely done
> resetting its state -- in particular clearing the PTE (sometimes that's
> CONFIG_DEBUG_HIGHMEM). If an interrupt happens before we actually clear
> the PTE used for the last slot, that interrupt can reuse the slot in a
> dirty state, which triggers a BUG in kmap_atomic().
>
> Fix this by introducing kmap_atomic_idx() which reports the current slot
> index without actually releasing it and use that to find the PTE and
> delay the _pop() until after we're completely done.
>
> Reported-by: Christoph Hellwig<hch@infradead.org>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
