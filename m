Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1GZRBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:01:54 -0400
Received: from mail.perches.com ([173.55.12.10]:4310 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1GZRBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:01:47 -0400
Subject: Re: [PATCH] printk: add Kconfig for default console loglevel
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dave Reisner <d@falconindy.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Reisner <dreisner@archlinux.org>
In-Reply-To: <20110726093730.aa164c70.rdunlap@xenotime.net>
References: <1311694431-17037-1-git-send-email-dreisner@archlinux.org>
	 <20110726093730.aa164c70.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 10:01:45 -0700
Message-ID: <1311699705.15386.20.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 09:37 -0700, Randy Dunlap wrote:
> On Tue, 26 Jul 2011 11:33:51 -0400 Dave Reisner wrote:
> > Keep the historical default of 7, but allow distributions and users to
> > tune this value instead of requiring a kernel cmdline parameter.
> Please explain how this is different from what is already in lib/Kconfig.debug:
> config DEFAULT_MESSAGE_LOGLEVEL
> 	int "Default message log level (1-7)"
> 	range 1 7
> 	default "4"
> 	help
> 	  Default log level for printk statements with no specified priority.

DEFAULT_MESSAGE_LOGLEVEL sets a KERN_<level> for
printks without a KERN_<level>.

> > +config DEFAULT_CONSOLE_LOGLEVEL
> > +	int "Default console log level (1-7)"
> > +	range 1 7
> > +	default "7"
> > +	help
> > +	  Default console log level setting for printk statements.
> > +
> > +	  This was hard-coded to KERN_INFO (7) since at least 2.6.12. You may
> > +	  wish to turn this down to 4 for a quieter console.
> > +

This allows 'unimportant' messages to not be shown by default.

I think there are lots of KERN_INFO messages that are
miscategorized.  This change might cause some shifting
of KERN_<level>s in the future, so it's OK by me. 

