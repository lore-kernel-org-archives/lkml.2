Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1G0VOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:14:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839Ab1G0VOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:14:49 -0400
Date: Wed, 27 Jul 2011 14:14:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Ehrenberg <dehrenberg@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dio: Fast-path for page-aligned IOs
Message-Id: <20110727141415.a67cafb8.akpm@linux-foundation.org>
In-Reply-To: <20110727210828.GB12714@infradead.org>
References: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
	<20110727210828.GB12714@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 17:08:28 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jun 20, 2011 at 04:17:35PM -0700, Dan Ehrenberg wrote:
> > The fast path does not apply for operations of the wrong size
> > or alignmnent, or for operations on raw drives with 512-byte sectors.
> > It might be possible to make this special case a little more general
> > while maintaining its performance benefits, but I do not believe that
> > the full performance benefits can be achieved without resorting to
> > special handling of simple cases, as is done in this patch.
> 
> Did you check how this compares to Andis small optimizations?
> 
> Also operations on raw disks are something people with fast devices
> care about a lot.  We often hear about benchmark regressions due to
> stupid little things in the direct I/O code.
> 
> If we want to special case something that would be a very easy target,
> with a 1:1 mapping of logical to physical blocks and thus no need
> to call the allocator first, and no need for any kind of locking
> or alignment handling.

Ken did this back in 2006
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e61c90188b9956edae1105eef361d8981a352fcd)
but we reverted that shortly afterwards for some reason.

