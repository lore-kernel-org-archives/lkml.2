Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0J0Rlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:41:45 -0400
Received: from mail.perches.com ([173.55.12.10]:3636 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0J0Rln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:41:43 -0400
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for 
 pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
In-Reply-To: <20101026110335.3a4c7679@endymion.delvare>
References: <1287713982.16920.39.camel@Joe-Laptop>
	 <20101026110335.3a4c7679@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 10:41:41 -0700
Message-ID: <1288201301.4145.122.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 11:03 +0200, Jean Delvare wrote:
> On Thu, 21 Oct 2010 19:19:42 -0700, Joe Perches wrote:
> > Change the default #define pr_fmt(fmt) from:
> > 	- #define pr_fmt(fmt) fmt
> > to:
> > 	- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > This will standard use of prefixes and prevent the
> > addition of new #defines when using pr_<level>.
> I'm all for it!
> > Adds a config option to use the old style if desired.
> Not sure what the idea is. Once  pr_fmt() includes the module name, we
> will drop hard-coded prefixes in all log messages throughout the kernel
> tree. Once this is done, a kernel built with PR_FMT_IS_KBUILD_MODNAME=n
> would become horribly confusing.

True.  The idea is to allow a transition period and remove
this PR_FMT_IS_KBUILD_MODNAME config option later.

> How relevant is the x86 defconfig?
> It doesn't include any hardware-specific driver, does it?

It adds lots of x86 specific drivers...

> I've used the following grep to find them: grep -I 'pr_[a-z]*([^"]'
> Let me know if you have anything better.

Perhaps use -P
"\bpr_(emerg|alert|crit|err|warning|warn|notice|info|cont|debug)\s*\(\s*\"\w+:"

Another way is to use:
strings <vmlinux|other> | grep -P "^<.>\w+:"


