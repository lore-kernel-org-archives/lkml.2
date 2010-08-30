Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0H3SGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:06:44 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0H3SGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:06:42 -0400
Subject: Re: [PATCH] wireless extensions: fix kernel heap content leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Kees Cook <kees.cook@canonical.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <20100830180302.GM4703@outflux.net>
References: <20100827210240.GC4703@outflux.net>
	 <20100827212254.GB32275@bougret.hpl.hp.com>
	 <1283158058.3691.10.camel@jlt3.sipsolutions.net>
	 <1283158704.3691.11.camel@jlt3.sipsolutions.net>
	 <1283162341.3691.45.camel@jlt3.sipsolutions.net>
	 <1283163894.3691.48.camel@jlt3.sipsolutions.net>
	 <20100830180302.GM4703@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 20:06:30 +0200
Message-ID: <1283191590.3694.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 11:03 -0700, Kees Cook wrote:
> Hi Johannes,
> 
> On Mon, Aug 30, 2010 at 12:24:54PM +0200, Johannes Berg wrote:
> > --- wireless-testing.orig/net/wireless/wext-compat.c	2010-08-30 12:04:57.000000000 +0200
> > +++ wireless-testing/net/wireless/wext-compat.c	2010-08-30 12:11:32.000000000 +0200
> > @@ -1420,6 +1420,9 @@ int cfg80211_wext_giwessid(struct net_de
> >  {
> >  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> >  
> > +	data->flags = 0;
> > +	data->length = 0;
> > +
> >  	switch (wdev->iftype) {
> >  	case NL80211_IFTYPE_ADHOC:
> >  		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
> 
> Thanks for all your work on this! Were you able to trigger the leak
> through cfg80211? If so, then this will need a CVE assigned and sent to
> stable too, I think.

Yes, I was, very easily, by doing an SIOCGIWESSID while unassociated,
with a large iwq->length set by userspace. I did CC stable on my patch,
but we can amend the commit by a CVE if so desired.

johannes

