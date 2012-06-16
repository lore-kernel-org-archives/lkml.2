Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2FPDo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:44:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53425 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2FPDoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:44:25 -0400
Date: Fri, 15 Jun 2012 20:44:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: Kay Sievers <kay@vrfy.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Reducing the noise level of build error notifications to 0
Message-ID: <20120616034420.GA3748@kroah.com>
References: <4fdbcd2f.Ta8kRp58FRzqrqaL%wfg@linux.intel.com>
 <20120616011646.GA7847@localhost>
 <20120616014732.GA2981@kroah.com>
 <20120616025031.GA8182@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616025031.GA8182@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 10:50:31AM +0800, Fengguang Wu wrote:
> [switch to LKML]
> 
> On Fri, Jun 15, 2012 at 06:47:32PM -0700, Greg Kroah-Hartman wrote:
> > On Sat, Jun 16, 2012 at 09:16:46AM +0800, Fengguang Wu wrote:
> > > Hi list,
> > > 
> > > I'm sorry if this pile of build errors disturbed you too much. If
> > > the error notification is too permissive, I can limit it in two ways:
> > > 
> > > 1) only notify build errors on the first kconfig. There may be a few
> > >    new error messages show up in the other kconfig builds, however
> > >    mostly are just irritating duplications.
> > 
> > Duplicates should be suppressed, they are just annoying.
> 
> OK!  I'll suppress noises in four ways:
> 
> rule 1: all newly shown-up error messages will be only notified for
>         the current commit and remembered to be "known bug" thereafter.
> 
> rule 2: when one bad commit triggers build errors in multiple kconfigs,
>         only one of them will be CCed. The patch author will still get
>         full information in private emails.
> 
> rule 3: when one bad commit triggers build errors in the _subsequent_
>         innocent commits of the same branch, the emails will be sent
>         to myself for manual check first. This will inevitably lead to
>         more delays (esp. when I'm sleeping), however 2+ bad commits
>         should not happen frequently.
> 
> rule 4: gcc/sparse warnings will never be CCed. Only private email
>         notifications will be sent to the author.
> 
> The above rules should be able to reduce the noise level close to 0
> for maintainers and public mailing lists.
> 
> The commit author may still see some noises, however the good thing
> is, he should be able to tell signals from noises much easier than
> the others.

How about also cc: not only the author where you mention it above, but
everyone who signed-off on the patch?  That would provide a bit of peer
pressure to ensure that the problems get fixed.

Oh, and thanks for working on this, it's much appreciated.

greg k-h
