Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2HCSrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:47:51 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53119 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2HCSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:47:50 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 173.246.103.110
Date: Fri, 3 Aug 2012 11:47:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/get_maintainer.pl: Default to --no-rolestats
 when output not a terminal
Message-ID: <20120803184743.GA4660@jtriplet-mobl1>
References: <20120803182706.GA4637@jtriplet-mobl1>
 <1344018801.10710.17.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344018801.10710.17.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:33:21AM -0700, Joe Perches wrote:
> On Fri, 2012-08-03 at 11:27 -0700, Josh Triplett wrote:
> > scripts/get_maintainer.pl defaults to showing --rolestats, which
> > provides annotations explaining why each person or list might want to
> > know about a patch.  This works well for interactive use, but breaks
> > when used with git send-email's --to-cmd or --cc-cmd, resulting in
> > malformed email headers and mails sent to some but not all recipients.
> > 
> > To avoid the need to explicitly pass --no-rolestats for batch use,
> > enable --rolestats by default only when outputting to a terminal.
> 
> Hi Josh.
> 
> I think it's preferable to add --no-rolestats
> to the uses that need them.

Why?

> I have different scripts that I use for git send-email
> options --to-cmd and --cc-cmd
[...snip scripts...]

You've submitted enough patches that you've automated as much of the
process as you can; I don't think that makes the defaults less
error-prone.  Given that you've had to explicitly add --no-rolestats to
your scripts, that seems like evidence in *favor* of making this change.

As it stands now, the current default of --rolestats makes the obvious
command line of
git send-email --to-cmd='scripts/get_maintainer.pl' *.patch
send broken emails that go to some maintainers but not all.  I think it
makes sense to change the default so that the obvious usage becomes the
correct one.

- Josh Triplett
