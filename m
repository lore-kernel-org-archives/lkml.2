Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0JaBvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 21:51:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:2156 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0JaBvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 21:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,266,1286175600"; 
   d="scan'208";a="852597078"
Date: Sun, 31 Oct 2010 09:51:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Aidar Kultayev <the.aidar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101031015132.GA10086@localhost>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
 <AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
 <AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
 <AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
 <20101031012224.GA8007@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101031012224.GA8007@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How do I notice slowdowns ? The JuK lags so badly that it can't play
> > any music, the mouse pointer freezes, kwin effects freeze for few
> > seconds.

> > How can I make it much worse ? I can try & run disk clean up under XP,
> > that is running in VBox, with folder compression. On top of it if I
> > start copying big files in linux ( 700MB avis, etc ), GUI effects
> > freeze, mouse pointer freezes for few seconds.

It may also help to lower the dirty ratio.

echo 5 > /proc/sys/vm/dirty_ratio

Memory pressure + heavy write can easily hurt responsiveness.

- eats up to 20% (the default value for dirty_ratio) memory with dirty
  pages and hence increase the memory pressure and number of swap IO

- the file copy makes the device write congested and hence makes
  pageout() easily blocked in get_request_wait()

As a result every application may be slowed down by the heavy swap IO
when page fault as well as being blocked when allocating memory (which
may go into direct reclaim and then call pageout()). 

Thanks,
Fengguang
