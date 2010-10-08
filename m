Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab0JHIPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:15:54 -0400
Received: from verein.lst.de ([213.95.11.210]:45254 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0JHIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:15:52 -0400
Date: Fri, 8 Oct 2010 10:15:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] fs: Clean up inode reference counting
Message-ID: <20101008081533.GA1728@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com> <1286515292-15882-7-git-send-email-david@fromorbit.com> <20101008072051.GE23595@lst.de> <20101008074643.GS4681@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008074643.GS4681@dastard>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 06:46:43PM +1100, Dave Chinner wrote:
> > Also any chance to get an assert under a debug option the the reference
> > count really is non-zero?
> 
> For iref()? Sure, but I think WARN_ON_ONCE() is better for the moment,
> though.

I don't think a WARN_ON_ONCE is too helpful - there could be all kinds
of different filesystems having that issue.  Also I think a plain
WARN_ON is cheaper than a WARN_ON_ONCE and this is a rather hot
codepath.

