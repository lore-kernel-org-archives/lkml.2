Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0JPQWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:22:05 -0400
Received: from canuck.infradead.org ([134.117.69.58]:60245 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0JPQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:22:04 -0400
Date: Sat, 16 Oct 2010 12:22:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101016162201.GF16861@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <20101008095658.GA19804@ZenIV.linux.org.uk>
 <20101008100346.GA27737@infradead.org>
 <20101016075721.GS19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075721.GS19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:57:21PM +1100, Nick Piggin wrote:
> My approach in my tree is a new function like Al suggests, which
> simply doesn't assign the ino. That keeps compatibility backward.

There's really no point.  The concept of creating a new inode has
absolutely nothing to do with i_ino.  We'll just need i_ino before
adding an inode to the hash.  The only reason it's been done by
new_inode is historic coincidence - cleaning this mess up is a good
thing independent of making the fake inode number generation scale
better.  As you can see in my patch moving it out there's actually
only very few filesystems that need it.

