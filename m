Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946012Ab2JYNvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:51:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57480 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935668Ab2JYNu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:50:59 -0400
Date: Thu, 25 Oct 2012 09:50:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Vladislav Bolkhovitin <vvvvvst@gmail.com>,
        =?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121025135044.GA13562@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Vladislav Bolkhovitin <vvvvvst@gmail.com>,
	=?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	drh@hwaci.com
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
 <m2fw5mtffg.fsf_-_@firstfloor.org>
 <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
 <5086F5A7.9090406@vlnb.net>
 <20121025051445.GA9860@thunk.org>
 <20121025140325.49cd7c79@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025140325.49cd7c79@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:03:25PM +0100, Alan Cox wrote:
> 
> I doubt they care. The profit on high end features from the people who
> really need them I would bet far exceeds any other benefit of giving it to
> others. Welcome to capitalism 8)

Yes, but it's a question of pricing.  If they had priced it a just a
wee bit higher, then there would have been incentive to add support
for TCQ so it could actually be used into various Linux file systems,
since there would have been lots of users of it.  But as it is, the
folks who are purchasing huge, vast number of these drives --- such as
at the large cloud providers: Amazon, Facebook, Racespace, et. al. ---
will choose to purchase large numbers of commodity drives, and then
find ways to work around the missing functionality in userspace.  For
example, DIF/DIX would be nice, and if it were available for cheap, I
could imagine it being used.  But you can accomplish the same thing in
userspace, and in fact at Google I've implemented a special
not-for-mainline patch which spikes out stable writes (required for
DIF/DIX) because it has significant performance overhead, and DIF/DIX
has zero benefit if you're not willing to shell out $$$ for hardware
that supports it.

Maybe the HDD manufacturers have been able to price guage a small
number enterprise I/T shops with more dollars than sense, but
personally, I'm not convinced they picked an optimal pricing
strategy....

Put another way, I accept that Toyota should price a Lexus ES more
than a Camry, but if it's priced at say, 3x the price of a Camry
instead of 20%, they might find that precious few people are willing
to pay that kind of money for what is essentially the same car with
minor luxury tweaks added to it.

> Plus - spinning rust for those end users is on the way out, SATA to flash
> is a bit of hack and people are already putting a lot of focus onto
> things like NVM Express.

Yeah....  I don't buy that.  One, flash is still too expensive.  Two,
the capital costs to build enough Silicon foundries to replace the
current production volume of HDD's is way too expensive for any
company to afford (the cloud providers are buying *huge* numbers of
HDD's) --- and that's assuming companies wouldn't chose to use those
foundries for products with larger margins --- such as, for example,
CPU/GPU chips. :-) And third and finally, if you study the long-term
trends in terms of Data Retention Time (going down), Program and Read
Disturb (going up), and Write Endurance (going down) as a function of
feature size and/or time, you'd be wise to treat flash as nothing more
than short-term cache, and not as a long term stable store.

If end users completely give up on flash, and store all of their
precious family pictures on flash storage, after a couple of years,
they are likely going to be very disappointed....

Speaking personally, I wouldn't want to have anything on flash for
more than a few months at *most* before I made sure I had another copy
saved on spinning rust platters for long-term retention.

      	 	       		    	      - Ted
