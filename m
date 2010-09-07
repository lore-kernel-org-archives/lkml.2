Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab0IGW2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:28:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521Ab0IGW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:28:00 -0400
Date: Tue, 7 Sep 2010 15:27:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hunter Adrian <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv6 3/3] mmc_test: collect data and show it via sysfs by
 demand
Message-Id: <20100907152753.4726c076.akpm@linux-foundation.org>
In-Reply-To: <d7cf4d98c6e0396da903c2e49b028f240853bfc2.1283862780.git.ext-andriy.shevchenko@nokia.com>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<ba5173c9b420d9554c83965f47d0b5cba642743a.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<d7cf4d98c6e0396da903c2e49b028f240853bfc2.1283862780.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Sep 2010 15:35:26 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> TODO:
>  - implement show() method based on seq_file API
> 
> Changes since v5:
>  - we can't use BUG_ON at exit() method because it quite normal case when the
>    module is going to be removed with card plugged in, that's why we just free
>    memory there
>  - rebase against recent linux-next tree
> 
> Changes since v4:
>  - BUG_ON at exit if the list of the results isn't empty
> 
> Changes since v3:
>  - fix multi-line commentary style
>  - protect mmc_test_free_result() by mutex
>  - apply known values to newly created mmc_test_general_result structure before
>    attaching it to the list
>  - call list_del() before free mmc_test_transfer_result structure
>  - check truncated output in show() method, return -ENOBUFS if so
>  - avoid deadlock in show() method if snprintf() fails
> 
> Changes since v2:
>  - move card memeber to mmc_test_general_result structrure and thus throw away
>    mmc_test_overall_result which was overkill
>  - check result of kmalloc and kzalloc
>  - keep pointer to the actual mmc_test_general_result structure in the
>    mmc_test_card
> 
> Changes since v1:
>  - structrure members are described
>  - save transfer results code is split to separate function
>  - in mmc_test_print_rate() use count = 1 instead of 0
>  - mmc_test_result keeps overall results (across all tested cards), however
>    it's still global variable
>  - list_head variables inside structures have a suffix _lst now

While useful and important, none of the above is relevant for a
mainline commit (IMP) so I always remove it.

> Here is a patch which brings possibility to get test results via sysfs. It
> helps to do tests non-interactively.
>
> We have the file created under sysfs already and we could use it to out test
> results.

That's the patch changelog.

> This patch applied on top of patches published here [1]
> 
> [1] http://lkml.org/lkml/2010/8/18/164

And that's irrelevant for a mainline commit.


So what we end up with is extremely thin.  Something about adding
something to sysfs.

This is not enough!  You're proposing an addition to the kernel->user
ABI.  Please fully describe this interface so that we can understand
and review it.  What are the names of these sysfs files?  What do they
do?  Provide us with example output in the changelog so we can see for
ourselves.

Please consider documenting the thing in a permanent documentation
file.  (I don't believe that Documentation/ABI/ is appropriate, given
mmc_test's scope).


afacit the only useful info we have about mmc_test is

        help
          Development driver that performs a series of reads and writes
          to a memory card in order to expose certain well known bugs
          in host controllers. The tests are executed by writing to the
          "test" file in sysfs under each card. Note that whatever is
          on your card will be overwritten by these tests.

          This driver is only of interest to those developing or
          testing a host driver. Most people should say N here.

which I guess is good enough, given the smallness and sophistication of
its users.  It could be improved on though!
