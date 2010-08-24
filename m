Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0HXCat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:30:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:63871 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0HXCaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:30:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,260,1280732400"; 
   d="scan'208";a="650568050"
Date: Tue, 24 Aug 2010 10:30:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_entered_writeback in
 /proc/vmstat
Message-ID: <20100824023028.GA9005@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-4-git-send-email-mrubin@google.com>
 <20100820100855.GC8440@localhost>
 <AANLkTi=+uNFq5=5gmjfAOhngXqR8RS3dX3E2uEWG33Ot@mail.gmail.com>
 <20100821004804.GA11030@localhost>
 <AANLkTim4NZrV18a2LYpyTz9+MSBgVw6KKo4tCUmu9GHZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim4NZrV18a2LYpyTz9+MSBgVw6KKo4tCUmu9GHZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 01:45:41AM +0800, Michael Rubin wrote:
> On Fri, Aug 20, 2010 at 5:48 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > I wonder if you'll still stick to the fake NUMA scenario two years
> > later -- when memcg grows powerful enough. What do we do then? "Hey
> > let's rip these counters, their major consumer has dumped them.."
> 
> I think the counters will still be useful for NUMA also. Is there a
> performance hit here I am missing to having the per node counters?
> Just want to make sure we are only wondering about whether or not we
> are polluting the interface? Also since we plan to change the name to
> vmstat instead doesn't that make it more generic in the future?

It's about the interface, I don't mind you adding the per-node vmstat
entries which may be convenient for you and mostly harmless to others.

My concern is, what do you think about the existing
/proc/<pid>/io:write_bytes interface and is it good enough for your?
You'll have to iterate through tasks to collect numbers for one job or
for the whole system, however that should be easy and more flexible?

Thanks,
Fengguang
