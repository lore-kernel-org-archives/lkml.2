Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1GZP7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:59:39 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:43515 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1GZP7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:59:33 -0400
Date: Tue, 26 Jul 2011 17:59:30 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Liu <lingjiujianke@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [git pull] vfs pile 1.5
Message-ID: <20110726155930.GB1629@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
 <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de>
 <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
 <20110726085804.GA1639@x4.trippels.de>
 <CA+55aFz0S3mO9ETFZpsEcbotWV+NMzaFhpZcN09LNAdk+eavjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFz0S3mO9ETFZpsEcbotWV+NMzaFhpZcN09LNAdk+eavjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.26 at 08:52 -0700, Linus Torvalds wrote:
> On Tue, Jul 26, 2011 at 1:58 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> >
> > #ifdefs are ugly. The following fixes the issue for me:
> 
> Actually, I think the proper fix is just the following
> (whitespace-damaged).  It's better to just set ".get_acl" to NULL, and
> it's what we used to do back when it was called "check_acl" (see
> commit 4e34e719e45).
> 
Yes, that was my first idea, too. But unfortunately it doesn't work:

  CC      fs/xfs/linux-2.6/xfs_iops.o
fs/xfs/linux-2.6/xfs_iops.c: In function ‘xfs_vn_mknod’:
fs/xfs/linux-2.6/xfs_iops.c:184:28: error: called object ‘0u’ is not a function
make[2]: *** [fs/xfs/linux-2.6/xfs_iops.o] Error 1
-- 
Markus
