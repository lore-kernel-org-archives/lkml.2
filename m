Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab2JYCiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:38:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:58300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab2JYCiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:38:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,643,1344236400"; 
   d="scan'208";a="210491953"
Date: Thu, 25 Oct 2012 10:38:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: YingHang Zhu <casualfisher@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: remove redundant ra_pages in file_ra_state
Message-ID: <20121025023808.GA23462@localhost>
References: <1350996411-5425-1-git-send-email-casualfisher@gmail.com>
 <20121023224706.GR4291@dastard>
 <CAA9v8mGjdi9Kj7p-yeLJx-nr8C+u4M=QcP5+WcA+5iDs6-thGw@mail.gmail.com>
 <20121024201921.GX4291@dastard>
 <CAA9v8mExDX1TYgCrRfYuh82SnNmNkqC4HjkmczSnz3Ca4zT_qw@mail.gmail.com>
 <20121025015014.GC29378@dastard>
 <CAA9v8mEULAEHn8qSsFokEue3c0hy8pK8bkYB+6xOtz_Tgbp0vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9v8mEULAEHn8qSsFokEue3c0hy8pK8bkYB+6xOtz_Tgbp0vw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi YingHang,

> Actually I've talked about it with Fengguang, he advised we should unify the
> ra_pages in struct bdi and file_ra_state and leave the issue that
> spreading data
> across disks as it is.
> Fengguang, what's you opinion about this?

Yeah the two ra_pages may run out of sync for already opened files,
which could be a problem for long opened files. However as Dave put
it, a device's max readahead size is typically a static value that can
be set at mount time. So, the question is: do you really hurt from the
old behavior that deserves this code change?

I agree with Dave that the multi-disk case is not a valid concern.  In
fact, how can the patch help that case? I mean, if it's two fuse files
lying in two disks, it *was* not a problem at all. If it's one big
file spreading to two disks, it's a too complex scheme to be
practically manageable which I doubt if you have such a setup. 

Thanks,
Fengguang
