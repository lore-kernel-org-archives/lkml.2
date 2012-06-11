Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2FKMRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:17:20 -0400
Received: from fieldses.org ([174.143.236.118]:37480 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab2FKMRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:17:18 -0400
Date: Mon, 11 Jun 2012 08:17:08 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120611121708.GC7654@fieldses.org>
References: <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
 <20120608162234.GB17251@fieldses.org>
 <CA+55aFzimZezPFpNMdM_HRORWSzJGFLN_Go0Ci+hiZ3Vapu1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzimZezPFpNMdM_HRORWSzJGFLN_Go0Ci+hiZ3Vapu1Fg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:44:09AM -0700, Linus Torvalds wrote:
> On Fri, Jun 8, 2012 at 9:22 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Thu, Jun 07, 2012 at 08:36:07PM +0100, Al Viro wrote:
> >
> >> I really believe that this pair of commits needs to be reverted.  The
> >> earlier code used to guarantee that alias would be detached.
> >
> > In the case that prompted that first commit, the directory in question
> > had an alias that was detached (which I'm taking to mean IS_ROOT(dentry)
> > was true?), but not flagged DISCONNECTED.  The particular case was only
> > reproduceable on an older kernel, and I couldn't find a similar
> > reproducer on recent upstream, but I also couldn't convince myself it
> > was impossible.
> >
> > So, maybe the correct thing is to revert that change.  Or maybe it
> > should be picking an IS_ROOT dentry instead of a DISCONNECTED one?
> 
> I've reverted the changes for now, it looks like the discussion about
> them is still on-going, and I think I'll feel happier if we just go
> back to the old status quo for the nonce.

Fair enough; I'll keep investigating.

--b.
