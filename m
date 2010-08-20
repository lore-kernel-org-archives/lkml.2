Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0HTInM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:43:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:20535 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0HTInK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,238,1280732400"; 
   d="scan'208";a="598535188"
Date: Fri, 20 Aug 2010 16:43:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@suse.de" <npiggin@suse.de>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] writeback: Adding pages_dirtied and
 pages_entered_writeback
Message-ID: <20100820084304.GA6051@localhost>
References: <1282251447-16937-1-git-send-email-mrubin@google.com>
 <1282251447-16937-3-git-send-email-mrubin@google.com>
 <20100820025111.GB5502@localhost>
 <AANLkTimKn5BZiCAyr-3XAZuu66Q+ASZgBZ7LDU2Jom1p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimKn5BZiCAyr-3XAZuu66Q+ASZgBZ7LDU2Jom1p@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 04:16:09PM +0800, Michael Rubin wrote:
> On Thu, Aug 19, 2010 at 7:51 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > As Rik said, /proc/sys is not a suitable place.
> 
> OK I'm convinced.
> 
> > Frankly speaking I've worked on writeback for years and never felt
> > the need to add these counters. What I often do is:
> >
> > $ vmmon -d 1 nr_writeback nr_dirty nr_unstable
> >
> >     nr_writeback         nr_dirty      nr_unstable
> >            68738                0            39568
> >            66051                0            42255
> >            63406                0            44900
> >            60643                0            47663
> >            57954                0            50352
> >            55264                0            53042
> >            52592                0            55715
> >            49922                0            58385
> > That is what I get when copying /dev/zero to NFS.
> >
> > I'm very interested in Google's use case for this patch, and why
> > the simple /proc/vmstat based vmmon tool is not enough.
> 
> So as I understand it from looking at the code vmmon is sampling
> nr_writeback, nr_dirty which are exported versions of
> global_page_state for NR_FILE_DIRTY and NR_WRITEBACK. These states are
> a snapshot of the state of the kernel's pages. Namely how many dpages
> ar ein writeback or dirty at the moment vmmon's acquire routine is
> called.
> 
> vmmon is sampling /proc/vstat and then displaying the difference from
> the last time they sampled.  If I am misunderstanding let me know.

Maybe Andrew's vmmon does that. My vmmon always display the raw values
:) It could be improved to do raw values for nr_dirty and differences
for pgpgin by default.

> This is good for the state of the system but as we compare
> application, mm and io performance over long periods of time we are
> interested in the surges and fluctuations of the rates of the
> producing and consuming of dirty pages also. It can help isolate where
> the problem is and also to compare performance between kernels and/or
> applications.

Yeah the accumulated dirty and writeback page counts could be useful.
For example, for inspecting the dirty and writeback speed over time.
That's not possible for nr_dirty/nr_writeback.

Thanks,
Fengguang
