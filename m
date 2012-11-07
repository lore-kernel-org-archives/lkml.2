Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2KGAD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 19:03:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KGAD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 19:03:28 -0500
MIME-Version: 1.0
Message-ID: <0e2b1932-628b-4110-8c80-7cfbe3323452@default>
Date: Tue, 6 Nov 2012 16:02:51 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, sjenning@linux.vnet.ibm.com,
        dan.magenheimer@oracle.com, ngupta@vflare.org, minchan@kernel.org,
        rcj@linux.vnet.ibm.com, linux-mm@kvack.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Cc: akpm@linux-foundation.org
Subject: RE: [RFC PATCH] zcache2 cleanups (s/int/bool + debugfs movement).
References: <<1352126254-28933-1-git-send-email-konrad.wilk@oracle.com>>
In-Reply-To: <<1352126254-28933-1-git-send-email-konrad.wilk@oracle.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Monday, November 05, 2012 7:37 AM
> To: linux-kernel@vger.kernel.org; sjenning@linux.vnet.ibm.com; dan.magenheimer@oracle.com;
> ngupta@vflare.org; minchan@kernel.org; rcj@linux.vnet.ibm.com; linux-mm@kvack.org;
> gregkh@linuxfoundation.org; devel@driverdev.osuosl.org
> Cc: akpm@linux-foundation.org
> Subject: [RFC PATCH] zcache2 cleanups (s/int/bool + debugfs movement).
> 
> Looking at the zcache2 code there were a couple of things that I thought
> would make sense to move out of the code. For one thing it makes it easier
> to read, and for anoter - it can be cleanly compiled out. It also allows
> to have a clean seperation of counters that we _need_ vs the optional ones.
> Which means that in the future we could get rid of the optional ones.
> 
> This patchset is based on the patchset that Dan sent out
> (https://lkml.org/lkml/2012/10/31/790). I've stuck
> them (and addressed some review comments) and put them in my branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git devel/zcache.v3
> 
> I am going to repost the module loading some time later this week - Bob Liu had
> some comments that I want to address.
> 
> So back to this patchset - it fixes some outstanding compile warnings, cleans
> up some of the code, and rips out the debug counters out of zcache-main.c
> and sticks them in a debug.c file.
> 
> I was hoping it would end up with less code, but sadly it ended up with
> a bit more due to the empty non-debug functions.
> 
>  drivers/staging/ramster/Kconfig       |    8 +
>  drivers/staging/ramster/Makefile      |    1 +
>  drivers/staging/ramster/debug.c       |   66 ++++++
>  drivers/staging/ramster/debug.h       |  225 +++++++++++++++++++
>  drivers/staging/ramster/zcache-main.c |  384 ++++++++-------------------------
>  5 files changed, 389 insertions(+), 295 deletions(-)
> 
> Konrad Rzeszutek Wilk (11):
>       zcache2: s/int/bool/ on the various options.
>       zcache: Module license is defined twice.
>       zcache: Provide accessory functions for counter increase
>       zcache: Provide accessory functions for counter decrease.
>       zcache: The last of the atomic reads has now an accessory function.
>       zcache: Fix compile warnings due to usage of debugfs_create_size_t
>       zcache: Make the debug code use pr_debug
>       zcache: Move debugfs code out of zcache-main.c file.
>       zcache: Use an array to initialize/use debugfs attributes.
>       zcache: Move the last of the debugfs counters out
>       zcache: Coalesce all debug under CONFIG_ZCACHE2_DEBUG

FWIW, for all these patches, please add my:

Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>
