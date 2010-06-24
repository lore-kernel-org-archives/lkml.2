Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0FXPNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:13:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0FXPNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:13:43 -0400
Subject: Re: [patch 30/52] fs: icache lock lru/writeback lists
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624150908.GG10441@laptop>
References: <20100624030212.676457061@suse.de>
	 <20100624030730.419497214@suse.de> <1277369888.1875.929.camel@laptop>
	 <20100624150908.GG10441@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 17:13:32 +0200
Message-ID: <1277392412.1875.976.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 01:09 +1000, Nick Piggin wrote:
> On Thu, Jun 24, 2010 at 10:58:08AM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > > +       assert_spin_locked(&wb_inode_list_lock);
> > 
> > There's also lockdep_assert_held() which also validates we're the owner.
> 
> These locks should have such miniscule contention now that they
> effectively mean the same thing :) But no that's a good suggestion
> thanks. I guess _most_ assert_spin_locked could be changed over.

Probably, I just haven't felt like actually visiting all sites to
check ;-)
