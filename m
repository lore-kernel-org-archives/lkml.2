Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1HHOmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:42:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38715 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1HHOmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:42:02 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 08 Aug 2011 16:41:41 +0200
In-Reply-To: <20110808141128.GA22080@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312814501.10488.41.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 22:11 +0800, Wu Fengguang wrote:
> @@ -538,11 +538,6 @@ static unsigned long bdi_position_ratio(
>         goal = thresh - thresh / DIRTY_SCOPE;
>         origin = 4 * thresh;
>  
> -       if (unlikely(origin < limit && dirty > (goal + origin) / 2)) {
> -               origin = limit;                 /* auxiliary control line */
> -               goal = (goal + origin) / 2;
> -               pos_ratio >>= 1;
> -       }
>         pos_ratio = origin - dirty;
>         pos_ratio <<= BANDWIDTH_CALC_SHIFT;
>         do_div(pos_ratio, origin - goal + 1); 

So basically, pos_ratio = (4t - d) / (25/8)t, which if I'm not mistaken
comes out at 32/25 - 8d/25t. Which simply doesn't make sense at all. 


