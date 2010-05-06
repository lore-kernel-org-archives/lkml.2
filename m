Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab0EFUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:52:31 -0400
Received: from mail.perches.com ([173.55.12.10]:1956 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab0EFUwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:52:30 -0400
Subject: Re: indiscriminate get_maintainer.pl usage
From: Joe Perches <joe@perches.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1005061056300.2642@makko.or.mcafeemobile.com>
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
	 <4BE25AE8.1060607@s5r6.in-berlin.de>
	 <s2t412e6f7f1005052319sdbf3fdfbg256d11b983c4f304@mail.gmail.com>
	 <4BE26472.6040805@s5r6.in-berlin.de>
	 <alpine.DEB.2.00.1005060826460.10407@makko.or.mcafeemobile.com>
	 <1273164755.1537.40.camel@Joe-Laptop.home>
	 <alpine.DEB.2.00.1005061056300.2642@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 13:52:28 -0700
Message-ID: <1273179148.1537.145.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 10:59 -0700, Davide Libenzi wrote:
> > Right now, the default for # of git commits signed to be
> > added to the CC list is 1.  It's possible to change the default.
> >     --git-min-signatures => number of signatures required (default: 1)
> >     --git-max-maintainers => maximum maintainers to add (default: 5)
> >     --git-min-percent => minimum percentage of commits required (default: 5)
> > Maybe some fine-tuning of the defaults could be useful.
> > Suggestions?
> (not knowing the get_maintainers internals ...)
> Maybe if you weigh each contributor by the amount (in terms of diffstat 
> modulo) of changes, you can get more accurate results.

That might tend to overweight cleanup against actual logic patches,
especially as the period for commits tracked is defaulted to 1 year. 

> Part of the weight might be related to the time distance
> (relative to current time) since the changeset.

Which is kind of what activity alone does.

I think get_maintainer with --git (the default):

Without a named MAINTAINER:

For relatively active files: works moderately well.

For relatively inactive files: might work less well.

It tends to hide the original developer and show people
that submit cleanup or fix patches.

Maybe the --git portion could be reduce the number of
commit signers added when files have named MAINTAINERS.

Without named MAINTAINERS, maybe the file should be
inspected for author info and those persons added.

If the original commit is after Linus' first wholesale
commit of 2.6.12, maybe the first git author should be
added.

Dunno.  I think any of those might be slight improvements,
but get_maintainers isn't really that much of an issue
as-is.  I think it more important to get the correct
MAINTAINERS entries and file patterns.


