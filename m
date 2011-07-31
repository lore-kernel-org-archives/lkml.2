Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1GaXsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:48:01 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45273 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab1GaXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:47:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhADAKXnNU55LCkBgWdsb2JhbABBp14VAQEWJiWBQAEBAQEDAQI3HCMQCAMYLhQUEQMhE4dwvnEOhjQEkG+TAg
Date: Mon, 1 Aug 2011 09:47:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110731234749.GQ5404@dastard>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110731151014.GA23106@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 11:10:14PM +0800, Wu Fengguang wrote:
> On Sat, Jul 30, 2011 at 09:44:22PM +0800, Christoph Hellwig wrote:
> > This patch fixes the hang for me.
> 
> Thanks. It'd be better to get the _simple and tested_ fix into 3.1-rc1.
> (if anyone find major problems with the fix, please speak up)

Yes, I already have, a couple of hours before you sent this:

http://www.spinics.net/lists/linux-fsdevel/msg47357.html

We haven't found the root cause of the problem, and writeback cannot
hold off grab_super_passive() because writeback only holds read
locks on s_umount, just like grab_super_passive. So if
grab_super_passive is failing, there is some other, not yet
unidentified actor causing this problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
