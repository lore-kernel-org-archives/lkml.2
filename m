Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0HXNbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:31:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0HXNbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:31:04 -0400
Subject: Re: [patch 4/5] btrfs: add nofail variant of set_extent_dirty
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1008240348150.19596@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1008240348150.19596@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 15:30:55 +0200
Message-ID: <1282656655.2605.2746.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 03:50 -0700, David Rientjes wrote:
> Add set_extent_dirty_nofail().  This function is equivalent to
> set_extent_dirty(), except that it will never fail because of allocation
> failure and instead loop forever trying to allocate memory.
> 
> If the first allocation attempt fails, a warning will be emitted,
> including a call trace.  Subsequent failures will suppress this warning.
> 
> This was added as a helper function for documentation and auditability.
> No future callers should be added.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  fs/btrfs/extent-tree.c |    8 ++++----
>  fs/btrfs/extent_io.c   |   19 +++++++++++++++++++
>  fs/btrfs/extent_io.h   |    2 ++
>  3 files changed, 25 insertions(+), 4 deletions(-)

I'd much rather someone help mason to clean this up.
