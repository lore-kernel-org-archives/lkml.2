Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2CEGwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:52:41 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:47586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2CEGwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:52:39 -0500
Subject: Re: iwlwifi WPA-TKIP crypto failure after group rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, 651199@bugs.debian.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Gustafsson <olangu@impressions.se>,
        "Marco d'Itri" <md@Linux.IT>, Gabriel Kerneis <kerneis@pps.jussieu.fr>,
        Shawn Thompson <shawn@projektenterprises.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20120305045334.GF30344@burratino> (sfid-20120305_055451_570064_79E67075)
References: <1330320802.8460.105.camel@deadeye>
	 <1330333354.3483.6.camel@jlt3.sipsolutions.net>
	 <20120305045334.GF30344@burratino> (sfid-20120305_055451_570064_79E67075)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 07:52:23 +0100
Message-ID: <1330930343.3545.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >> To summarise, a WPA-TKIP managed connection stops passing traffic and
> >> the kernel log shows the message "WPA: Group rekeying".  This apparently
> >> doesn't happen if the connection is in heavy use at the time or with
> >> module parameter swcrypto=1.  WPA2 is not affected either.
> >
> > I think this is due to my patch "iwlagn: rewrite HW crypto" which
> > accidentally broke key *removal* (of all things), which causes issues
> > when the first GTK is removed on the second rekeying.
> >
> > This patch
> > [...]h=5dcbf480473f6c3f06ad2426b7517038a2a18911
> >
> > should fix it. Wey has sent it to John
> [...]
> > it's also marked for stable.
> 
> Shawn Thompson (cc-ed) tested the patch against 3.2.9 and 3.3-rc6 and
> found it to work[1].  What can interested people do to help usher this
> into mainline?

Great, thanks for testing. The patch is already on the way into mainline
with a Cc:stable tag, so I don't think there's anything to do at this
point.

johannes

