Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1DTRUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:20:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab1DTRUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:20:39 -0400
Date: Wed, 20 Apr 2011 09:15:13 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: Greg KH <greg@kroah.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com
Subject: Re: [PATCH v2] driver core: let dev_set_drvdata return int instead
 of void as it can fail
Message-ID: <20110420161513.GA25396@suse.de>
References: <BANLkTi=MjDqawZx=+fKjaAs5SPfGQDEgVQ@mail.gmail.com>
 <1302547378-14639-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110419235812.GA4619@kroah.com>
 <BANLkTi=q8jfEaLByZVZPHHYp_5PTK-36cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=q8jfEaLByZVZPHHYp_5PTK-36cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 11:09:56AM +0200, Michał Mirosław wrote:
> 2011/4/20 Greg KH <greg@kroah.com>:
> > On Mon, Apr 11, 2011 at 08:42:58PM +0200, Uwe Kleine-König wrote:
> >> Before commit
> >>
> >>       b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
> >>
> >> calling dev_set_drvdata with dev=NULL was an unchecked error. After some
> >> discussion about what to return in this case removing the check (and so
> >> producing a null pointer exception) seems fine.
> > I'm confused by this thread, care to resend all of these in a series
> > against the latest linux-next tree?
> 
> I'd argue that dev_set_drvdata() should never fail. All current
> drivers depend on this, and if dev_set_drvdata() fails, user will get
> an OOPS a short while after the device finishes initializing (or maybe
> even before that if callbacks are involved).
> Allowing dev_set_drvdata() to fail will need putting a lot of
> boilerplate code into drivers for no real gain.
> 
> Please consider reverting commit
> b4028437876866aba4747a655ede00f892089e14 instead of "fixing" issues it
> generates.

That patch was from 2009, surely if there were real issues with that
change, it would have shown up in the past 2 years, right?

And no, I don't want to revert that, we need that for future work in
this area.

I have no problem migrating the error code for that function on down,
very few drivers call this function directly, it should be wrapped by
bus-specific functions instead, right?  They can handle the error
handling on their own and not force the individual drivers to handle it
if needed.

Have you ever seen this function fail?

thanks,

greg k-h
