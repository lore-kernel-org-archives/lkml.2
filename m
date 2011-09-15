Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935235Ab1IOWHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:07:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47432 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1IOWHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:07:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9_cmdCg4UJrzYBzcrhD61PZ6hfrGWbF2A05LPo9WD55874uw@mail.gmail.com>
References: <20110910064531.GA32536@moria>
	<CAA9_cmdCg4UJrzYBzcrhD61PZ6hfrGWbF2A05LPo9WD55874uw@mail.gmail.com>
Date: Thu, 15 Sep 2011 15:07:30 -0700
Message-ID: <CAC7rs0tSPAwC4WGWPn6t3H0hq_tB06nK-PA2KXLK+bWwTs+81Q@mail.gmail.com>
Subject: Re: [GIT] Bcache version 12
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 3:03 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Does it consider the raid5/6 write hole in what it caches?  Guess I
> need to take a look at the code, but just wondering if it considers
> the need to maintain a consistent strip when writing back to raid5/6
> array, or would there still be a need for a separate driver/region of
> the SSD for caching that data.

Do you mean - if you're caching a raid5 (not the individual devices,
the entire array) the parity blocks?

In that case no, bcache will never see them. However, if you're doing
writeback caching that won't be a huge problem since you'll end up
with more full stripe writes.
