Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2FILHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:07:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:55848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2FILHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:07:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163324106"
Date: Sat, 9 Jun 2012 19:07:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120609110731.GB14726@localhost>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
 <20120608202840.GB1704@thunk.org>
 <20120608233728.GA7691@localhost>
 <20120609023804.GC14153@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120609023804.GC14153@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:38:04PM -0400, Theodore Ts'o wrote:
> On Sat, Jun 09, 2012 at 08:37:28AM +0900, Fengguang Wu wrote:
> > 
> > Here is the updated changelog:
> > 
> >         writeback: Fix lock imbalance in writeback_sb_inodes()
> > 
> >         Fix bug introduced by 169ebd90.  We have to have wb_list_lock locked when
> >         restarting writeback loop after having waited for inode writeback.
> > 
> >         Bug description by Ted Tso:
> >           
> >           I can reproduce this fairly easily by using ext4 w/o a journal, running
> >           under KVM with 1024megs memory, with fsstress (xfstests #13):
> 
> Not that it matters that much, but I typo'ed the description; sorry
> about that.  The KVM only had 1024k of memory....

1MB memory? How do you manage to boot it? Recently I tried running a
big fat kernel (with almost everything built in) that can easily OOM
(at boot time, before swapon) even given 256MB memory...

Thanks,
Fengguang
