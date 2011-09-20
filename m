Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1ITSlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1ITSlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:41:19 -0400
Message-ID: <4E78DE27.1030906@redhat.com>
Date: Tue, 20 Sep 2011 14:40:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Johannes Weiner <jweiner@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from grab_cache_page_write_begin()
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com> <1316526315-16801-4-git-send-email-jweiner@redhat.com>
In-Reply-To: <1316526315-16801-4-git-send-email-jweiner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 09:45 AM, Johannes Weiner wrote:
> Tell the page allocator that pages allocated through
> grab_cache_page_write_begin() are expected to become dirty soon.
>
> Signed-off-by: Johannes Weiner<jweiner@redhat.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

The missing codepaths pointed out by Christoph either
create new anonymous pages, or mark ptes pointing at
existing page cache pages writeable.

Either way, those should not need __GFP_WRITE.

