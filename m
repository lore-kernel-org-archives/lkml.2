Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab0HDXLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:11:32 -0400
Received: from ozlabs.org ([203.10.76.45]:57221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102Ab0HDXL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:11:27 -0400
From: Michael Neuling <mikey@neuling.org>
To: ebiederm@xmission.com (Eric W. Biederman)
cc: Simon Horman <horms@verge.net.au>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
In-reply-to: <m17hk6de62.fsf@fess.ebiederm.org>
References: <20100804070647.GB24064@verge.net.au> <m17hk6de62.fsf@fess.ebiederm.org>
Comments: In-reply-to ebiederm@xmission.com (Eric W. Biederman)
   message dated "Wed, 04 Aug 2010 00:34:29 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 05 Aug 2010 09:11:26 +1000
Message-ID: <30114.1280963486@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > After all the excitement of relocating kexec-tools from
> > one location on kernel.org to another last week it was
> > suggested to me by Michael Neuling that the merging
> > kexec-tools into the kernel tree would be a good idea.
> >
> > Given that there have been a bunch of issues with kexec
> > on power that this would resolve. and there is precedence
> > for tools in the kernel tree, this sounds entirely reasonable to me.
> > So with my kexec-tools maintainer hat on, I would like to start
> > a conversation about this.
> 
> What are the issues with kexec on power?  Did someone fail to maintain
> ABI compatibility?
> 
> The interface isn't even supposed to be linux specific, so I can't
> imagine what would motivate moving this into the kernel tree.
> 
> I'm afraid that someone has a good answer for why their lives would be
> simpler if /sbin/kexec was in the kernel tree and I will be absolutely
> horrified and about someones stupidity when I hear that answer.

I may have misrepresented how bad it is for power to Horms.  None of the
issues would be solved by a merge, but it would make life easier IMHO.

In power we've added features to kexec which have required changes to
both the kernel and kexec-tools.  These have been backwards compatible,
so not to break to the ABI.  The problem here is getting users and
distros to take the correct versions of both sources if they want this
new feature.

Similarly with bugs.  We recently went through a round of bug fixes for
new larger power7 machines.  We found bugs in both kexec-tools and the
kernel.  That meant we had to ensure users and distros were getting
correctly updated versions of both tools.

Neither of these problems are show stoppers or power specific but I
think it would make life easier in these scenarios if the sources were
merged.  We could just tell users and distros to grab (say) 2.6.35
sources and we'd know they'd be right for both userspace and the kernel.

Also, I think kexec-tools would benefit from the same release process as
the kernel, with a merge window followed by bug fixes.  Of course,
kexec-tools doesn't need to be in the kernel for this, but it might be
easier for Horms to enforce if it was.  kexec-tools only gets a trickle
patches.

I'd also hope that kexec-tools would get some addition community
exposure and TLC if they were in the kernel sources.

My question is, why not?  What qualifies a tool to be added to tools/?
I think kexec-tools are tied to the kernel at least as much as perf is.
Certainly the ABI for the image we are booting into is not Linux
specific, but should that disqualify it from being in tools/?

Mikey
