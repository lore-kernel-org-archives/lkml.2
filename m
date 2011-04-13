Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab1DMXNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:13:02 -0400
Received: from mail.perches.com ([173.55.12.10]:4695 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab1DMXNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:13:01 -0400
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: "Mark A. Allyn" <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, jayant.mangalampalli@intel.com,
        venkat.r.gokulrangan@intel.com
In-Reply-To: <20110413224621.GA4909@kroah.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
	 <1302731811.11415.38.camel@Joe-Laptop> <20110413222332.GA32013@kroah.com>
	 <1302733836.11415.42.camel@Joe-Laptop>  <20110413224621.GA4909@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 16:12:59 -0700
Message-ID: <1302736379.11415.57.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 15:46 -0700, Greg KH wrote:
> I don't like seeing every individual driver have its own way of handling
> debug macros, that's crazy.

That's your preference not mine.

> For larger stuff like networking, yes, they can do that, and that's
> fine.  They also were doing this before the dev_* macros came along,
> just like USB did, so there is historical precident there.

I added netdev_<level> and netif_<level>.

> But again, not for a new driver, don't redefine the existing macros just
> because you don't like typing a few extra characters...

You are not the driver maintainer and those decisions
are driver maintainer decisions not yours.

Check this out:

$ grep -rP -oh --include=*.[ch] \
	"\b[a-z]+_(dbg|alert|crit|emerg|notice|warn|err|info)\b\s*\(" drivers | \
  sed -e 's/(//g' -r -e 's/\s*//g' | \
  sort | uniq | wc -l
266

Most all of those are different logging forms.

So, not crazy, just not your preference.

I've put in some effort trying to standardize logging
messages and mechanisms as well, and I think

	<prefix>_<level>(struct *, fmt, ..._

is a perfectly good and understandable style.

I do not suggest using some arbitrary prefix just for the
sake of it, only when there is a specific structure that
can be used.

cheers, Joe

