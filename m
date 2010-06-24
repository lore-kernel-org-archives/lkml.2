Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0FXQjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:39:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab0FXQjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:39:08 -0400
Date: Fri, 25 Jun 2010 02:38:59 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 42/52] fs: icache per-cpu last_ino allocator
Message-ID: <20100624163859.GN10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030732.402670838@suse.de>
 <87tyosahia.fsf@basil.nowhere.org>
 <20100624155243.GI10441@laptop>
 <20100624161949.GR578@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624161949.GR578@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 06:19:49PM +0200, Andi Kleen wrote:
> On Fri, Jun 25, 2010 at 01:52:43AM +1000, Nick Piggin wrote:
> > 
> > That's right. More or less it just requires alloc_inode to be exported,
> > adding more branches in new_inode would not be a good way to go.
> 
> One test/branch shouldn't hurt much. 

If we go through filesystems anyway may as well just use alloc_inode.

 
> > > I guess the main customer is sockets only.
> > 
> > I guess. Sockets and ram based filesystems. Interestingly I don't know
> > really what it's for (in socket code it's mostly for reporting and
> > hashing it seems). It sure isn't guaranteed to be unique.
> 
> Maybe it could be generated lazily on access for those?
> I suppose stat on a socket is relatively rare.
> The only problem is would need an accessor.
> 
> But ok out of scope.

Yea that might work. sock_i_ino() and ->dname covers a lot.


> > Well I think glibc will convert 64 bit stat struct to 32bit for
> > old apps. It detects if the ino can't fit in 32 bits.
> 
> ... and will fail the stat.

Which is what we're trying to avoid, I guess.

