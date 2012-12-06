Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2LFA1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:27:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44722 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LFA1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:27:47 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20121122010723.F111E80150@viridian.itc.virginia.edu>
References: <20121122010723.F111E80150@viridian.itc.virginia.edu>
Date: Thu, 06 Dec 2012 00:27:42 +0000
Message-Id: <20121206002742.80C2A3E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 20:07:23 -0500, wfp5p@viridian.itc.virginia.edu (Bill Pemberton) wrote:
> Grant Likely writes:
> > 
> > You mean this series wasn't created with a script? You did this by
> > hand? If so then I must say kudos on your dedication!
> >
> > But it makes me more nervous about the series. Too easy to fat
> > finger many things when touching that many files.
> >
> 
> No, I didn't do them by hand, it was a script.  Originally, it was a
> couple, all basically the same, but removing each __dev*.  Then I'd do
> a word diff to eyeball them to make sure the script didn't do
> something goofy.
> 
> The whack-a-mole part came along because I was working against
> linux-next and whatever patch series was right for one day wouldn't be
> right for the next day because of some of the faster moving trees.
> 
> 
> > Please do write a script and post that for review.
> > 
> 
> The all-in-one version of the script:
> 
> #! /usr/bin/perl
> 
> use strict;
> use IO::InSitu;
> 
> sub processfile
> {
>     my $fn = shift;
> 
>     my ($in, $out) = open_rw($fn, $fn);
> 
>     while (<$in>) {
> 	s|__devexit_p\(([^)]+)\)|$1|;
> 	s|\s__devexit\b||;
> 	s|\s__devinitconst\b||;
> 	s|\s__devinitdata\b||;
> 	s|\s__devinit\b||;

Pretty straight forward, and works against the files I tried.  :-)

Greg, I'd much rather see the change applied all at once in this manner.
If that isn't possible, then at the least I'll use the script against
the code that I maintain and push th result out to Linus.

g.

