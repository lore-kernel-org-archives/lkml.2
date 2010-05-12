Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab0ELVY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab0ELVY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:24:26 -0400
Date: Wed, 12 May 2010 17:24:04 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: [RFC] new ->perform_write fop
Message-ID: <20100512212403.GE3597@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just started adding aio_write to Btrfs and I noticed we're duplicating _alot_
of the generic stuff in mm/filemap.c, even though the only thing thats really
unique is the fact that we copy userspace pages in chunks rather than one page a
t a time.  What would be best is instead of doing write_begin/write_end with
Btrfs, it would be nice if we could just do our own perform_write instead of
generic_perform_write.  This way we can drop all of these generic checks we have
that we copied from filemap.c and just got to the business of actually writing
the data.  I hate to add another file operation, but it would _greatly_ reduce
the amount of duplicate code we have.  If there is no violent objection to this
I can put something together quickly for review.  Thanks,

Josef
