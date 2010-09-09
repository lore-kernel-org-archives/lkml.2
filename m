Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0IIFWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:22:44 -0400
Received: from kroah.org ([198.145.64.141]:35804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0IIFWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:22:25 -0400
Date: Wed, 8 Sep 2010 20:59:51 -0700
From: Greg KH <greg@kroah.com>
To: Chris Ball <cjb@laptop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hunter Adrian <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv6 3/3] mmc_test: collect data and show it via sysfs by
	demand
Message-ID: <20100909035951.GA3945@kroah.com>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com> <ba5173c9b420d9554c83965f47d0b5cba642743a.1283862780.git.ext-andriy.shevchenko@nokia.com> <d7cf4d98c6e0396da903c2e49b028f240853bfc2.1283862780.git.ext-andriy.shevchenko@nokia.com> <20100907152753.4726c076.akpm@linux-foundation.org> <20100907225843.GA26240@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907225843.GA26240@void.printf.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 11:58:43PM +0100, Chris Ball wrote:
> On Tue, Sep 07, 2010 at 03:27:53PM -0700, Andrew Morton wrote:
> > So what we end up with is extremely thin.  Something about adding
> > something to sysfs.
> > 
> > This is not enough!  You're proposing an addition to the kernel->user
> > ABI.  Please fully describe this interface so that we can understand
> > and review it.  What are the names of these sysfs files?  What do they
> > do?  Provide us with example output in the changelog so we can see for
> > ourselves.
> 
> Hoping Andy doesn't mind me jumping in, here's an attempt at a better
> changelog:
> 
> ---
> 
> Prior to this patch, the "test" file under each card's sysfs node was
> write-only, and results were obtained by looking at dmesg.  This patch
> improves programmatic access to the test results, making them available
> by reading back from the same "test" file:
> 
> [root@host mmc0:e624]# echo 6 > test
> [root@host mmc0:e624]# cat test
> Test 6: 2

Ick, no.

Why is this in sysfs at all anyway?

Why not put it in debugfs?

And for every sysfs file, you need to have a Documenation/ABI/ entry.

Remember, sysfs is "one value per file".  Does that work with this file?
At first glance, it doesn't look like it.

Please use debugfs instead.

thanks,

greg k-h
