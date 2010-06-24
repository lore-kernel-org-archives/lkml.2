Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0FXPJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:09:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab0FXPJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:09:11 -0400
Date: Fri, 25 Jun 2010 01:09:08 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 30/52] fs: icache lock lru/writeback lists
Message-ID: <20100624150908.GG10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030730.419497214@suse.de>
 <1277369888.1875.929.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277369888.1875.929.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 10:58:08AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > +       assert_spin_locked(&wb_inode_list_lock);
> 
> There's also lockdep_assert_held() which also validates we're the owner.

These locks should have such miniscule contention now that they
effectively mean the same thing :) But no that's a good suggestion
thanks. I guess _most_ assert_spin_locked could be changed over.


