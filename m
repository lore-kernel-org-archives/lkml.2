Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1GZJrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:47:36 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:35760 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1GZJra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:47:30 -0400
Date: Tue, 26 Jul 2011 11:47:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Liu <lingjiujianke@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix build breakage in xfs_iops.c when
 CONFIG_FS_POSIX_ACL is not set
Message-ID: <20110726094728.GA1629@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
 <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de>
 <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
 <20110726085804.GA1639@x4.trippels.de>
 <20110726091520.GB1639@x4.trippels.de>
 <20110726093401.GA8334@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726093401.GA8334@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.26 at 05:34 -0400, Christoph Hellwig wrote:
> On Tue, Jul 26, 2011 at 11:15:20AM +0200, Markus Trippelsdorf wrote:
> > commit 4e34e719e45, that takes the ACL checks to common code,
> > accidentely broke the build when CONFIG_FS_POSIX_ACL is not set:
> > 
> >   CC      fs/xfs/linux-2.6/xfs_iops.o
> > fs/xfs/linux-2.6/xfs_iops.c:1025:14: error: ???xfs_get_acl??? undeclared here (not in a function)
> > 
> > Fix this by declaring xfs_get_acl a static inline function.
> 
> Do you have OPTIMIZE_INLINING enabled?  In general I dont think we can
> take the address of an inline function, so without this option I far
> the code might not compile, in which case we'll need ifdefs around
> the inode operation assignment in addition to your patch.

No, "# CONFIG_OPTIMIZE_INLINING is not set". 
I've tested this patch with gcc 4.5.2, 4.6.1 and 4.7.0 and in all cases
the kernel builds just fine.

-- 
Markus
