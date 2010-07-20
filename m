Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab0GTEPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:15:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756Ab0GTEPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:15:06 -0400
Date: Mon, 19 Jul 2010 21:14:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] writeback: avoid unnecessary calculation of bdi
 dirty thresholds
Message-Id: <20100719211400.c2bd5494.akpm@linux-foundation.org>
In-Reply-To: <20100720033437.GE6087@localhost>
References: <20100711020656.340075560@intel.com>
	<20100711021748.879183413@intel.com>
	<20100719143520.d9af9649.akpm@linux-foundation.org>
	<20100720033437.GE6087@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 11:34:37 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Tue, Jul 20, 2010 at 05:35:20AM +0800, Andrew Morton wrote:
> > On Sun, 11 Jul 2010 10:06:59 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Split get_dirty_limits() into global_dirty_limits()+bdi_dirty_limit(),
> > > so that the latter can be avoided when under global dirty background
> > > threshold (which is the normal state for most systems).
> > > 
> > 
> > mm/page-writeback.c: In function 'balance_dirty_pages_ratelimited_nr':
> > mm/page-writeback.c:466: warning: 'dirty_exceeded' may be used uninitialized in this function
> > 
> > This was a real bug.
> 
> Thanks! But how do you catch this? There are no warnings in my compile test.

Basic `make allmodconfig'.  But I use a range of different compiler
versions.  Different versions of gcc detect different stuff.  This was 4.1.0
or 4.0.2, I forget which.


