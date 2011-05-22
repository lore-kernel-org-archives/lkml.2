Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1EVMEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 08:04:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1EVMEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 08:04:06 -0400
Date: Sun, 22 May 2011 08:04:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <20110522120405.GA30858@infradead.org>
References: <10C5890F8F477E959B993BFA@nimrod.local>
 <20110520122010.GA25628@infradead.org>
 <60FB7C5F40961417F1605595@nimrod.local>
 <20110522104448.GA20241@infradead.org>
 <A0329D810FA7795CEDDA5C70@nimrod.local>
 <20110522112629.GA26586@infradead.org>
 <3A79A7FE44AE1DC20A2DB90D@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3A79A7FE44AE1DC20A2DB90D@nimrod.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 01:00:41PM +0100, Alex Bligh wrote:
> I think what you are saying is that when the request with REQ_FUA arrives,
> it will have been immediately preceded by a REQ_FLUSH. Therefore, I will
> only have the data attached to the request with REQ_FUA to flush anyway, so
> an fdatasync() does no harm performance wise. That's what I'm currently
> doing if sync_file_range() is not supported. It sounds like that's what I
> should be doing all the time. If you don't mind, I shall borrow your
> text above and put it in the source.

Sure, feel free to borrow it.  Note that I have a mid-term plan to
actually use REQ_FUA without preceeding REQ_FLUSH in XFS, but even in
that case the write cache probably won't be too full.

Long term someone who cares enough should simple submit patches
for range fsync/fdatasync syscalls.  We already have all the
infrastructure for it in the kernel, as it's used by the O_SYNC/O_DSYNC
implementation and nfsd, so it's just the actually syscall entry points
that need to be added.
