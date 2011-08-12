Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1HLNEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:04:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47436 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1HLNEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:04:50 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Aug 2011 15:04:19 +0200
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost> <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313154259.6576.42.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 19:20 +0200, Peter Zijlstra wrote:
> 
> Now all of the above would seem to suggest:
> 
>   dirty_ratelimit := ref_bw
> 
> However for that you use:
> 
>   if (pos_bw < dirty_ratelimit && ref_bw < dirty_ratelimit)
>         dirty_ratelimit = max(ref_bw, pos_bw);
> 
>   if (pos_bw > dirty_ratelimit && ref_bw > dirty_ratelimit)
>         dirty_ratelimit = min(ref_bw, pos_bw);
> 
> You have:
> 
>   pos_bw = dirty_ratelimit * pos_ratio
> 
> Which is ref_bw without the write_bw/dirty_bw factor, this confuses me..
> why are you ignoring the shift in output vs input rate there? 

Could you elaborate on this primary feedback loop? Its the one part I
don't feel I actually understand well.


