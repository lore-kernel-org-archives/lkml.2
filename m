Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2LQMEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:04:41 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36098 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2LQMEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:04:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sivaram Nair <sivaramn@nvidia.com>
Cc: "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "shuox.liu@intel.com" <shuox.liu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yanmin_zhang@intel.com" <yanmin_zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuidle: fix sysfs output for power_usage
Date: Mon, 17 Dec 2012 13:09:48 +0100
Message-ID: <3292933.Vhp5q9ibyJ@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121217084607.GN10090@sivaramn-lnx>
References: <1355491060-970-1-git-send-email-sivaramn@nvidia.com> <4160971.sv9ruOS3QC@vostro.rjw.lan> <20121217084607.GN10090@sivaramn-lnx>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 17, 2012 10:46:07 AM Sivaram Nair wrote:
> On Mon, Dec 17, 2012 at 08:56:45AM +0100, Rafael J. Wysocki wrote:
> > On Monday, December 17, 2012 09:38:15 AM Sivaram Nair wrote:
> > > On Sat, Dec 15, 2012 at 01:03:02AM +0100, Rafael J. Wysocki wrote:
> > > > On Friday, December 14, 2012 03:17:37 PM Sivaram Nair wrote:
> > > > > cpuidle_state->power_usage is signed; so change the corresponding sysfs
> > > > > ops to output signed value instead of unsigned.
> > > > 
> > > > What's actually wrong with printing it as an unsigned int?
> > > 
> > > power_usage could have negative values (for example cpuidle/driver.c
> > > inits this value to -1, -2 etc. when drv->power_specified is not set) and
> > > these shows up badly in the sysfs output.
> > 
> > Does "badly" mean "as big positive numbers"?
> 
> Yes (sorry for not being clearer).
> 
> > 
> > Should we actually print them at all in those case?  Perhaps it'll be better to
> > make the file appear empty then?
> 
> May be, but why is power_usage signed in the first place?

Please read the comment in driver.c:set_power_states() for the answer. :-)

> I also noticed
> Daniel Lezcano's patches that reduces the scope of this variable. So,
> perhaps we can just ignore this change.

OK

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
