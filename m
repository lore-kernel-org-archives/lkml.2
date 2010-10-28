Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0J1E3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 00:29:36 -0400
Received: from imr4.ericy.com ([198.24.6.8]:52085 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0J1E3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 00:29:34 -0400
Date: Wed, 27 Oct 2010 21:28:34 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for
 pr_fmt(fmt)
Message-ID: <20101028042834.GA2219@ericsson.com>
References: <1287713982.16920.39.camel@Joe-Laptop>
 <20101026110335.3a4c7679@endymion.delvare>
 <1288201301.4145.122.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288201301.4145.122.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 01:41:41PM -0400, Joe Perches wrote:
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
> 
Personally I would prefer to just make the change without config option.

However, if that is not acceptable, a config option which is enabled by default
would still be better than nothing - and much better than hundreds of pr_fmt()
spread throughout the code. Feel free to add my Acked-by, whatever that may help.

Guenter
