Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2ARXsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:48:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65513 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2ARXsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:48:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120119103626.a9b21533cf30da57ddc54947@canb.auug.org.au>
References: <20120119103626.a9b21533cf30da57ddc54947@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jan 2012 15:47:50 -0800
X-Google-Sender-Auth: uVRwEo6eHHodyMCX4_MMepn4Y5g
Message-ID: <CA+55aFyNcD0n9xj5CjGZ9szQQYqGCNtbpXLGctkPZCh6ZdhDYw@mail.gmail.com>
Subject: Re: linux-next: build warning in Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 3:36 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Building Linus' tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
>
> drivers/block/nvme.c: In function 'nvme_alloc_ns':
> drivers/block/nvme.c:1336:2: warning: passing argument 2 of 'blk_queue_make_request' from incompatible pointer type [enabled by default]
> include/linux/blkdev.h:830:13: note: expected 'void (*)(struct request_queue *, struct bio *)' but argument is of type 'int (*)(struct request_queue *, struct bio *)'

That's a merge error of mine, resulting from a non-conflicting semantics change.

The type of make_request_fn has changed to void, but the nvme driver
was based on the older version.

It's benign in that in the absence of truly crazy calling conventions
it has no relevance apart from unnecessarily clearing the return value
that now doesn't exist and isn't used, but the warning is clearly
annoying.

I pushed out the obvious fix.

                     Linus
