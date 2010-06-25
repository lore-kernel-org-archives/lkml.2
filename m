Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0FYHMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 03:12:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0FYHMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 03:12:24 -0400
Date: Fri, 25 Jun 2010 03:12:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100625071221.GA2397@infradead.org>
References: <20100624030212.676457061@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030212.676457061@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you actuall want to get this work in reposting huge patchkit again and
again probably doesn't help.  Start to prioritize areas and work on small
sets to get them ready.

files_lock and vfsmount_lock seem like rather easy targets to start
with.  But for files_lock I really want to see something to generalize
the tty special case.  If you touch that are in detail that wart needs
to go.  Al didn't seem to like my variant very much, so he might have
a better idea for it - otherwise it really makes the VFS locking simple
by removing any tty interaction with the superblock files list.  The
other suggestion would be to only open regular (maybe even just
writeable) files to the list.  In addition to reducing the number of
list operations require it will also make the tty code a lot easier.

As for the other patches:  I don't think the massive fine-grained
locking in the hash tables is a good idea.  I would recommend to defer
them for now, and then look into better data structures for these caches
instead of working around the inherent problems of global hash tables.

