Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2LQIqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:46:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3197 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2LQIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:46:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 17 Dec 2012 00:46:11 -0800
Date: Mon, 17 Dec 2012 10:46:07 +0200
From: Sivaram Nair <sivaramn@nvidia.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "shuox.liu@intel.com" <shuox.liu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yanmin_zhang@intel.com" <yanmin_zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuidle: fix sysfs output for power_usage
Message-ID: <20121217084607.GN10090@sivaramn-lnx>
References: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
 <39891276.jhMMUpZpil@vostro.rjw.lan>
 <20121217073815.GM10090@sivaramn-lnx>
 <4160971.sv9ruOS3QC@vostro.rjw.lan>
MIME-Version: 1.0
In-Reply-To: <4160971.sv9ruOS3QC@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 08:56:45AM +0100, Rafael J. Wysocki wrote:
> On Monday, December 17, 2012 09:38:15 AM Sivaram Nair wrote:
> > On Sat, Dec 15, 2012 at 01:03:02AM +0100, Rafael J. Wysocki wrote:
> > > On Friday, December 14, 2012 03:17:37 PM Sivaram Nair wrote:
> > > > cpuidle_state->power_usage is signed; so change the corresponding sysfs
> > > > ops to output signed value instead of unsigned.
> > > 
> > > What's actually wrong with printing it as an unsigned int?
> > 
> > power_usage could have negative values (for example cpuidle/driver.c
> > inits this value to -1, -2 etc. when drv->power_specified is not set) and
> > these shows up badly in the sysfs output.
> 
> Does "badly" mean "as big positive numbers"?

Yes (sorry for not being clearer).

> 
> Should we actually print them at all in those case?  Perhaps it'll be better to
> make the file appear empty then?

May be, but why is power_usage signed in the first place? I also noticed
Daniel Lezcano's patches that reduces the scope of this variable. So,
perhaps we can just ignore this change.

-Sivaram
