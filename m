Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2EaFvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:51:15 -0400
Received: from verein.lst.de ([213.95.11.211]:40702 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2EaFvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:51:14 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 01:51:14 EDT
Date: Thu, 31 May 2012 07:42:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target/file: Drop O_SYNC in favor of implict
	vfs_fsync_range for writes
Message-ID: <20120531054247.GB29553@lst.de>
References: <1338422263-19874-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338422263-19874-1-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:57:43PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts fd_execute_cmd() code to drop O_SYNC usage
> (the original default) in favor of always preforming an implict
> SCSI forced unit access (FUA) operation using vfs_fsync_range()
> based on LBA + SectorCount after each completed FILEIO backend write.
> 
> This conversion was inspired by Linus's thoughts on O_SYNC usage in
> the thread: http://www.spinics.net/lists/linux-fsdevel/msg55681.html
> 
>   "O_SYNC is the absolutely anti-thesis of that kind of "multiple levels
>    of overlapping IO". Because it requires that the IO is _done_ by the
>    time you start more, which is against the whole point."
> 
> This patch also drops the now unnecessary fd_buffered_io= token usage
> at createvirtdev time.  Tested with lio-core code using fio writeverify
> to local tcm_loop + FILEIO <-> scsi_debug backed LUNs.

If you look at the implementation O_SYNC really just means an implicit
vfs_fsync_range after each write, thus I can't see how this patch makes any
difference.

For target use with WCE=0 semantics you could at least switch to O_DSYNC, though.
