Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1I1O7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:59:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54616
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570Ab1I1O7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:59:04 -0400
Date: Wed, 28 Sep 2011 10:58:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] IO-less dirty throttling v11
Message-ID: <20110928145857.GA15587@infradead.org>
References: <20110904015305.367445271@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904015305.367445271@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 09:53:05AM +0800, Wu Fengguang wrote:
> Hi,
> 
> Finally, the complete IO-less balance_dirty_pages(). NFS is observed to perform
> better or worse depending on the memory size. Otherwise the added patches can
> address all known regressions.
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git dirty-throttling-v11
> 	(to be updated; currently it contains a pre-release v11)

Fengguang,

is there any chance we could start doing just the IO-less
balance_dirty_pages, but not all the subtile other changes?  I.e. are
the any known issues that make things work than current mainline if we
only put in patches 1 to 6?  We're getting close to another merge
window, and we're still busy trying to figure out all the details of
the bandwith estimation.  I think we'd have a much more robust tree
if we'd first only merge the infrastructure (IO-less
balance_dirty_pages()) and then work on the algorithms separately.

