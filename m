Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410Ab2C2Xf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:35:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47166 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422Ab2C2XfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:35:09 -0400
Date: Thu, 29 Mar 2012 16:35:06 -0700
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329233506.GG13970@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com>
 <20120329203926.GA13970@thunk.org>
 <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
 <20120329211244.GA18684@redhat.com>
 <20120329214510.GD13970@thunk.org>
 <20120329214959.GA20783@redhat.com>
 <CA+55aFz5Di6K4TzrFrGdyrPQkadt1pkGrWv_9GyaVgUjx_4cwg@mail.gmail.com>
 <20120329225429.GA25320@redhat.com>
 <CA+55aFxwfzRniiTRVysvjnSaMYXQwrk8O8iQ-xdy1DXYxeL+cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwfzRniiTRVysvjnSaMYXQwrk8O8iQ-xdy1DXYxeL+cw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:04:50PM -0700, Linus Torvalds wrote:
> On Thu, Mar 29, 2012 at 3:54 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > 90 mins of 2x kernel builds in parallel along with
> > 3x fsx runs. then my battery ran out.
> >
> > looks like we have a winner.
> 
> Ok, let's revert it. Do you want to write the description of what
> happened, or should I just do it?

How about this:

Commit b43d17f31 (ext4: don't release page refs in ext4_end_bio) is
apprently causing system lockups for a system using a LUKS backed
system partition.  This luckup can be reproduced by running a make -j8
kernel compile in parallel with fsx.

Since the commit in question was fixing a rare and fairly exotic race,
and the lockup was found fairly quickly, it is being reverted as a
regression fix.

						- Ted

P.S.  I've been using 3.3 + the ext4 development tree on my laptop for
a while now, with a LUKS-encrypted+LVM setup on both a SSD and HDD on
a Ubuntu 10.04 based system.  I've not noticed the problem that Dave
is seeing under normal use.  So I'm wondering what was triggering it
on what should have been an idle desktop system in his case.  But this
is definitely a case where we should revert first, and ask questions
later.

Dave, thanks for noticing and reporting this!

