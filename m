Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769Ab2FHXhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 19:37:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:3257 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab2FHXhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 19:37:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163114918"
Date: Sat, 9 Jun 2012 08:37:28 +0900
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120608233728.GA7691@localhost>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
 <20120608202840.GB1704@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608202840.GB1704@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:28:40PM -0400, Theodore Ts'o wrote:
> On Fri, Jun 08, 2012 at 05:07:36PM +0200, Jan Kara wrote:
> >   Argh, I wonder how come I didn't hit this. Does attached patch fix the
> > problem?
> 
> Just to confirm (although there was little doubt), I've built a kernel
> with this patch and it fixes the lockdep complaint.

Great, thank you!

Here is the updated changelog:

        writeback: Fix lock imbalance in writeback_sb_inodes()

        Fix bug introduced by 169ebd90.  We have to have wb_list_lock locked when
        restarting writeback loop after having waited for inode writeback.

        Bug description by Ted Tso:
          
          I can reproduce this fairly easily by using ext4 w/o a journal, running
          under KVM with 1024megs memory, with fsstress (xfstests #13):
          
          [   45.153294] =====================================
          [   45.154784] [ BUG: bad unlock balance detected! ]
          [   45.155591] 3.5.0-rc1-00002-gb22b1f1 #124 Not tainted
          [   45.155591] -------------------------------------
          [   45.155591] flush-254:16/2499 is trying to release lock (&(&wb->list_lock)->rlock) at:
          [   45.155591] [<c022c3da>] writeback_sb_inodes+0x160/0x327
          [   45.155591] but there are no more locks to release!

        Reported-by: Theodore Ts'o <tytso@mit.edu>
        Tested-by: Theodore Ts'o <tytso@mit.edu>
        Signed-off-by: Jan Kara <jack@suse.cz>
        Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks,
Fengguang
