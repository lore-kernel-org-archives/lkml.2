Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541Ab2J3Uf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:35:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50076 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528Ab2J3Ufx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:35:53 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, wujianguo@huawei.com
Subject: Re: [REGRESSION] 3.7-rc2 kernel BUG at kernel/power/snapshot.c:517!
Date: Tue, 30 Oct 2012 21:35:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.1; KDE/4.8.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jiang.liu@huawei.com, akpm@linux-foundation.org
References: <201210211712.28571.maciej.rutecki@gmail.com> <201210282212.50282.maciej.rutecki@gmail.com> <1552872.pfLgNj3qcY@vostro.rjw.lan>
In-Reply-To: <1552872.pfLgNj3qcY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210302135.48585.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 28 października 2012 o 22:45:26 Rafael J. Wysocki wrote:
> On Sunday, October 28, 2012 10:12:49 PM Maciej Rutecki wrote:
> > On niedziela, 21 października 2012 o 17:12:28 Maciej Rutecki wrote:
> > > Error: kernel BUG at kernel/power/snapshot.c:517!
> > > 
> > > Last known good: 3.6.1
> > > Bad: 3.7-rc2
> > > 
> > > Steps to reproduce:
> > > 1. Boot system with 3.7-rc2 kernel
> > > 2. Try suspend to disk (s2ram works OK)
> > > 
> > > System dies on message:
> > > http://mrutecki.pl/download/kernel/3.7-rc2/swinka/DSCN0280.jpg
> > > 
> > > lspci:
> > > http://mrutecki.pl/download/kernel/3.7-rc2/swinka/lspci.txt
> > > 
> > > dmesg:
> > > http://mrutecki.pl/download/kernel/3.7-rc2/swinka/dmesg-3.7-rc2.txt
> > 
> > Still present in -rc3
> 
> This appears to be a memory allocation error and I have no idea what
> the reason of it is.
> 
> Any chance to bisect?

7f1290f2f2a4d2c3f1b7ce8e87256e052ca23125 is the first bad commit
commit 7f1290f2f2a4d2c3f1b7ce8e87256e052ca23125
Author: Jianguo Wu <wujianguo@huawei.com>
Date:   Mon Oct 8 16:33:06 2012 -0700

    mm: fix-up zone present pages
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
    Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
    Reported-by: Petr Tesarik <ptesarik@suse.cz>
    Tested-by: Petr Tesarik <ptesarik@suse.cz>
    Cc: "Luck, Tony" <tony.luck@intel.com>
    Cc: Mel Gorman <mel@csn.ul.ie>
    Cc: Yinghai Lu <yinghai@kernel.org>
    Cc: Minchan Kim <minchan.kim@gmail.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: David Rientjes <rientjes@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Description says:
"This patch intends to fix-up zone->present_pages when memory are freed to
    buddy system on x86_64 and IA64 platforms."

but I use 32 bit kernel

Revert this commit solves problem.


Regards

PS. Between Oct. 31-Nov. 4 I'm offline. 
-- 
Maciej Rutecki
http://www.mrutecki.pl
