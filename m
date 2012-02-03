Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2BCOfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:35:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:46934 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2BCOfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:35:31 -0500
Date: Fri, 3 Feb 2012 09:21:19 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: make do_writepages() use plugging
Message-ID: <20120203142119.GM16796@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Johannes Weiner <jweiner@redhat.com>,
	Amit Sahrawat <a.sahrawat@samsung.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <1328275626-5322-1-git-send-email-amit.sahrawat83@gmail.com>
 <20120203133823.GB17571@localhost>
 <20120203140834.GA15495@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203140834.GA15495@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F2BF09A.0079,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 09:08:34AM -0500, Christoph Hellwig wrote:
> On Fri, Feb 03, 2012 at 09:38:23PM +0800, Wu Fengguang wrote:
> > On Fri, Feb 03, 2012 at 06:57:06PM +0530, Amit Sahrawat wrote:
> > > This will cover all the invocations for writepages to be called with
> > > plugging support.
> >  
> > Thanks.  I'll test it on the major filesystems. But would you
> > name a few filesystems that are expected to benefit from it?
> > It's not obvious because some FS ->writepages eventually calls
> > generic_writepages() which already does plugging.
> 
> Ant that's exactly where it should stay instead of beeing sprinkled all
> over the VM code.
> 
> NAK to the patch.

We've actually had problems with plugging in the higher layers.
writepages is queueing up lots and lots and lots of pages for IO, and
especially on SSDs we want these IOs sent sooner rather than later.

I'm not sure yet how to make the plugs aware of the
please-feed-me-right-away demands of lower storage, but I'd rather not
add more high level plugs that the filesystems can't control.

-chris

