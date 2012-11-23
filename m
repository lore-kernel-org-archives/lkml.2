Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2KWOOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:14:16 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:63707 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753652Ab2KWOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:14:15 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19M7KeFhRBQTGE86O1sLkY65jYtJ80WJEw=
Date: Fri, 23 Nov 2012 09:13:52 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Axel Lin <axel.lin@ingics.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/4] Dove pinctrl fixes and DT enabling
Message-ID: <20121123141352.GK15800@titan.lakedaemon.net>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
 <50ACAAF5.2030002@gmail.com>
 <CACRpkdYzQuv8sPk57CvqiwMmV0z007cGqVkGOENmr_aYAN14=Q@mail.gmail.com>
 <20121121155208.GF22106@titan.lakedaemon.net>
 <CACRpkdYXSR7Fv95bCPSTZiUHgV+jwnVw1MraE_73njNa807wnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYXSR7Fv95bCPSTZiUHgV+jwnVw1MraE_73njNa807wnQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 08:49:04AM +0100, Linus Walleij wrote:
> On Wed, Nov 21, 2012 at 4:52 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Wed, Nov 21, 2012 at 03:45:42PM +0100, Linus Walleij wrote:
> 
> >> So what I mean is that the patches creating pinctrl/mvebu is in the
> >> pinctrl tree, so if patches in the MVEBU tree depend on these,
> >> then it must have pulled in a branch from pinctrl or applied the
> >> same patches in that tree too (which is OK *sometimes*).
> >
> > Yes, Thomas and Gregory informed me of the pinctrl dependency and said
> > they were using for-next from the pinctrl tree.  I've used that branch
> > to merge and build successfully.  Is that ok in practice or is there a
> > more specific branch I should pull in as a dependency?
> 
> Do not use for-next. That is a mix-down for the linux-next tree.

Ok, I wasn't comfortable with that.  Thanks for the explaination.

> It is basically created like this:
> 
> git checkout for-next
> git reset --hard fixes
> git merge devel
> 
> fixes will be based on the latest release candidate and devel on
> something older like -rc1, -rc2.
> 
> If you pull something in it must be from the devel branch.

ok.

> The ebst idea is to take the last commit in the devel branch
> that you need, so the last mvebu commit in that branch.
> This is what the ARM SoC guys usually does.
> 
> So: git pull <pinctrl tree> devel
> git log ...
> <find the commit you need e.g 10930572>
> git checkout -b my-new-mvebu-stuff 10930572
> 
> So you branch off where you have the deps you
> need.

That makes sense.  I also need:

gpiolib: fix bug and clarify OF use of ranges

I'll let you know if I run into any trouble.

thx,

Jason.
