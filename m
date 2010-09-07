Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0IGW6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:58:49 -0400
Received: from void.printf.net ([89.145.121.20]:49184 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0IGW6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:58:47 -0400
Date: Tue, 7 Sep 2010 23:58:43 +0100
From: Chris Ball <cjb@laptop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hunter Adrian <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv6 3/3] mmc_test: collect data and show it via sysfs by
	demand
Message-ID: <20100907225843.GA26240@void.printf.net>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com> <ba5173c9b420d9554c83965f47d0b5cba642743a.1283862780.git.ext-andriy.shevchenko@nokia.com> <d7cf4d98c6e0396da903c2e49b028f240853bfc2.1283862780.git.ext-andriy.shevchenko@nokia.com> <20100907152753.4726c076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907152753.4726c076.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 03:27:53PM -0700, Andrew Morton wrote:
> So what we end up with is extremely thin.  Something about adding
> something to sysfs.
> 
> This is not enough!  You're proposing an addition to the kernel->user
> ABI.  Please fully describe this interface so that we can understand
> and review it.  What are the names of these sysfs files?  What do they
> do?  Provide us with example output in the changelog so we can see for
> ourselves.

Hoping Andy doesn't mind me jumping in, here's an attempt at a better
changelog:

---

Prior to this patch, the "test" file under each card's sysfs node was
write-only, and results were obtained by looking at dmesg.  This patch
improves programmatic access to the test results, making them available
by reading back from the same "test" file:

[root@host mmc0:e624]# echo 6 > test
[root@host mmc0:e624]# cat test
Test 6: 2


> Please consider documenting the thing in a permanent documentation
> file.  (I don't believe that Documentation/ABI/ is appropriate, given
> mmc_test's scope).

I think we should do this by modifying the Kconfig text as well:

diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index 3f2a912..ddd7e42 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
@@ -45,8 +45,9 @@ config MMC_TEST
 	  Development driver that performs a series of reads and writes
 	  to a memory card in order to expose certain well known bugs
 	  in host controllers. The tests are executed by writing to the
-	  "test" file in sysfs under each card. Note that whatever is
-	  on your card will be overwritten by these tests.
+	  "test" file in sysfs under each card, and results can be read
+	  back from the same file. Note that whatever is on your card
+	  will be overwritten by these tests.
 
 	  This driver is only of interest to those developing or
 	  testing a host driver. Most people should say N here.

Separately, Andy, I think we should translate the general result return
code for the user, i.e. print OK/FAIL/UNSUP_HOST/UNSUP_CARD for return
values 0-3.  Would you mind adding that?  (Unfortunately, it invalidates
the usage example I just gave above, so that should change too..)

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
