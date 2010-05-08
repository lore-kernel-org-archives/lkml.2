Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0EHAq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 20:46:26 -0400
Received: from thunk.org ([69.25.196.29]:45356 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab0EHAqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 20:46:25 -0400
Date: Fri, 7 May 2010 20:46:17 -0400
From: tytso@mit.edu
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unified page and buffer cache?
Message-ID: <20100508004617.GF18762@thunk.org>
Mail-Followup-To: tytso@mit.edu, Phillip Susi <psusi@cfl.rr.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <4BCC7C05.8000803@cfl.rr.com>
 <4BE417CB.7000806@cfl.rr.com>
 <20100507135329.GA17259@parisc-linux.org>
 <4BE4359E.9020400@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE4359E.9020400@cfl.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 11:45:34AM -0400, Phillip Susi wrote:
> 
> Back to the drawing board I guess.  Maybe ext could be fixed to use an
> inode mapping for directories instead of relying on the block device
> mapping, then I could readahead() the directory instead of having to go
> to the block device at all.

Ext2 does use the page cache for directories.  Ext3 and Ext4 access
directories via buffer heads because of the journaling requirement.

In *theory* they could be modified to use the page cache, given that
we can do data journaling for files, and files live in the page cache
--- however, for cases where the PAGE_SIZE > FS_BLOCKSIZE, which will
happen if you are using 1k or 2k block filesystems, or on the Power
Architecture or on the Itanic where the page size is 16k, updates to
the directory will be much less efficient, since we journal changes to
data files on page granularity and not buffer granuality.

Furthermore, someone would have to supply me with the patches; it's
pretty low on my priority list.  And people on the Power and ia64
platforms won't be happy....

						- Ted
