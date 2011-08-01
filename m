Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1HAFYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:24:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:10438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1HAFYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:24:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,298,1309762800"; 
   d="scan'208";a="36523191"
Date: Mon, 1 Aug 2011 13:24:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110801052414.GA21021@localhost>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110731234749.GQ5404@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 07:47:49AM +0800, Dave Chinner wrote:
> On Sun, Jul 31, 2011 at 11:10:14PM +0800, Wu Fengguang wrote:
> > On Sat, Jul 30, 2011 at 09:44:22PM +0800, Christoph Hellwig wrote:
> > > This patch fixes the hang for me.
> > 
> > Thanks. It'd be better to get the _simple and tested_ fix into 3.1-rc1.
> > (if anyone find major problems with the fix, please speak up)
> 
> Yes, I already have, a couple of hours before you sent this:
> 
> http://www.spinics.net/lists/linux-fsdevel/msg47357.html

Err I found it in my spam folder.. and added you to the white list :)

> We haven't found the root cause of the problem, and writeback cannot
> hold off grab_super_passive() because writeback only holds read
> locks on s_umount, just like grab_super_passive. So if
> grab_super_passive is failing, there is some other, not yet
> unidentified actor causing this problem....

Yeah sorry, I totally overlooked the read lock. Since Linus has
pointed out the possibility of read-write-read deadlock, I'll jump
to your more recent email for the root cause.

Thanks,
Fengguang
