Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab1G2M7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:59:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64480 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab1G2M7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:59:12 -0400
Date: Fri, 29 Jul 2011 08:58:24 -0400
From: Dave Reisner <d@falconindy.com>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Reisner <dreisner@archlinux.org>
Subject: Re: [PATCH] printk: add Kconfig for default console loglevel
Message-ID: <20110729125824.GF997@rampage>
References: <1311694431-17037-1-git-send-email-dreisner@archlinux.org>
 <20110726093730.aa164c70.rdunlap@xenotime.net>
 <1311699705.15386.20.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311699705.15386.20.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 10:01:45AM -0700, Joe Perches wrote:
> On Tue, 2011-07-26 at 09:37 -0700, Randy Dunlap wrote:
> > On Tue, 26 Jul 2011 11:33:51 -0400 Dave Reisner wrote:
> > > Keep the historical default of 7, but allow distributions and users to
> > > tune this value instead of requiring a kernel cmdline parameter.
> > Please explain how this is different from what is already in lib/Kconfig.debug:
> > config DEFAULT_MESSAGE_LOGLEVEL
> > 	int "Default message log level (1-7)"
> > 	range 1 7
> > 	default "4"
> > 	help
> > 	  Default log level for printk statements with no specified priority.
> 
> DEFAULT_MESSAGE_LOGLEVEL sets a KERN_<level> for
> printks without a KERN_<level>.
> 
> > > +config DEFAULT_CONSOLE_LOGLEVEL
> > > +	int "Default console log level (1-7)"
> > > +	range 1 7
> > > +	default "7"
> > > +	help
> > > +	  Default console log level setting for printk statements.
> > > +
> > > +	  This was hard-coded to KERN_INFO (7) since at least 2.6.12. You may
> > > +	  wish to turn this down to 4 for a quieter console.
> > > +
> 
> This allows 'unimportant' messages to not be shown by default.
> 
> I think there are lots of KERN_INFO messages that are
> miscategorized.  This change might cause some shifting
> of KERN_<level>s in the future, so it's OK by me. 
> 

Joe,

Did you want me to resubmit with your addition? Do I need to cc anyone
else to move this along to Linus's integration branch? Apologies, my
familiarity with the merge process for the kernel stops at the
documentation in the git repo.

dave
