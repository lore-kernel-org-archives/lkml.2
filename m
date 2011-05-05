Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1EEMmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:42:38 -0400
Received: from verein.lst.de ([213.95.11.211]:56502 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1EEMmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:42:37 -0400
Date: Thu, 5 May 2011 14:42:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] writeback: avoid extra sync work at enqueue time
Message-ID: <20110505124237.GB24009@lst.de>
References: <20110502031750.135798606@intel.com> <20110502033035.789279347@intel.com> <20110504212427.GI6968@quack.suse.cz> <20110505122732.GC1294@localhost> <20110505124122.GA24009@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505124122.GA24009@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 02:41:22PM +0200, Christoph Hellwig wrote:
> On Thu, May 05, 2011 at 08:27:32PM +0800, Wu Fengguang wrote:
> > -	wbc.wb_start = jiffies; /* livelock avoidance */
> > +	oldest_jif = jiffies;
> > +	wbc.older_than_this = &oldest_jif;
> 
> Can't you kill the oldest_jif variable now?

Err, -ENOCOFFEE.  You could only kill it if you implement Jan's suggestion
of not making older_than_this a pointer..
