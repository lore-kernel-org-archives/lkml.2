Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2EaT2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:28:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab2EaT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:28:31 -0400
Date: Thu, 31 May 2012 12:28:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: hughd@google.com, npiggin@gmail.com, cl@linux.com, lee.schermerhorn@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH v2] tmpfs not interleaving properly
Message-Id: <20120531122829.8c478372.akpm@linux-foundation.org>
In-Reply-To: <20120531143916.GA16162@gulag1.americas.sgi.com>
References: <20120531143916.GA16162@gulag1.americas.sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012 09:39:17 -0500
Nathan Zimmer <nzimmer@sgi.com> wrote:

> When tmpfs has the memory policy interleaved it always starts allocating at each
> file at node 0.  When there are many small files the lower nodes fill up
> disproportionately.
> This patch attempts to spread out node usage by starting files at nodes other
> then 0.  I disturbed the addr parameter since alloc_pages_vma will only use it
> when the policy is MPOL_INTERLEAVE.  Random was picked over using another
> variable which would require some sort of contention management.

The patch title is a bit scummy ;) It describes a kernel problem, not
the patch.  I renamed it to "tmpfs: implement NUMA node interleaving".

It looks nice and simple

> Cc: stable@vger.kernel.org

We could probably sneak this past Greg, but should we?  It's a feature
and a performance enhancement.  Such things are not normally added to
-stable.  If there were some nice performance improvements in workloads
which our users care about then I guess we could backport it.

But you've provided us with no measurements at all, hence no reason to
backport it.


