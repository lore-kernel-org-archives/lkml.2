Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210Ab1IOWDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:03:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52933 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935072Ab1IOWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:03:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110910064531.GA32536@moria>
References: <20110910064531.GA32536@moria>
Date: Thu, 15 Sep 2011 15:03:08 -0700
X-Google-Sender-Auth: Cgd3DfKSMpSFkhYCmgSi_kWhE2g
Message-ID: <CAA9_cmdCg4UJrzYBzcrhD61PZ6hfrGWbF2A05LPo9WD55874uw@mail.gmail.com>
Subject: Re: [GIT] Bcache version 12
From: Dan Williams <dan.j.williams@intel.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 11:45 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> bcache, n.: a cache for arbitrary block devices that uses an SSD
>
> It's probably past time I started poking people to see about getting
> this stuff in. It's synced up with mainline, the documentation is for
> once relatively up to date, and it looks just about production ready.
>
> Suggestions are more than welcome on how to make it easier to review -
> it's entirely too much code, I know (near 10k lines now). I'll be
> emailing the patches that touch other parts of the kernel separately.
>
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself
> as a new block device, a bit like say md. You can cache an arbitrary
> number of block devices with a single cache device, and attach and
> detach things at runtime - it's quite flexible.
>
> It's very fast. It uses a b+ tree for the index, along with a journal to
> coalesce index updates, and a bunch of other cool tricks like auxiliary
> binary search trees with software floating point keys to avoid a bunch
> of random memory accesses when doing binary searches in the btree. It
> does over 50k iops doing 4k random /writes/ without breaking a sweat,
> and would do many times that if I had faster hardware.

Does it consider the raid5/6 write hole in what it caches?  Guess I
need to take a look at the code, but just wondering if it considers
the need to maintain a consistent strip when writing back to raid5/6
array, or would there still be a need for a separate driver/region of
the SSD for caching that data.
