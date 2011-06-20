Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1FTTmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:42:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab1FTTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:42:38 -0400
Date: Mon, 20 Jun 2011 21:42:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p2 0/4] SLUB: [RFC] Per cpu partial lists V2
Message-ID: <20110620194236.GA32765@one.firstfloor.org>
References: <20110620153244.214038140@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620153244.214038140@linux.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 10:32:44AM -0500, Christoph Lameter wrote:
> The following patchset applied on top of the lockless patchset V7. It
> introduces per cpu partial lists which allow a performance increase of
> around ~15 during contention for the nodelock (can be tested using
> hackbench).

What size system did you test it on?
> 
> These lists help to avoid per nodelocking overhead. Allocator latency
> could be further reduced by making these operations work without
> disabling interrupts (like the fastpath and the free slowpath) as well as
> implementing better ways of handling ther cpu array with partial pages.

I think we really need better batching for the transfers.

-andi
-- 
ak@linux.intel.com -- Speaking for myself only.
