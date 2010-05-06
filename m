Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab0EFQwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:52:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1943 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0EFQwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:52:37 -0400
Subject: Re: indiscriminate get_maintainer.pl usage
From: Joe Perches <joe@perches.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1005060826460.10407@makko.or.mcafeemobile.com>
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
	 <4BE25AE8.1060607@s5r6.in-berlin.de>
	 <s2t412e6f7f1005052319sdbf3fdfbg256d11b983c4f304@mail.gmail.com>
	 <4BE26472.6040805@s5r6.in-berlin.de>
	 <alpine.DEB.2.00.1005060826460.10407@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 09:52:35 -0700
Message-ID: <1273164755.1537.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 08:42 -0700, Davide Libenzi wrote:
> On Thu, 6 May 2010, Stefan Richter wrote:
> > > I should add --nogit option.
> > The script does get some useful information out of git (but obviously
> > also some questionable).

Stefan, I think that's the price you pay for fame.
Try to do good, get more unsolicited email.

> > --roles and --rolestats give away some more data...
> > $ scripts/get_maintainer.pl --rolestats -f fs/eventpoll.c
> > Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS...)
> > Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/6=33%)
> > "Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/6=33%)
> > Davide Libenzi <davidel@xmailserver.org> (commit_signer:2/6=33%)
> > Roland Dreier <rolandd@cisco.com> (commit_signer:1/6=17%)
> > Stefan Richter <stefanr@s5r6.in-berlin.de> (commit_signer:1/6=17%)
> > linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...)
> > linux-kernel@vger.kernel.org (open list)
> > 
> > ...but still don't distinguish between signed-off-by or reviewed-by on
> > one hand, and reported-by and tested-by on the other hand.  Cc'ing a
> > reporter or tester would only make sense if the patch changes something
> > that directly affects the reporter's/ tester's setup, e.g. reworks a
> > provisional fix.
> 
> I have always maintained that code w/out the need of explicit entry in the 
> MAINTAINERS file.  For isolated files people usually include the copyright 
> owners and the ones listed in the comment header in general.
> No problem in being explicitly listed if this causes noise during bug 
> reporting.

There is also the --git-blame option for patches, but blame
is also only a semi-useful tool, as it could show cleanup patches
on individual as authors.

Another option to get_maintainers is --file-emails which looks
inside a file for email addresses.

Right now, the default for # of git commits signed to be
added to the CC list is 1.  It's possible to change the default.

    --git-min-signatures => number of signatures required (default: 1)
    --git-max-maintainers => maximum maintainers to add (default: 5)
    --git-min-percent => minimum percentage of commits required (default: 5)

Maybe some fine-tuning of the defaults could be useful.

Suggestions?

