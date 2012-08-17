Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2HQPiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:38:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45291 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256Ab2HQPhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:37:47 -0400
Date: Fri, 17 Aug 2012 11:37:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: linux RAID <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Li Shaohua <shli@fusionio.com>, Marti Raudsepp <marti@juffo.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
        "Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
Subject: Re: ext4 write performance regression in 3.6-rc1 on RAID0/5
Message-ID: <20120817153735.GB31297@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@gmail.com>,
	linux RAID <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>,
	Li Shaohua <shli@fusionio.com>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
 <20120817134039.GB11439@thunk.org>
 <20120817142526.GA1059@localhost>
 <20120817151318.GA2341@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817151318.GA2341@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:13:18PM +0800, Fengguang Wu wrote:
> 
> Obviously the major regressions happen to the 100dd over raid cases.
> Some 10dd cases are also impacted.
> 
> The attached graphs show that everything becomes more fluctuated in
> 3.6.0-rc1 for the lkp-nex04/RAID0-12HDD-thresh=8G/ext4-100dd-1 case.

Hmm... I'm not seeing any differences in the block allocation code, or
in ext4's buffered writeback code paths, which would be the most
likely cause of such problems.  Maybe a quick eyeball of the blktrace
to see if we're doing something pathalogically stupid?

You could also try running a filefrag -v on a few of the dd files to
see if there's any significant difference, although as I said, there
doesn't look like there was any significant changes in the block
allocation code between v3.5 and v3.6-rc1 --- although I suppose
changes in timeing could have have caused the block allocation
decisions to be different, so it's worth checking that out.

Thanks, regards,

						- Ted
