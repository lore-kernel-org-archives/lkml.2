Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2EaGUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:20:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101Ab2EaGUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:20:46 -0400
Message-ID: <1338445233.19369.21.camel@cr0>
Subject: Re: [RFC Patch] fs: implement per-file drop caches
From: Cong Wang <amwang@redhat.com>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Date: Thu, 31 May 2012 14:20:33 +0800
In-Reply-To: <4FC6393B.7090105@draigBrady.com>
References: <1338385120-14519-1-git-send-email-amwang@redhat.com>
	 <4FC6393B.7090105@draigBrady.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 16:14 +0100, Pádraig Brady wrote:
> On 05/30/2012 02:38 PM, Cong Wang wrote:
> > This is a draft patch of implementing per-file drop caches.
> > 
> > It introduces a new fcntl command  F_DROP_CACHES to drop
> > file caches of a specific file. The reason is that currently
> > we only have a system-wide drop caches interface, it could
> > cause system-wide performance down if we drop all page caches
> > when we actually want to drop the caches of some huge file.
> 
> This is useful functionality.
> Though isn't it already provided with POSIX_FADV_DONTNEED?

Thanks for teaching this!

However, from the source code of madvise_dontneed() it looks like it is
using a totally different way to drop page caches, that is to invalidate
the page mapping, and trigger a re-mapping of the file pages after a
page fault. So, yeah, this could probably drop the page caches too (I am
not so sure, haven't checked the code in details), but with my patch, it
flushes the page caches directly, what's more, it can also prune
dcache/icache of the file.

Cheers.


