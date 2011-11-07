Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1KGPdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:33:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1KGPdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:33:01 -0500
Date: Mon, 7 Nov 2011 16:32:20 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nai Xia <nai.xia@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mremap: skip page table lookup for non-faulted anonymous
 VMAs
Message-ID: <20111107153220.GD3249@redhat.com>
References: <201111071221.35403.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111071221.35403.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 12:21:35PM +0800, Nai Xia wrote:
> If an anonymous vma has not yet been faulted, move_page_tables() in move_vma()
> is not necessary for it.

I actually thought of adding that (in fact fork has it and it's more
likely to be beneficial for fork than for mremap I suspect), but this
adds a branch to the fast path for a case that shouldn't normally
materialize. So I don't think it's worth adding it as I expect it to
add overhead in average.
