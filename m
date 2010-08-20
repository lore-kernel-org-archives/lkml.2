Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0HTCvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:51:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:58125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0HTCvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:51:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,236,1280732400"; 
   d="scan'208";a="547026157"
Date: Fri, 20 Aug 2010 10:51:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, npiggin@suse.de,
        hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 2/3] writeback: Adding pages_dirtied and
 pages_entered_writeback
Message-ID: <20100820025111.GB5502@localhost>
References: <1282251447-16937-1-git-send-email-mrubin@google.com>
 <1282251447-16937-3-git-send-email-mrubin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282251447-16937-3-git-send-email-mrubin@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 01:57:26PM -0700, Michael Rubin wrote:
> To help developers and applications gain visibility into writeback
> behaviour adding four read only sysctl files into /proc/sys/vm.
> These files allow user apps to understand writeback behaviour over time
> and learn how it is impacting their performance.
> 
>    # cat /proc/sys/vm/pages_dirtied
>    3747
>    # cat /proc/sys/vm/pages_entered_writeback
>    3618

As Rik said, /proc/sys is not a suitable place.

Frankly speaking I've worked on writeback for years and never felt
the need to add these counters. What I often do is:

$ vmmon -d 1 nr_writeback nr_dirty nr_unstable

     nr_writeback         nr_dirty      nr_unstable
            68738                0            39568
            66051                0            42255
            63406                0            44900
            60643                0            47663
            57954                0            50352
            55264                0            53042
            52592                0            55715
            49922                0            58385
That is what I get when copying /dev/zero to NFS.

You can find vmmon.c in Andrew Morton's ext3-tools package.
Also attached for your convenience.

I'm very interested in Google's use case for this patch, and why
the simple /proc/vmstat based vmmon tool is not enough.

Thanks,
Fengguang
