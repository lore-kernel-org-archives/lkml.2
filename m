Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1I3Hfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:35:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1I3HfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <1317367044-475-4-git-send-email-jweiner@redhat.com>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-4-git-send-email-jweiner@redhat.com>
Date: Fri, 30 Sep 2011 10:35:25 +0300
X-Google-Sender-Auth: XFTpttcEZHJ8iRYqEzINQIqWS8U
Message-ID: <CAOJsxLFWfH5zDG8ui=yQyOcZY_nXhK6r+ziapLg9Zhmb3ibuWQ@mail.gmail.com>
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across zones
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Shaohua Li <shaohua.li@intel.com>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes!

On Fri, Sep 30, 2011 at 10:17 AM, Johannes Weiner <jweiner@redhat.com> wrote:
> But there is a flaw in that we have a zoned page allocator which does
> not care about the global state but rather the state of individual
> memory zones.  And right now there is nothing that prevents one zone
> from filling up with dirty pages while other zones are spared, which
> frequently leads to situations where kswapd, in order to restore the
> watermark of free pages, does indeed have to write pages from that
> zone's LRU list.  This can interfere so badly with IO from the flusher
> threads that major filesystems (btrfs, xfs, ext4) mostly ignore write
> requests from reclaim already, taking away the VM's only possibility
> to keep such a zone balanced, aside from hoping the flushers will soon
> clean pages from that zone.

The obvious question is: how did you test this? Can you share the results?

                        Pekka
