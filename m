Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1ITSk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:40:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39489
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928Ab1ITSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:40:58 -0400
Date: Tue, 20 Sep 2011 14:40:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from
 grab_cache_page_write_begin()
Message-ID: <20110920184034.GA27353@infradead.org>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
 <1316526315-16801-4-git-send-email-jweiner@redhat.com>
 <20110920142553.GA2593@infradead.org>
 <4E78DD8B.1020605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E78DD8B.1020605@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 02:38:03PM -0400, Rik van Riel wrote:
> On 09/20/2011 10:25 AM, Christoph Hellwig wrote:
> >In addition to regular write shouldn't __do_fault and do_wp_page also
> >calls this if they are called on file backed mappings?
> >
> 
> Probably not do_wp_page since it always creates an
> anonymous page, which are not very relevant to the
> dirty page cache accounting.

Well, it doesn't always - but for the case where it doesn't we
do not allocate a new page at all so you're right in the end :)
