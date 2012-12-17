Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab2LQHi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:38:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6918 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2LQHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:38:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 16 Dec 2012 23:36:11 -0800
Date: Mon, 17 Dec 2012 09:38:15 +0200
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
Message-ID: <20121217073815.GM10090@sivaramn-lnx>
References: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
 <1355491060-970-2-git-send-email-sivaramn@nvidia.com>
 <39891276.jhMMUpZpil@vostro.rjw.lan>
MIME-Version: 1.0
In-Reply-To: <39891276.jhMMUpZpil@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 01:03:02AM +0100, Rafael J. Wysocki wrote:
> On Friday, December 14, 2012 03:17:37 PM Sivaram Nair wrote:
> > cpuidle_state->power_usage is signed; so change the corresponding sysfs
> > ops to output signed value instead of unsigned.
> 
> What's actually wrong with printing it as an unsigned int?

power_usage could have negative values (for example cpuidle/driver.c
inits this value to -1, -2 etc. when drv->power_specified is not set) and
these shows up badly in the sysfs output.

regards,
Sivaram
