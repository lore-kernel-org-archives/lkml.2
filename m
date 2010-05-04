Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab0EDAOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:14:24 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:33161 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932283Ab0EDAOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:14:23 -0400
Date: Tue, 4 May 2010 10:14:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 1/3] fs: allow short direct-io reads to be completed
 via buffered IO
Message-ID: <20100504001418.GH2591@dastard>
References: <20100503172702.GB3961@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503172702.GB3961@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 01:27:02PM -0400, Josef Bacik wrote:
> This is similar to what already happens in the write case.  If we have a short
> read while doing O_DIRECT, instead of just returning, fallthrough and try to
> read the rest via buffered IO.  BTRFS needs this because if we encounter a
> compressed or inline extent during DIO, we need to fallback on buffered.  If the
> extent is compressed we need to read the entire thing into memory and
> de-compress it into the users pages.  I have tested this with fsx and everything
> works great.  Thanks,

Won't this mean that any direct IO read that spans EOF  (i.e. get a
short read) now attempt a buffered IO (that will fail) before returning?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
