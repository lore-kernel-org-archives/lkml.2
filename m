Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423258Ab2LGRQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:16:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58252 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422952Ab2LGRQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:16:22 -0500
Date: Fri, 7 Dec 2012 09:16:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
Message-ID: <20121207171618.GA18054@kroah.com>
References: <20121122010723.F111E80150@viridian.itc.virginia.edu>
 <20121206002742.80C2A3E0E22@localhost>
 <20121206003923.GA18947@kroah.com>
 <20121207134748.B7C133E0B87@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207134748.B7C133E0B87@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 01:47:48PM +0000, Grant Likely wrote:
> On Wed, 5 Dec 2012 16:39:23 -0800, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Dec 06, 2012 at 12:27:42AM +0000, Grant Likely wrote:
> > > On Wed, 21 Nov 2012 20:07:23 -0500, wfp5p@viridian.itc.virginia.edu (Bill Pemberton) wrote:
> > > > Grant Likely writes:
> > > > > 
> > > > > You mean this series wasn't created with a script? You did this by
> > > > > hand? If so then I must say kudos on your dedication!
> > > > >
> > > > > But it makes me more nervous about the series. Too easy to fat
> > > > > finger many things when touching that many files.
> > > > >
> > > > 
> > > > No, I didn't do them by hand, it was a script.  Originally, it was a
> > > > couple, all basically the same, but removing each __dev*.  Then I'd do
> > > > a word diff to eyeball them to make sure the script didn't do
> > > > something goofy.
> > > > 
> > > > The whack-a-mole part came along because I was working against
> > > > linux-next and whatever patch series was right for one day wouldn't be
> > > > right for the next day because of some of the faster moving trees.
> > > > 
> > > > 
> > > > > Please do write a script and post that for review.
> > > > > 
> > > > 
> > > > The all-in-one version of the script:
> > > > 
> > > > #! /usr/bin/perl
> > > > 
> > > > use strict;
> > > > use IO::InSitu;
> > > > 
> > > > sub processfile
> > > > {
> > > >     my $fn = shift;
> > > > 
> > > >     my ($in, $out) = open_rw($fn, $fn);
> > > > 
> > > >     while (<$in>) {
> > > > 	s|__devexit_p\(([^)]+)\)|$1|;
> > > > 	s|\s__devexit\b||;
> > > > 	s|\s__devinitconst\b||;
> > > > 	s|\s__devinitdata\b||;
> > > > 	s|\s__devinit\b||;
> > > 
> > > Pretty straight forward, and works against the files I tried.  :-)
> > > 
> > > Greg, I'd much rather see the change applied all at once in this manner.
> > > If that isn't possible, then at the least I'll use the script against
> > > the code that I maintain and push th result out to Linus.
> > 
> > Given that there are a lot of patches already in linux-next from Bill
> > due to this work, I'm not going to do this for all files right now,
> > sorry.
> > 
> > But, if you want to use this for the files you maintain and push that
> > out for 3.8-rc1, that would be great.  I'll be walking the tree after
> > 3.8-rc1 is out to catch the stragglers with a script like this.
> 
> Okay. Can you drop any commits you have against drivers/{spi,gpio,of}?

Hm, I only applied the gpio ones to my tree, you got an email when that
happened.  I didn't apply the spi or of ones.

> Or are they in a tree that you will not rebase?

They are in my driver-core.git tree, the driver-core-next branch, which
will not be rebased, and has been in linux-next for a while now.

I can revert the 5 gpio patches if you want me to, just let me know.

thanks,

greg k-h
