Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0J0FDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 01:03:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51418 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0J0FDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 01:03:11 -0400
Date: Wed, 27 Oct 2010 07:03:08 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        kernel-janitors@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/14] drivers/platform/x86/thinkpad_acpi.c: delete double
 assignment
In-Reply-To: <20101027010908.GA29299@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.1010270658480.31668@ask.diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-9-git-send-email-julia@diku.dk> <20101027010908.GA29299@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Henrique de Moraes Holschuh wrote:

> On Tue, 26 Oct 2010, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Delete successive assignments to the same location.
> 
> There are often results of mismerges or other assorted screw ups, often
> done by the maintainer itself (e.g. me in thinkpad-acpi's case) during
> development.
> 
> The patch is correct, and I thank you for the head's up.  But let me
> track down what caused it first, hmm?  I also highly recommend that this
> should be done in all cases you find, instead of just blindly fixing the
> assignment.  I suggest using git --blame to track down what added the
> duplicated assignments, and check if it looks sane...
> 
> It is often a VERY BAD IDEA to remove such markers of potential
> brokennes without checking out if they're actually helpfully trying to
> warn you of worse badness :p
> 
> But hey, maybe you've already done that.  If you did, I apologise for
> preaching to the choir.

I didn't look for the original source of the problem, except in the case 
of [PATCH 6/14] arch/mips/pmc-sierra/yosemite/setup.c where I found it 
already in the pre-git era.  Thanks fo rthe suggestion.  On the other 
hand, I was very selective about which code I changed.  In particular I 
left a number of cases like:

x = NULL; // or 0 etc
x = foo(...); // ie a NULL returning function

I figured that this isn't hurting anything, and perhaps it is informative 
about what kind of value foo might return.

julia
