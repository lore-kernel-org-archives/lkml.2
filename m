Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab0EDP2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466Ab0EDP2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:28:10 -0400
Date: Tue, 4 May 2010 11:27:50 -0400
From: Josef Bacik <josef@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH 1/3] fs: allow short direct-io reads to be completed
	via buffered IO
Message-ID: <20100504152749.GB2573@localhost.localdomain>
References: <20100503172702.GB3961@localhost.localdomain> <20100504001418.GH2591@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504001418.GH2591@dastard>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 10:14:18AM +1000, Dave Chinner wrote:
> On Mon, May 03, 2010 at 01:27:02PM -0400, Josef Bacik wrote:
> > This is similar to what already happens in the write case.  If we have a short
> > read while doing O_DIRECT, instead of just returning, fallthrough and try to
> > read the rest via buffered IO.  BTRFS needs this because if we encounter a
> > compressed or inline extent during DIO, we need to fallback on buffered.  If the
> > extent is compressed we need to read the entire thing into memory and
> > de-compress it into the users pages.  I have tested this with fsx and everything
> > works great.  Thanks,
> 
> Won't this mean that any direct IO read that spans EOF  (i.e. get a
> short read) now attempt a buffered IO (that will fail) before returning?
> 

Hmm yeah you are right.  What would be an acceptable way to avoid this, do a

if (retval || !count || ppos >= i_size_read(inode))
	goto out;

type thing?  Thanks,

Josef
