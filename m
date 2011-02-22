Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1BVUvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:51:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1BVUva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:51:30 -0500
Date: Tue, 22 Feb 2011 15:49:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] blk-throttle: track buffered and anonymous pages
Message-ID: <20110222204928.GH28269@redhat.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
 <1298394776-9957-5-git-send-email-arighi@develer.com>
 <AANLkTinD2ZH3hw_iqVpvMjMRbUkXMBgttjd2NevvYq9x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinD2ZH3hw_iqVpvMjMRbUkXMBgttjd2NevvYq9x@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 10:42:41AM -0800, Chad Talbott wrote:
> On Tue, Feb 22, 2011 at 9:12 AM, Andrea Righi <arighi@develer.com> wrote:
> > Add the tracking of buffered (writeback) and anonymous pages.
> ...
> > ---
> >  block/blk-throttle.c   |   87 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/blkdev.h |   26 ++++++++++++++-
> >  2 files changed, 111 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> > index 9ad3d1e..a50ee04 100644
> > --- a/block/blk-throttle.c
> > +++ b/block/blk-throttle.c
> ...
> > +int blk_throtl_set_anonpage_owner(struct page *page, struct mm_struct *mm)
> > +int blk_throtl_set_filepage_owner(struct page *page, struct mm_struct *mm)
> > +int blk_throtl_copy_page_owner(struct page *npage, struct page *opage)
> 
> It would be nice if these were named blk_cgroup_*.  This is arguably
> more correct as the id comes from the blkio subsystem, and isn't
> specific to blk-throttle.  This will be more important very shortly,
> as CFQ will be using this same cgroup id for async IO tracking soon.

Should this really be all part of blk-cgroup.c and not blk-throttle.c
so that it can be used by CFQ code also down the line? Anyway all this
is not throttle specific as such but blkio controller specific.

Though function naming convetion is not great in blk-cgroup.c But
functions either have blkio_ prefix or blkiocg_ prefix.

Functions which are not directly dealing with cgroups or in general
are called by blk-throttle.c and/or cfq-iosched.c I have marked as
prefixed with "blkio_". Functions which directly deal with cgroup stuff
and register with cgroup subsystem for this controller are generally
having "blkiocg_" prefix.

In this case probably we can use probably blkio_ prefix.

Thanks
Vivek
