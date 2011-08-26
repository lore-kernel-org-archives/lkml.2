Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1HZMVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:21:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:33134 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab1HZMVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:21:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42710979"
Date: Fri, 26 Aug 2011 20:20:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110826122057.GA32711@localhost>
References: <1314093660.8002.24.camel@twins>
 <20110823141504.GA15949@localhost>
 <20110823174757.GC15820@redhat.com>
 <20110824001257.GA6349@localhost>
 <1314202378.6925.48.camel@twins>
 <20110826001846.GA6118@localhost>
 <1314349469.26922.24.camel@twins>
 <20110826100428.GA7996@localhost>
 <20110826112637.GA17785@localhost>
 <1314360710.11049.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314360710.11049.1.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 08:11:50PM +0800, Peter Zijlstra wrote:
> On Fri, 2011-08-26 at 19:26 +0800, Wu Fengguang wrote:
> > Now I get 3 figures. Test case is: run 1 dd write task for 300s, with
> > a "disturber" dd read task during roughly 120-130s. 
> 
> Ah, but ideally the disturber task should run in bursts of 100ms
> (<feedback period), otherwise your N is indeed mostly constant.

Ah yeah, the disturber task should be a dd writer! Then we get

- 120s: N=1 => N=2
- 130s: N=2 => N=1

I'll try it right away.

Thanks,
Fengguang
