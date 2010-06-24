Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0FXQTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:19:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60772 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0FXQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:19:51 -0400
Date: Thu, 24 Jun 2010 18:19:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 42/52] fs: icache per-cpu last_ino allocator
Message-ID: <20100624161949.GR578@basil.fritz.box>
References: <20100624030212.676457061@suse.de>
 <20100624030732.402670838@suse.de>
 <87tyosahia.fsf@basil.nowhere.org>
 <20100624155243.GI10441@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624155243.GI10441@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 01:52:43AM +1000, Nick Piggin wrote:
> 
> That's right. More or less it just requires alloc_inode to be exported,
> adding more branches in new_inode would not be a good way to go.

One test/branch shouldn't hurt much. 

> > I guess the main customer is sockets only.
> 
> I guess. Sockets and ram based filesystems. Interestingly I don't know
> really what it's for (in socket code it's mostly for reporting and
> hashing it seems). It sure isn't guaranteed to be unique.

Maybe it could be generated lazily on access for those?
I suppose stat on a socket is relatively rare.
The only problem is would need an accessor.

But ok out of scope.

> Well I think glibc will convert 64 bit stat struct to 32bit for
> old apps. It detects if the ino can't fit in 32 bits.

... and will fail the stat.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
