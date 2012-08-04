Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2HDD5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 23:57:13 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57208 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2HDD5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 23:57:10 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.46.74
Date: Fri, 3 Aug 2012 20:57:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/get_maintainer.pl: Default to --no-rolestats
 when output not a terminal
Message-ID: <20120804035702.GA2788@leaf>
References: <20120803182706.GA4637@jtriplet-mobl1>
 <1344018801.10710.17.camel@joe2Laptop>
 <20120803184743.GA4660@jtriplet-mobl1>
 <1344040650.10710.22.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344040650.10710.22.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 05:37:30PM -0700, Joe Perches wrote:
> On Fri, 2012-08-03 at 11:47 -0700, Josh Triplett wrote:
> > On Fri, Aug 03, 2012 at 11:33:21AM -0700, Joe Perches wrote:
> > > On Fri, 2012-08-03 at 11:27 -0700, Josh Triplett wrote:
> > > > scripts/get_maintainer.pl defaults to showing --rolestats, which
> > > > provides annotations explaining why each person or list might want to
> > > > know about a patch.  This works well for interactive use, but breaks
> > > > when used with git send-email's --to-cmd or --cc-cmd, resulting in
> > > > malformed email headers and mails sent to some but not all recipients.
> > > > 
> > > > To avoid the need to explicitly pass --no-rolestats for batch use,
> > > > enable --rolestats by default only when outputting to a terminal.
> > > 
> > > Hi Josh.
> > > 
> > > I think it's preferable to add --no-rolestats
> > > to the uses that need them.
> > 
> > Why?
> > 
> > > I have different scripts that I use for git send-email
> > > options --to-cmd and --cc-cmd
> > [...snip scripts...]
> > 
> > You've submitted enough patches that you've automated as much of the
> > process as you can; I don't think that makes the defaults less
> > error-prone.
> 
> I think the default use of the get_maintainer script is
> actually not scripted but interactive, where the user is
> just trying to figure out who the maintainer is.

I agree entirely; that's why I didn't change the default to always use
--no-rolestats, but rather to continue using --rolestats when
interactive and --no-rolestats when scripted.

> > As it stands now, the current default of --rolestats makes the obvious
> > command line of
> > git send-email --to-cmd='scripts/get_maintainer.pl' *.patch
> > send broken emails that go to some maintainers but not all.  I think it
> > makes sense to change the default so that the obvious usage becomes the
> > correct one.
> 
> There were some discussions awhile back in 2010 about the
> preferred defaults.
> 
> Perhaps you can read those discussions about why the default
> is the way it is.

I found commit 7e1863af1636b304a5f59aab6fb78d38e4079875, but that commit
does not serve the intended purpose.  Defaulting to --rolestats doesn't
make it "harder" to use get_maintainer.pl with git send-email, it just
makes it broken when used.  Meanwhile, the few discussions I see about
get_maintainer.pl just mention the problems caused by using --git, and
get_maintainer.pl has already improved to address those problems by not
using git commit signers for patches to files with active maintainers.

I don't see any value in making it intentionally harder to invoke
correctly while making it easier to invoke incorrectly.  Why not make it
actually work?

- Josh Triplett
