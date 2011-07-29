Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1G2NSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:18:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44669 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab1G2NSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:18:50 -0400
Date: Fri, 29 Jul 2011 15:17:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Liu <lingjiujianke@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix build breakage in xfs_iops.c when
 CONFIG_FS_POSIX_ACL is not set
Message-ID: <20110729131752.GA29880@elte.hu>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jul 26, 2011 at 11:15:20AM +0200, Markus Trippelsdorf wrote:
> > commit 4e34e719e45, that takes the ACL checks to common code,
> > accidentely broke the build when CONFIG_FS_POSIX_ACL is not set:
> > 
> >   CC      fs/xfs/linux-2.6/xfs_iops.o
> > fs/xfs/linux-2.6/xfs_iops.c:1025:14: error: ???xfs_get_acl??? undeclared here (not in a function)
> > 
> > Fix this by declaring xfs_get_acl a static inline function.
> 
> Do you have OPTIMIZE_INLINING enabled?  In general I dont think we 
> can take the address of an inline function, so without this option 
> I far the code might not compile, in which case we'll need ifdefs 
> around the inode operation assignment in addition to your patch.

FYI, this build bug is still present upstream and triggers rather 
frequently in randconfig testing.

Also, according to the timestamps of the guilty commit (4e34e719e45) 
it had near zero linux-next testing time before it was pushed 
upstream - could we improve on that please?

Thanks,

	Ingo
