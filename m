Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0FXH6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:58:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0FXH6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:58:14 -0400
Subject: Re: [patch 16/52] fs: dcache RCU for multi-step operaitons
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624030728.129875799@suse.de>
References: <20100624030212.676457061@suse.de>
	 <20100624030728.129875799@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 09:58:10 +0200
Message-ID: <1277366290.1875.891.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> plain text document attachment (fs-dcache_lock-multi-step.patch)
> The remaining usages for dcache_lock is to allow atomic, multi-step read-side
> operations over the directory tree by excluding modifications to the tree.
> Also, to walk in the leaf->root direction in the tree where we don't have
> a natural d_lock ordering.
> 
> This could be accomplished by taking every d_lock, but this would mean a
> huge number of locks and actually gets very tricky.
> 
> Solve this instead by using the rename seqlock for multi-step read-side
> operations. Insert operations are not serialised. Delete operations are
> tricky when walking up the directory our parent might have been deleted
> when dropping locks so also need to check and retry for that.
> 
> XXX: hmm, we could of course just take the rename lock if there is any worry
> about livelock. Most of these are slow paths.


Ah, does this address John's issue? 
