Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab0JRTjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:39:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961Ab0JRTjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:39:16 -0400
Date: Mon, 18 Oct 2010 12:37:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: pacman@kosh.dhis.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
Message-Id: <20101018123750.ef7d6d48.akpm@linux-foundation.org>
In-Reply-To: <20101018113331.GB30667@csn.ul.ie>
References: <20101013144044.GS30667@csn.ul.ie>
	<20101013175205.21187.qmail@kosh.dhis.org>
	<20101018113331.GB30667@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 12:33:31 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> A bit but I still don't know why it would cause corruption. Maybe this is still
> a caching issue but the difference in timing between list_add and list_add_tail
> is enough to hide the bug. It's also possible there are some registers
> ioremapped after the memmap array and reading them is causing some
> problem.
> 
> Andrew, what is the right thing to do here? We could flail around looking
> for explanations as to why the bug causes a user buffer corruption but never
> get an answer or do we go with this patch, preferably before 2.6.36 releases?

Well, you've spotted a bug so I'd say we fix it asap.

It's a bit of a shame that we lose the only known way of reproducing a
different bug, but presumably that will come back and bite someone else
one day, and we'll fix it then :(


