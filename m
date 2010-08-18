Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0HROZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:25:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:48911 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab0HROZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:25:35 -0400
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
In-Reply-To: <20100818140856.GE28417@balbir.in.ibm.com>
References: <201008160949.51512.knikanth@suse.de>
	 <201008171039.23701.knikanth@suse.de> <1282033475.1926.2093.camel@laptop>
	 <201008181452.05047.knikanth@suse.de> <1282125536.1926.3675.camel@laptop>
	 <20100818140856.GE28417@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 Aug 2010 16:25:18 +0200
Message-ID: <1282141518.1926.4048.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 19:38 +0530, Balbir Singh wrote:

> There is an ongoing effort to look at per-cgroup dirty limits and I
> honestly think it would be nice to do it at that level first. We need
> it there as a part of the overall I/O controller. As a specialized
> need it could handle your case as well. 

Well, it would be good to isolate that to the cgroup code. Also from
what I understood, the plan was to simply mark dirty inodes with a
cgroup and use that from writeout_inodes() to write out inodes
specifically used by that cgroup.

That is, on top of what Andrea Righi already proposed, which would
provide the actual per cgroup dirty limit (although the per-bdi
proportions applied to a cgroup limit aren't strictly correct, but that
seems to be something you'll have to live with, a per-bdi-per-cgroup
proportion would simply be accounting insanity).

That is a totally different thing than what was proposed.


