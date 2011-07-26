Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1GZRQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:16:16 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:53778 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751064Ab1GZRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:16:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ewxedzNSLOjnyNUgYEBqdVt83pnwuuoimt2T5Hj8/dgR7HjWIvzOatZAqnI+HYt4ZFdHKNYmhDbwtJ87iAVPHoK/6sR9hVi/NmEN6r2I32a/oRaGCmahMf4KhjoPqWXV;
Date: Tue, 26 Jul 2011 10:16:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: Dave Reisner <d@falconindy.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Reisner <dreisner@archlinux.org>
Subject: Re: [PATCH] printk: add Kconfig for default console loglevel
Message-Id: <20110726101600.d6a18aa2.rdunlap@xenotime.net>
In-Reply-To: <1311699705.15386.20.camel@Joe-Laptop>
References: <1311694431-17037-1-git-send-email-dreisner@archlinux.org>
	<20110726093730.aa164c70.rdunlap@xenotime.net>
	<1311699705.15386.20.camel@Joe-Laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 10:01:45 -0700 Joe Perches wrote:

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

Thanks.  Maybe Kconfig help text could be clearer.

> I think there are lots of KERN_INFO messages that are
> miscategorized.  This change might cause some shifting
> of KERN_<level>s in the future, so it's OK by me. 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
