Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1DZGN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:13:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:44834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab1DZGNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:13:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="914417217"
Date: Tue, 26 Apr 2011 14:13:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: readahead and oom
Message-ID: <20110426061353.GA19717@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
 <20110426055521.GA18473@localhost>
 <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:05:12PM +0800, Dave Young wrote:
> On Tue, Apr 26, 2011 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
> >> Hi,
> >>
> >> When memory pressure is high, readahead could cause oom killing.
> >> IMHO we should stop readaheading under such circumstances。If it's true
> >> how to fix it?
> >
> > Good question. Before OOM there will be readahead thrashings, which
> > can be addressed by this patch:
> >
> > http://lkml.org/lkml/2010/2/2/229
> 
> Hi, I'm not clear about the patch, could be regard as below cases?
> 1) readahead alloc fail due to low memory such as other large allocation
> 2) readahead thrashing caused by itself

When memory pressure goes up (not as much as allocation failures and OOM),
the readahead pages may be reclaimed before they are read() accessed
by the user space. At the time read() asks for the page, it will have
to be read from disk _again_. This is called readahead thrashing.

What the patch does is to automatically detect readahead thrashing and
shrink the readahead size adaptively, which will the reduce memory
consumption by readahead buffers.

Thanks,
Fengguang

> >
> > However there seems no much interest on that feature.. I can separate
> > that out and resubmit it standalone if necessary.
> >
> > Thanks,
> > Fengguang
> >
> 
> 
> 
> -- 
> Regards
> dave
