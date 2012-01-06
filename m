Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2AFCNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:13:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:3145 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278Ab2AFCM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:12:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="95026346"
Date: Fri, 6 Jan 2012 10:12:48 +0800
From: Feng Tang <feng.tang@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] time: remove the unnecessary
 CONFIG_GENERIC_CLOCKEVENS check
Message-ID: <20120106021248.GA2691@feng-i7>
References: <1325770085-5162-1-git-send-email-feng.tang@intel.com>
 <1325770085-5162-2-git-send-email-feng.tang@intel.com>
 <1325762266.1807.9.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325762266.1807.9.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, 

On Thu, Jan 05, 2012 at 12:17:46PM +0100, Paul Bolle wrote:
> On Thu, 2012-01-05 at 21:28 +0800, Feng Tang wrote:
> > In kernel/time/Kconfig:
> > config GENERIC_CLOCKEVENTS_BUILD
> > 	bool
> > 	default y
> > 	depends on GENERIC_CLOCKEVENTS
> > 
> > So there is no need to check CONFIG_GENERIC_CLOCKEVENTS if the
> > CONFIG_GENERIC_CLOCKEVENTS_BUILD is defined already.
> 
> This is only true because nothing selects GENERIC_CLOCKEVENTS_BUILD
> directly, isn't it?

Thanks for pointing this out, your concern is valid, even though there
will be a warning message about the dependency corruption if the
GENERIC_CLOCKEVENTS_BUILD is directly selected while the 
GENERIC_CLOCKEVENTS is N.

Thanks,
Feng

> So if we're being strict the patch explanation
> should mention that.
> 
> (Maybe it's even better to simply state
>     There is no need to check CONFIG_GENERIC_CLOCKEVENTS if
>     CONFIG_GENERIC_CLOCKEVENTS_BUILD is defined.
> 
>     This prepares [...]
> 
> as that would tell us just enough.)
> 
> > This prepares for the total removal of GENERIC_CLOCKEVENTS_BUILD.
> 
> 
> Paul Bolle
