Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab0HEAEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:04:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60433 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab0HEAEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:04:21 -0400
To: Michael Neuling <mikey@neuling.org>
Cc: Simon Horman <horms@verge.net.au>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
References: <20100804070647.GB24064@verge.net.au>
	<m17hk6de62.fsf@fess.ebiederm.org> <30114.1280963486@neuling.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 17:04:14 -0700
In-Reply-To: <30114.1280963486@neuling.org> (Michael Neuling's message of "Thu\, 05 Aug 2010 09\:11\:26 +1000")
Message-ID: <m1vd7q0vsx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> writes:

>> > After all the excitement of relocating kexec-tools from
>> > one location on kernel.org to another last week it was
>> > suggested to me by Michael Neuling that the merging
>> > kexec-tools into the kernel tree would be a good idea.
>> >
>> > Given that there have been a bunch of issues with kexec
>> > on power that this would resolve. and there is precedence
>> > for tools in the kernel tree, this sounds entirely reasonable to me.
>> > So with my kexec-tools maintainer hat on, I would like to start
>> > a conversation about this.
>> 
>> What are the issues with kexec on power?  Did someone fail to maintain
>> ABI compatibility?
>> 
>> The interface isn't even supposed to be linux specific, so I can't
>> imagine what would motivate moving this into the kernel tree.
>> 
>> I'm afraid that someone has a good answer for why their lives would be
>> simpler if /sbin/kexec was in the kernel tree and I will be absolutely
>> horrified and about someones stupidity when I hear that answer.
>
> I may have misrepresented how bad it is for power to Horms.  None of the
> issues would be solved by a merge, but it would make life easier IMHO.
>
> In power we've added features to kexec which have required changes to
> both the kernel and kexec-tools.  These have been backwards compatible,
> so not to break to the ABI.  The problem here is getting users and
> distros to take the correct versions of both sources if they want this
> new feature.

I'm still scratching my head.  What new features were added recently
that required this work?  The device tree or something else?

What you are describing seems to be the case for adding any new kernel
feature.

> Similarly with bugs.  We recently went through a round of bug fixes for
> new larger power7 machines.  We found bugs in both kexec-tools and the
> kernel.  That meant we had to ensure users and distros were getting
> correctly updated versions of both tools.
>
> Neither of these problems are show stoppers or power specific but I
> think it would make life easier in these scenarios if the sources were
> merged.  We could just tell users and distros to grab (say) 2.6.35
> sources and we'd know they'd be right for both userspace and the kernel.

You are proposing optimizing for change when change should and generally
is infrequent?

> Also, I think kexec-tools would benefit from the same release process as
> the kernel, with a merge window followed by bug fixes.  Of course,
> kexec-tools doesn't need to be in the kernel for this, but it might be
> easier for Horms to enforce if it was.  kexec-tools only gets a trickle
> patches.

You would like to see a higher barrier to entry for your patches to make
it into /sbin/kexec?  Someone else to help you test so that you get fewer
buggy patches into releases?

> I'd also hope that kexec-tools would get some addition community
> exposure and TLC if they were in the kernel sources.
>
> My question is, why not?  What qualifies a tool to be added to tools/?
> I think kexec-tools are tied to the kernel at least as much as perf is.
> Certainly the ABI for the image we are booting into is not Linux
> specific, but should that disqualify it from being in tools/?

The grand and glorious vision for /sbin/kexec is that it can boot any
interesting OS kernel.  From RHEL, SLES, Fedora, Unbuntu definitely,
but also the BSDs, Mac OS X, and Windows.  I don't see how moving into
the kernel tree making that vision any easier.  Do I need a different
version of kexec to boot an Ubunutu kernel versus a RHEL kernel,
versus a kernel.org kernel?

On the flip side of it in general kexec should not be assumed to be
the only boot loader using various kernel interfaces.  So when you add
a new feature sure add the feature to /sbin/kexec but don't forget
someone eventually will want that feature in another boot loader as
well.

I can imagine arguments for putting the sources for /sbin/kexec into
the kernel tree but I don't see them being made here.

If we talk about analyzing and filtering crash dumps, I can totally
see an argument for putting something under tools/ if the authors of
mkdumpfile and crash are interested.  Those tools fundamentally really
do follow kernel internals.

I may be dense but I don't how everything will be better if sprinkled
with penguin pee.

Eric
