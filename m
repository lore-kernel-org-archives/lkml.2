Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2BOMmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 07:42:46 -0500
Received: from fieldses.org ([174.143.236.118]:44014 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab2BOMmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 07:42:42 -0500
Date: Wed, 15 Feb 2012 07:42:30 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] locks: export device name
Message-ID: <20120215124230.GA11393@fieldses.org>
References: <1328907967.3138.1.camel@offbook>
 <20120213163425.dd9adfde.akpm@linux-foundation.org>
 <20120214190906.GA5115@fieldses.org>
 <1329303162.3356.6.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329303162.3356.6.camel@offbook>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 11:52:42AM +0100, Davidlohr Bueso wrote:
> On Tue, 2012-02-14 at 14:09 -0500, J. Bruce Fields wrote:
> > On Mon, Feb 13, 2012 at 04:34:25PM -0800, Andrew Morton wrote:
> > > I don't get it.  This is an immediate and non-back-compatible change to
> > > the format of /proc/locks.  The only way this can avoid breaking things
> > > is if there are no programs or scripts in use by anyone which use
> > > this field.  What am I missing here?
> > 
> > I'm a little surprised anything parses that file.
> 
> To my knowledge only lslk - but the whole point here is that its going
> to be replaced by lslocks.
> 
> > 
> > But, yes, looks like I can "yum install" lslk on Fedora 16, as an
> > example.  Can't get it to do anything useful, though.  Does it actually
> > work on any recent distro?
> 
> It works on Ubuntu's latest release.

OK, in that case I'm with Andrew, we'd need to do this more carefully.

People should be able to use something like a recent Ubuntu release to
test more recent kernels, and we don't want their tools to break when we
do that.

> > Perhaps safest would be to replace /proc/locks by another interface and
> > deprecate this one.
> 
> If exporting the name in the current /proc/locks file is out of the
> question, then IMHO I don't think it would be worth adding a new
> interface just for such a small change.

OK.

If you want to just change this over, I guess the thing to do would be
to stick something in feature-removal-schedule.txt saying "we'll switch
this in 2 years" (or however long you think before there are
realistically no more lslk users left), then do it then.

Switching to a new api would be better as we could warn users of the old
api then.  Maybe it'd be worth it if there was some other change we'd
been wanting to make?   Can't think of anything off the top of my head.

We may be adding more lock types--will lslk and lslocks handle that
gracefully?

--b.
