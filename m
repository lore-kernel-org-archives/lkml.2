Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab0J1Hyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:54:40 -0400
Received: from mail.perches.com ([173.55.12.10]:3643 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab0J1Hyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:54:38 -0400
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for  
 pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
In-Reply-To: <20101028093529.503c3a28@endymion.delvare>
References: <1287713982.16920.39.camel@Joe-Laptop>
	 <20101026110335.3a4c7679@endymion.delvare>
	 <1288201301.4145.122.camel@Joe-Laptop>
	 <20101028093529.503c3a28@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 00:54:36 -0700
Message-ID: <1288252476.1836.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 09:35 +0200, Jean Delvare wrote:
> On Wed, 27 Oct 2010 10:41:41 -0700, Joe Perches wrote:
> > On Tue, 2010-10-26 at 11:03 +0200, Jean Delvare wrote:
> > > On Thu, 21 Oct 2010 19:19:42 -0700, Joe Perches wrote:
> > > > Change the default #define pr_fmt(fmt) from:
> > > > 	- #define pr_fmt(fmt) fmt
> > > > to:
> > > > 	- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > > This will standard use of prefixes and prevent the
> > > > addition of new #defines when using pr_<level>.
> > > I'm all for it!
> > > > Adds a config option to use the old style if desired.
> > > Not sure what the idea is. Once  pr_fmt() includes the module name, we
> > > will drop hard-coded prefixes in all log messages throughout the kernel
> > > tree. Once this is done, a kernel built with PR_FMT_IS_KBUILD_MODNAME=n
> > > would become horribly confusing.
> > 
> > True.  The idea is to allow a transition period and remove
> > this PR_FMT_IS_KBUILD_MODNAME config option later.
> 
> I don't buy this, sorry. During the "transition period", neither value
> of this option will produce good results. One will lead to duplicate
> prefixes and the other will lead to missing prefixes.

So why don't you change it in your kernel.h and include that
in linux-next and see how many complaints you get.


