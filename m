Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2CYUv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:51:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:49023 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab2CYUv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:51:58 -0400
Message-ID: <1332708684.2882.24.camel@pasglop>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Date: Mon, 26 Mar 2012 07:51:24 +1100
In-Reply-To: <4F6EEEC1.4030608@redhat.com>
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>
	 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
	 <4F6EEEC1.4030608@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-25 at 12:09 +0200, Avi Kivity wrote:

> Well I've been doing this ever since I moved to git.  The motivation was
> actually to make things easier for patch authors by allowing them to
> work against a tree of all applied patches, while the update for the
> next merge window is just a subset, with more fixes going into the merge
> window even late in the cycle, and features being deferred to the next
> one.  I also fold fixes or reverts into their parent patches to improve
> bisectability.
> 
> I can switch to fast-forward-only in the future, but I'm afraid that
> this particular tree is broken for good.  The un-rebased
> fast-forward-only source for this is kvm.git master, which I don't think
> you want to pull.  It will cause every kvm commit to appear twice and
> confuse everyone. 

The problem is that it makes it very hard if not impossible to work
with a combination of your tree & other trees (for example at some point
I had to work on a merge of alex'tree, powerpc-next and pci-next).

I don't see the problem with using the standard way and having
sub-maintainers/developers.... Most of my sub-maintainers work on top of
some upstream or they branch off my -next branch (which is known to
never be rebased, so it's resync'ed as soon as Linux pulls it). Dealing
with branches & merges in git is trivial and easier than dealing with
the clashes caused by the rebases :-)

One thing I do, is to also sometimes put out a powerpc-test branch that
people know can and will be rebased, it's purely there if I want some
folks to test a bunch of stuff but without basing their own work on top
of it.

And yes, there's a drawback vs. bisectability. You can still fold-in if
you pickup patches from the list (vs pulling from sub-maintainers) as
long as you haven't committed them to a "non-rebase" branch (ie, you can
let things stage in a test branch for example for a couple of weeks to
flush out those issues).

Cheers,
Ben.


