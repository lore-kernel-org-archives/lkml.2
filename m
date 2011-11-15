Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1KOEDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:03:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:58019 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab1KOEDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:03:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,512,1315206000"; 
   d="scan'208";a="74913371"
Date: Tue, 15 Nov 2011 12:03:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Subject: writeback test scripts
Message-ID: <20111115040326.GA24233@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've uploaded the writeback test scripts to github:
(status: usable, ugly, a lot of rough edges)

        git://github.com/fengguang/writeback-tests.git
        https://github.com/fengguang/writeback-tests

The main features are

- automated dd/fio tests

- combinations of kernel/fs/fio job/nr_dd/dirty_thresh that is
  hopefully complete enough to catch common performance regressions

- compare.rb for quickly evaluating performance and locate regressions

- detailed logs and graphs for analyzing regressions

To try it out,

1) copy all files to

        /path/to/writeback-tests

2) basic configuration

        cp fat-config.sh $(hostname)-config.sh
        vi  $(hostname)-config.sh
        vi config.sh

Minimal configuration is to prepare at least one empty partition and
point DEVICES to it, create one empty mount point and point MNT to it.

3) add a hook at the end of rc.local:

        /path/to/writeback-tests/main-loop.sh

main-loop.sh will test one case on each fresh boot.  It will
automatically reboot the test box for each test cases until all done.

Each test run will save its log files to a unique directory

        /path/to/writeback-tests/$(hostname)/<path1>/<path2>/

and if that directory already exists, the test case will be skipped.

We may further do a queue based job submission/execution system,
however this silly loop works good enough for me now :-)

Thanks,
Fengguang
