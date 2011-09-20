Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1ITSin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:38:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab1ITSik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:38:40 -0400
Message-ID: <4E78DD8B.1020605@redhat.com>
Date: Tue, 20 Sep 2011 14:38:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from grab_cache_page_write_begin()
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com> <1316526315-16801-4-git-send-email-jweiner@redhat.com> <20110920142553.GA2593@infradead.org>
In-Reply-To: <20110920142553.GA2593@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 10:25 AM, Christoph Hellwig wrote:
> In addition to regular write shouldn't __do_fault and do_wp_page also
> calls this if they are called on file backed mappings?
>

Probably not do_wp_page since it always creates an
anonymous page, which are not very relevant to the
dirty page cache accounting.
