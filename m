Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab2FHQA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:00:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:36858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab2FHQA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:00:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162933420"
Date: Sat, 9 Jun 2012 01:00:51 +0900
From: Fengguang Wu <fengguang.wu@intel.com>
To: sedat.dilek@gmail.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120608160051.GA1111@localhost>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
 <20120608154535.GA887@localhost>
 <CA+icZUVC86sBLNND08rNn6xhWqagfWdM7WvrvG+fcW+FHoFjbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUVC86sBLNND08rNn6xhWqagfWdM7WvrvG+fcW+FHoFjbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 05:51:48PM +0200, Sedat Dilek wrote:
> On Fri, Jun 8, 2012 at 5:45 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > On Fri, Jun 08, 2012 at 05:07:36PM +0200, Jan Kara wrote:
> >> On Fri 08-06-12 10:36:13, Ted Tso wrote:
> >> >
> >> > I can reproduce this fairly easily by using ext4 w/o a journal, running
> >> > under KVM with 1024megs memory, with fsstress (xfstests #13):
> >
> > Good catch, thanks!
> >
> >>   Argh, I wonder how come I didn't hit this. Does attached patch fix the
> >> problem?
> >
> >> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> >> index 8d2fb8c..41a3ccf 100644
> >> --- a/fs/fs-writeback.c
> >> +++ b/fs/fs-writeback.c
> >> @@ -664,6 +664,7 @@ static long writeback_sb_inodes(struct super_block *sb,
> >>                       /* Wait for I_SYNC. This function drops i_lock... */
> >>                       inode_sleep_on_writeback(inode);
> >>                       /* Inode may be gone, start again */
> >> +                     spin_lock(&wb->list_lock);
> >>                       continue;
> >>               }
> >
> > That looks like the fix. So I pushed it to writeback-for-next.
> > Thanks for the quick fixing!
> >
> 
> s/writeback-for-next/writeback-for-linus ?

I use the same branch for next and linus.. Before sending git pull
requests, I add a tag somewhere in the branch and ask Linus to pull
that tag :)

Thanks,
Fengguang
