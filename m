Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1JLUm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:42:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64458 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1JLUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:42:27 -0400
Date: Wed, 12 Oct 2011 13:42:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: Clean up typo when copying user
 highpage
Message-Id: <20111012134224.786191ac.akpm@linux-foundation.org>
In-Reply-To: <20111012175148.GA27460@redhat.com>
References: <CAJd=RBBuwmcV8srUyPGnKUp=RPKvsSd+4BbLrh--aHFGC5s7+g@mail.gmail.com>
	<20111012175148.GA27460@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 19:51:48 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Oct 12, 2011 at 10:39:36PM +0800, Hillf Danton wrote:
> > Hi Andrea
> > 
> > When copying user highpage, the PAGE_SHIFT in the third parameter is a typo,
> > I think, and is replaced with PAGE_SIZE.
> 
> That looks correct. I wonder how it was not noticed yet. Because it
> can't go out of bound, it didn't risk to crash the kernel and it didn't
> not risk to expose random data to the cowing task. So it shouldn't
> have security implications as far as I can tell, but the app could
> malfunction and crash (userland corruption only).

Which architectures care about the copy_user_page() `vaddr' argument? 
mips, perhaps?  I suspect the intersection between those architectures
and archs-which-implement-hugepages is the empty set.

