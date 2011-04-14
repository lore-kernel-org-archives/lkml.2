Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab1DNOrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:47:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:10925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758816Ab1DNOrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:47:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,211,1301900400"; 
   d="scan'208";a="628580191"
From: "Allyn, Mark A" <mark.a.allyn@intel.com>
To: Joe Perches <joe@perches.com>, Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Mangalampalli, Jayant" <jayant.mangalampalli@intel.com>,
        "Gokulrangan, Venkat R" <venkat.r.gokulrangan@intel.com>,
        "Cox, Alan" <alan.cox@intel.com>, "Gross, Mark" <mark.gross@intel.com>,
        "Beare, Bruce J" <bruce.j.beare@intel.com>
Date: Thu, 14 Apr 2011 08:46:47 -0600
Subject: RE: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Thread-Topic: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Thread-Index: Acv6MFX30407cQUeQtelFGlKVSLuggAgi2og
Message-ID: <8A0E4C92AE2D6D40AF99653191DA32316154CEF1CF@rrsmsx501.amr.corp.intel.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
	 <1302731811.11415.38.camel@Joe-Laptop> <20110413222332.GA32013@kroah.com>
	 <1302733836.11415.42.camel@Joe-Laptop>  <20110413224621.GA4909@kroah.com>
 <1302736379.11415.57.camel@Joe-Laptop>
In-Reply-To: <1302736379.11415.57.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Joe Perches [mailto:joe@perches.com] 
Sent: Wednesday, April 13, 2011 4:13 PM
To: Greg KH
Cc: Allyn, Mark A; linux-kernel@vger.kernel.org; alan@linux.intel.com; Mangalampalli, Jayant; Gokulrangan, Venkat R
Subject: Re: Re-send (What else needs to be done to the sep driver (staging/sep))

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


==================================

I am adding Alan Cox, Mark Gross, and Bruce Beare into the discussion.

I will not do anything to change the logging in this driver until I get
better clarification from Mark, Alan, and Bruce as well as Greg.

Thanks

Mark Allyn
