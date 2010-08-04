Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab0HDM24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:28:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757615Ab0HDM2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:28:55 -0400
Date: Wed, 4 Aug 2010 08:26:00 -0400
From: Neil Horman <nhorman@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
Message-ID: <20100804122600.GC14270@hmsreliant.think-freely.org>
References: <20100804070647.GB24064@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804070647.GB24064@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:06:48PM +0900, Simon Horman wrote:
> Hi,
> 
> After all the excitement of relocating kexec-tools from
> one location on kernel.org to another last week it was
> suggested to me by Michael Neuling that the merging
> kexec-tools into the kernel tree would be a good idea.
> 
> Given that there have been a bunch of issues with kexec
> on power that this would resolve. and there is precedence
> for tools in the kernel tree, this sounds entirely reasonable to me.
> So with my kexec-tools maintainer hat on, I would like to start
> a conversation about this.
> 
> In order to move the conversation along I have prepared a tree -
> a recent clone of Linus's tree + kexec tools.
> 
> http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools-in-kernel-tree.git
> 
> I think that a good next step would be to get this tree into linux-next.
> And then if all goes well, as Linus to pull the change some time in the future.
> 
> 
> 
> 
> 
> For reference the steps taken to make the tree above were roughly as follows.
> Thanks to Michael for assistance with this.
> 
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> git clone git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
> 
> cd linux-2.6
> 
> git remote add -f kexec ../kexec-tools
> git merge -s ours --no-commit kexec/master
> git read-tree --prefix=tools/kexec/ -u kexec/master
> git commit -m "Merge kexec-tools into subdirectory tools/kexec"
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec


It seems to me that this change isn't overly usefull in solving the problems
that kexec-tools seems to chronically encounter.  The biggest kexec/kernel
problem that I seem to encounter during maintence of the package in RHEL isn't
ABI compatibility between any kexec/kernel version pair (which can often be
mitigated/controlled by merging the source trees), but rather by lack of testing
of changes.  All to often kernel code authors assume that if something they
write or modify works in the kernel during a normal boot, it can be assumed to
work just fine in the kdump kernel.  That _should_ be the case, bur rarely is
it.  And unfortunately, that won't be mitigated by tying a kexec and kernel
version together.

What I think we need is a shorter path from upstream commit to regression/bug
detection.  Something that would allow someone to validate that kexec works
properly after they have made a commit to hardware that they have in hand.
Perhaps something in the scripts directory that allows a developer to
immediately execute a kexec -e reboot and a kexec -l; sysrq-c crash reboot to
validate that their changes are working properly.  Perhaps if we added a step to
the submission checklist including the running of said script, we'd see less
hardware specific regressions.

My $0.02
Neil

