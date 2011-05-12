Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab1ELSFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:05:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1ELSFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:05:14 -0400
Date: Thu, 12 May 2011 20:04:57 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce impact to overall system of SLUB using
 high-order allocations
Message-ID: <20110512180457.GO11579@random.random>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
 <1305149960.2606.53.camel@mulgrave.site>
 <alpine.DEB.2.00.1105111527490.24003@chino.kir.corp.google.com>
 <1305153267.2606.57.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305153267.2606.57.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James!

On Wed, May 11, 2011 at 05:34:27PM -0500, James Bottomley wrote:
> Yes, but only once in all the testing.  With patches 1 and 2 the hang is

Weird patch 2 makes the large order allocation without ~__GFP_WAIT, so
even COMPACTION=y/n shouldn't matter anymore. Am I misreading
something Mel?

Removing ~__GFP_WAIT from patch 2 (and adding ~__GFP_REPEAT as a
correctness improvement) and setting COMPACTION=y also should work ok.

Removing ~__GFP_WAIT from patch 2 and setting COMPACTION=n is expected
not to work well.

But compaction should only make the difference if you remove
~__GFP_WAIT from patch 2.
