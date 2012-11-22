Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2KVT0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:26:06 -0500
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:46575 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2KVTXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:23:24 -0500
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
To: grant.likely@secretlab.ca (Grant Likely)
Date: Wed, 21 Nov 2012 20:07:23 -0500
Cc: gregkh@linuxfoundation.org (Greg KH),
        akpm@linux-foundation.org (Andrew Morton),
        linux-kernel@vger.kernel.org
In-Reply-To: <99207e4d-1982-42da-9a4a-9df91d719eb5@email.android.com>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121122010723.F111E80150@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely writes:
> 
> You mean this series wasn't created with a script? You did this by
> hand? If so then I must say kudos on your dedication!
>
> But it makes me more nervous about the series. Too easy to fat
> finger many things when touching that many files.
>

No, I didn't do them by hand, it was a script.  Originally, it was a
couple, all basically the same, but removing each __dev*.  Then I'd do
a word diff to eyeball them to make sure the script didn't do
something goofy.

The whack-a-mole part came along because I was working against
linux-next and whatever patch series was right for one day wouldn't be
right for the next day because of some of the faster moving trees.


> Please do write a script and post that for review.
> 

The all-in-one version of the script:

#! /usr/bin/perl

use strict;
use IO::InSitu;

sub processfile
{
    my $fn = shift;

    my ($in, $out) = open_rw($fn, $fn);

    while (<$in>) {
	s|__devexit_p\(([^)]+)\)|$1|;
	s|\s__devexit\b||;
	s|\s__devinitconst\b||;
	s|\s__devinitdata\b||;
	s|\s__devinit\b||;

	print $out $_;
    }

    close $in;
    close $out;
}

foreach my $fn (@ARGV) {
    processfile($fn);
}


-- 
Bill
