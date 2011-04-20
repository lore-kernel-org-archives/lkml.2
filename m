Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1DTAOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:14:37 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:40406 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753717Ab1DTAOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:14:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MmqqxCArVhbLoFJegOit/+KFi7Jg2sra1N+T6l+QqVf2hbwgNlslN5LTw5D+OyhcckLXQLx0k5ygO5SFNj12CImYhM5H0ZPVAAn/H1UQRaDxoPIubKq8C/CFxunsq+dj;
Date: Tue, 19 Apr 2011 17:14:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 4/4] n_tracerouter and n_tracesink ldisc additions.
Message-Id: <20110419171433.05752a99.rdunlap@xenotime.net>
In-Reply-To: <1303257955.13457.37.camel@localhost>
References: <james_p_freyensee@linux.intel.com>
	<1303253889-10074-5-git-send-email-james_p_freyensee@linux.intel.com>
	<20110419162015.e4446442.rdunlap@xenotime.net>
	<1303257955.13457.37.camel@localhost>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 17:05:55 -0700 J Freyensee wrote:

> On Tue, 2011-04-19 at 16:20 -0700, Randy Dunlap wrote:
> > On Tue, 19 Apr 2011 15:58:09 -0700 james_p_freyensee@linux.intel.com wrote:
> > 
> > >  drivers/tty/Kconfig         |   31 ++++++
> > >  drivers/tty/Makefile        |    2 +
> > >  drivers/tty/n_tracerouter.c |  241 ++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/tty/n_tracesink.c   |  244 +++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/tty/n_tracesink.h   |   36 +++++++
> > >  include/linux/tty.h         |    2 +
> > >  6 files changed, 556 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/tty/n_tracerouter.c
> > >  create mode 100644 drivers/tty/n_tracesink.c
> > >  create mode 100644 drivers/tty/n_tracesink.h
> > > 
> > > diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
> > > index 3fd7199..d1ab9c0 100644
> > > --- a/drivers/tty/Kconfig
> > > +++ b/drivers/tty/Kconfig
> > > @@ -319,3 +319,34 @@ config N_GSM
> > >  	  This line discipline provides support for the GSM MUX protocol and
> > >  	  presents the mux as a set of 61 individual tty devices.
> > >  
> > > +config TRACE_ROUTER
> > > +	tristate "Trace data router for MIPI P1149.7 cJTAG standard"
> > > +	depends on TRACE_SINK
> > > +	default Y
> > 
> > Don't add default Y misc drivers.
> 
> This actually isn't a misc driver.  From the help, it's "Linux tty line
> discipline"
> 
> But I can turn it off.

OK, random drivers.  Thanks.


> > > +/* Other ldisc drivers use 65536 which basically means,
> > > + * 'I can always accept 64k' and flow control is off.
> > > + * This number is deemed appropriate for this driver.
> > > + */
> > 
> > Fix multi-line comment style throughout.
> 
> Could you please show me how and what you are looking for?  You pointed
> out a similar issue using a different comment style, despite that at
> least I made it a point to maintain a consistent comment style
> throughout the code in the file.  So I'm not quite sure what is desired.
> Thanks, I appreciate this.

See Documentation/CodingStyle, section 8:

The preferred style for long (multi-line) comments is:

	/*
	 * This is the preferred style for multi-line
	 * comments in the Linux kernel source code.
	 * Please use it consistently.
	 *
	 * Description:  A column of asterisks on the left side,
	 * with beginning and ending almost-blank lines.
	 */

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
