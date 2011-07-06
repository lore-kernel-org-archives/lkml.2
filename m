Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1GFXwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:52:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751Ab1GFXw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:52:28 -0400
Date: Wed, 6 Jul 2011 16:51:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/14] Swap-over-NBD without deadlocking v5
Message-Id: <20110706165146.be7ab61b.akpm@linux-foundation.org>
In-Reply-To: <1308575540-25219-1-git-send-email-mgorman@suse.de>
References: <1308575540-25219-1-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011 14:12:06 +0100
Mel Gorman <mgorman@suse.de> wrote:

> Swapping over NBD is something that is technically possible but not
> often advised. While there are number of guides on the internet
> on how to configure it and nbd-client supports a -swap switch to
> "prevent deadlocks", the fact of the matter is a machine using NBD
> for swap can be locked up within minutes if swap is used intensively.
> 
> The problem is that network block devices do not use mempools like
> normal block devices do. As the host cannot control where they receive
> packets from, they cannot reliably work out in advance how much memory
> they might need.
> 
> Some years ago, Peter Ziljstra developed a series of patches that
> supported swap over an NFS that some distributions are carrying in
> their kernels. This patch series borrows very heavily from Peter's work
> to support swapping over NBD (the relatively straight-forward case)
> and uses throttling instead of dynamically resized memory reserves
> so the series is not too unwieldy for review.

I have to say, I look over these patches and my mind wants to turn to
things like puppies.  And ice cream.

There's quite some complexity added here in areas which are already
reliably unreliable and afaik swap-over-NBD is not a thing which a lot
of people want to do.  I can see that swap-over-NFS would be useful to
some people, and the fact that distros are carrying swap-over-NFS
patches has weight.

Do these patches lead on to swap-over-NFS?  If so, how much more
additional complexity are we buying into for that?
