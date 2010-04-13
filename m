Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0DMIu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:50:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0DMIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:50:56 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Date: Tue, 13 Apr 2010 10:50:35 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, opensuse-kernel@opensuse.org,
       xfs@oss.sgi.com
References: <201004050049.17952.hpj@urpla.net> <201004080002.21137.hpj@urpla.net> <20100412223241.GM2493@dastard>
In-Reply-To: <20100412223241.GM2493@dastard>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004131050.36395.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX19GqcVf6cRV5TboBxcmyjXmdoP7LHVA/iI+qud
 gylSK05c2eAPT+oKCCrYoIvtQ0wG6m14sqwl1+ksxlLn7dyumD
 LAoUaTciaBzUpWUU6qF5IyM710Oy7GE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 April 2010, 00:32:41 Dave Chinner wrote:
> On Thu, Apr 08, 2010 at 12:02:20AM +0200, Hans-Peter Jansen wrote:
> > On Wednesday 07 April 2010, 03:45:33 Dave Chinner wrote:
> >
> > > The patches below apply to the xfs-dev tree, which is currently at
> > > 34-rc1. If they don't apply, let me know and I'll redo them against
> > > a vanilla kernel tree. Can you test them to see if the problem goes
> > > away? If the problem is fixed, I'll push them for a proper review
> > > cycle...
> >
> > Of course, you did the original patch for a reason... Therefor I would
> > love to test your patches. I've tried to apply them to 2.6.33.2, but
> > after fixing the same reject as noted below, I'm stuck here:
> >
> > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> >ux-2.6/xfs_sync.c: In function 'xfs_reclaim_inode_shrink':
> > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> >ux-2.6/xfs_sync.c:805: error: implicit declaration of function
> > 'xfs_perag_get'
> > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> >ux-2.6/xfs_sync.c:805: warning: assignment makes pointer from integer
> > without a cast
> > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> >ux-2.6/xfs_sync.c:807: error: implicit declaration of function
> > 'xfs_perag_put'
> >
> > Now I see, that there happened a rename of the offending functions, but
> > also they've grown a radix_tree structure and locking. How do I handle
> > that?
>
> With difficulty. I'd need to backport it to match the .33 code,
> which may or may not be trivial...

Dave, may I ask you kindly for briefly elaborating on the worst consequences 
of just reverting this hunk, as I've done before?

> > BTW, your patches do not apply to Linus' current git tree either:
> > patching file fs/xfs/quota/xfs_qm.c
> > Hunk #1 succeeded at 72 (offset 3 lines).
> > Hunk #2 FAILED at 2120.
> > 1 out of 2 hunks FAILED -- saving rejects to file
> > fs/xfs/quota/xfs_qm.c.rej I'm able to resolve this, but 2.6.34-current
> > does give me some other trouble, that I need to get by (PS2 keyboard
> > stops working eventually)..
>
> Yeah, there's another patch in my xfs-dev tree that changes that.
> I'll rebase it on a clean linux tree before I post it again.

I've briefly tested this with a codebase somewhere between -rc3 and -rc4, 
and it survived the du test, but it suffered from some strange network drop 
outs, that aren't funny on a nfs server...

Will retest your patches after opensuse-current catched up with -rc4. 
Hopefully, the most blatant stability issues are fixed by then.

Cheers,
Pete
