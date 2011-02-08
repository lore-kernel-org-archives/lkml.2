Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab1BHQs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:48:26 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56504 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1BHQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:48:25 -0500
Date: Wed, 9 Feb 2011 01:48:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110208164822.GA7426@linux-sh.org>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102072300.03986.rjw@sisk.pl> <20110207222350.GA24804@core.coreip.homeip.net> <201102080005.40448.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102080005.40448.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 12:05:40AM +0100, Rafael J. Wysocki wrote:
> On Monday, February 07, 2011, Dmitry Torokhov wrote:
> > More of an observation for your (b) justification. I'd probably force
> > CONFIG_PM to always 'y'w while we weeding references to it from
> > drivers...
> 
> We simply can't force CONFIG_PM to 'y', because some platforms want it to be 'n'.
> 
> OTOH, if CONFIG_PM = CONFIG_PM_SLEEP||CONFIG_PM_RUNTIME, we can just leave the
> #ifdefs as they are and simply avoid adding new ones, or use CONFIG_PM for all
> PM callbacks.
> 
For sh at least turning on CONFIG_PM without PM_SLEEP or PM_RUNTIME is
largely pointless, so the bulk of the defconfigs have it turned off. The
few platforms that do use CONFIG_PM for something also have more
comprehensive support implemented. The few times we do have it enabled
without one of the others supported is simply for build coverage, mostly
due to sharing drivers (whatever isn't already triggered through
rand/allyes/modconfigs).

I would expect that this is a common scenario for the bulk of the
defconfigs that reflect PM being a platform-specific vs architecture-wide
property regardless of architecture, however.
