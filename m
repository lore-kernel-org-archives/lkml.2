Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2HZJbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:31:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:54592 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab2HZJbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:31:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,315,1344236400"; 
   d="scan'208";a="212444059"
Date: Sun, 26 Aug 2012 17:31:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Anton Altaparmakov <anton@tuxera.com>, kernel-janitors@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: fs/ntfs/super.c:2717:1-14: alloc with no test
Message-ID: <20120826093113.GA11809@localhost>
References: <20120826090447.GA11098@localhost>
 <CAHdPZaNs99QLOD=-QeUvFj5soSJMZCPU24V=5QXuVWx0r1jC5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHdPZaNs99QLOD=-QeUvFj5soSJMZCPU24V=5QXuVWx0r1jC5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 02:42:12PM +0530, devendra.aaru wrote:
> On Sun, Aug 26, 2012 at 2:34 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> > Hi Anton,
> >
> > FYI, coccinelle warns about
> >
> > fs/ntfs/super.c:2717:1-14: alloc with no test, possible model on line 2718
> >
> > vim +2717 fs/ntfs/super.c
> >   2714          sb->s_flags |= MS_RDONLY;
> >   2715  #endif /* ! NTFS_RW */
> >   2716          /* Allocate a new ntfs_volume and place it in sb->s_fs_info. */
> >> 2717          sb->s_fs_info = kmalloc(sizeof(ntfs_volume), GFP_NOFS);
> 
> That's i think a false alarm.
> 
> >   2718          vol = NTFS_SB(sb);
> 
> The NTFS_SB(buf) {
>       buf->s_fs_info;
>  }
> 
> so we are validating the allocated pointer s_fs_info.

Yes, it is. Sorry for the noise!

Thanks,
Fengguang

