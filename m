Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0H0KkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:40:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:33111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab0H0KkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:40:02 -0400
Subject: Re: [PATCH] writeback: remove the internal 5% low bound on
 dirty_ratio
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Brown <neilb@suse.de>, Con Kolivas <kernel@kolivas.org>,
        Jan Kara <jack@suse.cz>, Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
In-Reply-To: <20100827103603.GB6237@localhost>
References: <20100827103603.GB6237@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 12:39:39 +0200
Message-ID: <1282905579.1975.2141.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 18:36 +0800, Wu Fengguang wrote:
> The dirty_ratio was siliently limited in global_dirty_limits() to >= 5%.
> This is not a user expected behavior. And it's inconsistent with
> calc_period_shift(), which uses the plain vm_dirty_ratio value.
> 
> Let's rip the internal bound.
> 
> At the same time, fix balance_dirty_pages() to work with the
> dirty_thresh=0 case. This allows applications to proceed when
> dirty+writeback pages are all cleaned.
> 
> And ">" fits with the name "exceeded" better than ">=" does. Neil
> think it is an aesthetic improvement as well as a functional one :)
> 
> CC: Jan Kara <jack@suse.cz>
> CC: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Proposed-by: Con Kolivas <kernel@kolivas.org>
> Reviewed-by: Neil Brown <neilb@suse.de>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

