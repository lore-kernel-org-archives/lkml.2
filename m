Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1HKB43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 21:56:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:57730 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1HKB41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 21:56:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="37343621"
Subject: Re: [PATCH v4] PM: add statistics debugfs file for suspend to ram
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Pavel Machek <pavel@ucw.cz>
Cc: "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
        "Brown, Len" <len.brown@intel.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
In-Reply-To: <20110810214418.GC9320@atrey.karlin.mff.cuni.cz>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
	 <20110810214418.GC9320@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Thu, 11 Aug 2011 09:55:33 +0800
Message-ID: <1313027733.1743.110.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 23:44 +0200, Pavel Machek wrote:
> Hi!
> 
> > If not using this patch, we have other methods to get info about
> > what device fails. One is to turn on  CONFIG_PM_DEBUG, but users
> > would get too much info and testers need recompile the system.
> > 
> > In addition, dynamic debug is another good tool to dump debug info.
> > But it still doesn't match our utilization scenario closely.
> > 1) user need write a user space parser to process the syslog output;
> > 2) Our testing scenario is we leave the mobile for at least hours.
> >    Then, check its status. No serial console available during the
> >    testing. One is because console would be suspended, and the other
> >    is serial console connecting with spi or HSU devices would consume
> >    power. These devices are powered off at suspend-2-ram.
> 
Pavel,

Thanks for your good comments. To be honest, we did consider the weakness of
the patch before sending out. There is a tradeoff we need balance.

> 1) yes you need parser
> 
> 1a) Yes, you need CONFIG_PM_DEBUG; but that's better than forcing 200
> lines of pure debugging code onto everyone
The new code lines are pretty simple and direct. We don't change any logic of PM.
CONFIG_PM_DEBUG is used mostly to print out debug info timely, not for statistics.

> 2)  You can do that. Just check and parse dmesg from userland after
> each resume.
Indeed, there are many methods to do so. But if we implement it in kernel directly,
more developers could benefit from it. And any new kernel patch which touches the logic
would also maintain the consistency between main PM logic and the statistics.

> 
> If dmesg provides too little/too much information, improve loglevels
> so that it is not spammed.
We got very good feedback from internal 1st-line developers and testers. They raised
the requirement and we implement it. 

Thanks,
Yanmin


