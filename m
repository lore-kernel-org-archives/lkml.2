Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1GEQjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:39:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab1GEQjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:39:36 -0400
Date: Tue, 5 Jul 2011 09:36:28 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110705163628.GB31984@suse.de>
References: <20110704170949.11059.92774.stgit@ponder>
 <20110704180159.GA11278@ponder.secretlab.ca>
 <20110705142149.GA3498@suse.de>
 <201107051721.02079.arnd@arndb.de>
 <20110705155040.GB16682@suse.de>
 <CAPXgP12eg1diui_78rqaVijKbxvRcpZhsC35i9w_Js9vr2OGWA@mail.gmail.com>
 <CACxGe6sypBwP6aKoaxq1ipoEfqvnqq2RMhi9d0KU=LHjJm9x_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6sypBwP6aKoaxq1ipoEfqvnqq2RMhi9d0KU=LHjJm9x_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:28:37AM -0600, Grant Likely wrote:
> On Tue, Jul 5, 2011 at 10:11 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Tue, Jul 5, 2011 at 17:50, Greg KH <gregkh@suse.de> wrote:
> >
> >> I wonder if doing this all from a workqueue in the first place is going
> >> to cause problems as probe isn't normally done this way at all.
> >
> > Yeah, I would expect unforeseen problems with the async thread too.
> > It's probably all solvable, but it sounds troublesome to find out if
> > things go wrong.
> >
> > We have sync hooks (BUS_NOTIFY_*) where any kind of code can subscribe
> > to when devices get added or get bound to a driver. Can't the code
> > that relies on later hookups to already existing devices/bindings not
> > just plug into that?
> 
> I tried that.  It resulted in a lot of complexity that each driver
> needs to implement correctly which is why I started looking for a
> different way to go about it.

No, the bus that wants this just has to do it, not the drivers
themselves, right?


