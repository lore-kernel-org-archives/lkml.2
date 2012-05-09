Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2EIVeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:34:07 -0400
Received: from fieldses.org ([174.143.236.118]:34271 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667Ab2EIVeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:34:05 -0400
Date: Wed, 9 May 2012 17:34:02 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, swhiteho@redhat.com
Subject: Re: [PATCH 0/6] Get rid of I_MUTEX_QUOTA use
Message-ID: <20120509213402.GA28719@fieldses.org>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
 <20120425212532.GB3251@fieldses.org>
 <20120426132608.GA10368@quack.suse.cz>
 <20120427134752.GD14973@fieldses.org>
 <20120430135434.GB5239@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430135434.GB5239@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 03:54:34PM +0200, Jan Kara wrote:
> On Fri 27-04-12 09:47:52, J. Bruce Fields wrote:
> > On Thu, Apr 26, 2012 at 03:26:08PM +0200, Jan Kara wrote:
> > > On Wed 25-04-12 17:25:32, J. Bruce Fields wrote:
> > > > On Wed, Apr 25, 2012 at 10:57:41PM +0200, Jan Kara wrote:
> > > > > 
> > > > >   Hello,
> > > > > 
> > > > >   this patch set changes generic quota code (and filesystems relying on it)
> > > > > so that they don't use special locking class I_MUTEX_QUOTA. The only remaining
> > > > > user of I_MUTEX_QUOTA is GFS2. If noone has objections, I can merge these
> > > > > patches through my tree or Bruce, you can take them as your work depends
> > > > > on these changes.
> > > > 
> > > > My changes will likely need to go through Al, and depend on GFS2 being
> > > > fixed as well.
> > > > 
> > > > So it's up to Al.  Best might be to just merge it through your tree and
> > > > let us sort it out in the next merge window?
> > >   OK, I've added patches to my tree for now. I also sent a patch for GFS2
> > > but after some investigation that's mostly a cleanup grade and Steven can
> > > merge it independently. Quota inode in GFS2 is hidden system file so there
> > > should be no locking problems with it wrt your patches.
> > 
> > OK.  In that case I suppose I'd like Al to take patches 1-4 of the 5 I
> > posted most recently (followups to
> > http://mid.gmane.org/20120425152041.GA751@fieldses.org), probably after
> > your fixes go in.  I'll resend if necessary after they go in.
>   Yeah. But also please rename I_MUTEX_QUOTA to something better describing
> what's going on...

Yes.  My uncreative replacement is I_MUTEX_NONDIR2 ("a second
non-directory object"), but I'd welcome any more elegant suggestion.

--b.
