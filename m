Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab0J1Hfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:35:43 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29560 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab0J1Hfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:35:40 -0400
Date: Thu, 28 Oct 2010 09:35:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for  
 pr_fmt(fmt)
Message-ID: <20101028093529.503c3a28@endymion.delvare>
In-Reply-To: <1288201301.4145.122.camel@Joe-Laptop>
References: <1287713982.16920.39.camel@Joe-Laptop>
	<20101026110335.3a4c7679@endymion.delvare>
	<1288201301.4145.122.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 10:41:41 -0700, Joe Perches wrote:
> On Tue, 2010-10-26 at 11:03 +0200, Jean Delvare wrote:
> > On Thu, 21 Oct 2010 19:19:42 -0700, Joe Perches wrote:
> > > Change the default #define pr_fmt(fmt) from:
> > > 	- #define pr_fmt(fmt) fmt
> > > to:
> > > 	- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > This will standard use of prefixes and prevent the
> > > addition of new #defines when using pr_<level>.
> > I'm all for it!
> > > Adds a config option to use the old style if desired.
> > Not sure what the idea is. Once  pr_fmt() includes the module name, we
> > will drop hard-coded prefixes in all log messages throughout the kernel
> > tree. Once this is done, a kernel built with PR_FMT_IS_KBUILD_MODNAME=n
> > would become horribly confusing.
> 
> True.  The idea is to allow a transition period and remove
> this PR_FMT_IS_KBUILD_MODNAME config option later.

I don't buy this, sorry. During the "transition period", neither value
of this option will produce good results. One will lead to duplicate
prefixes and the other will lead to missing prefixes.

I think it's preferable to drop this option, and prepare patches for
all drivers, so that the change happens all at once and we're done with
it. You seem to have all the tools to produce such patches, right?

Of course there will be 1% of all messages which we won't get right,
and they will have t be fixed afterwards, but I don't think this is a
problem.

> > How relevant is the x86 defconfig?
> > It doesn't include any hardware-specific driver, does it?
> 
> It adds lots of x86 specific drivers...
> 
> > I've used the following grep to find them: grep -I 'pr_[a-z]*([^"]'
> > Let me know if you have anything better.
> 
> Perhaps use -P
> "\bpr_(emerg|alert|crit|err|warning|warn|notice|info|cont|debug)\s*\(\s*\"\w+:"

Ah, right. This finds the hard-coded prefixes, my approach only caught
the constant prefixes. So we want to run both.

> Another way is to use:
> strings <vmlinux|other> | grep -P "^<.>\w+:"

This catches everything, but you don't always know where the string
comes from, so it isn't as convenient.

-- 
Jean Delvare
