Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab0HUFsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 01:48:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:46368 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0HUFse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 01:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,244,1280732400"; 
   d="scan'208";a="830363596"
Date: Sat, 21 Aug 2010 13:48:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in
 /proc/vmstat
Message-ID: <20100821054808.GA29869@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-5-git-send-email-mrubin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282296689-25618-5-git-send-email-mrubin@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 05:31:29PM +0800, Michael Rubin wrote:
> The kernel already exposes the user desired thresholds in /proc/sys/vm
> with dirty_background_ratio and background_ratio. But the kernel may
> alter the number requested without giving the user any indication that
> is the case.
> 
> Knowing the actual ratios the kernel is honoring can help app developers
> understand how their buffered IO will be sent to the disk.
> 
> 	$ grep threshold /proc/vmstat
> 	nr_dirty_threshold 409111
> 	nr_dirty_background_threshold 818223

I realized that the dirty thresholds has already been exported here:

$ grep Thresh  /debug/bdi/8:0/stats
BdiDirtyThresh:     381000 kB
DirtyThresh:       1719076 kB
BackgroundThresh:   859536 kB

So why not use that interface directly?

Thanks,
Fengguang
