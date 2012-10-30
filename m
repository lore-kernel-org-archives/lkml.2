Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2J3Xko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:40:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2J3Xkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:40:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: maciej.rutecki@gmail.com
Cc: wujianguo@huawei.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jiang.liu@huawei.com, akpm@linux-foundation.org,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [REGRESSION] 3.7-rc2 kernel BUG at kernel/power/snapshot.c:517!
Date: Wed, 31 Oct 2012 00:44:47 +0100
Message-ID: <2355953.ClcD7YxnmU@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201210302135.48585.maciej.rutecki@gmail.com>
References: <201210211712.28571.maciej.rutecki@gmail.com> <1552872.pfLgNj3qcY@vostro.rjw.lan> <201210302135.48585.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2012 09:35:48 PM Maciej Rutecki wrote:
> On niedziela, 28 października 2012 o 22:45:26 Rafael J. Wysocki wrote:
> > On Sunday, October 28, 2012 10:12:49 PM Maciej Rutecki wrote:
> > > On niedziela, 21 października 2012 o 17:12:28 Maciej Rutecki wrote:
> > > > Error: kernel BUG at kernel/power/snapshot.c:517!
> > > > 
> > > > Last known good: 3.6.1
> > > > Bad: 3.7-rc2
> > > > 
> > > > Steps to reproduce:
> > > > 1. Boot system with 3.7-rc2 kernel
> > > > 2. Try suspend to disk (s2ram works OK)
> > > > 
> > > > System dies on message:
> > > > http://mrutecki.pl/download/kernel/3.7-rc2/swinka/DSCN0280.jpg
> > > > 
> > > > lspci:
> > > > http://mrutecki.pl/download/kernel/3.7-rc2/swinka/lspci.txt
> > > > 
> > > > dmesg:
> > > > http://mrutecki.pl/download/kernel/3.7-rc2/swinka/dmesg-3.7-rc2.txt
> > > 
> > > Still present in -rc3
> > 
> > This appears to be a memory allocation error and I have no idea what
> > the reason of it is.
> > 
> > Any chance to bisect?
> 
> 7f1290f2f2a4d2c3f1b7ce8e87256e052ca23125 is the first bad commit
> commit 7f1290f2f2a4d2c3f1b7ce8e87256e052ca23125
> Author: Jianguo Wu <wujianguo@huawei.com>
> Date:   Mon Oct 8 16:33:06 2012 -0700
> 
>     mm: fix-up zone present pages
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
>     Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>     Reported-by: Petr Tesarik <ptesarik@suse.cz>
>     Tested-by: Petr Tesarik <ptesarik@suse.cz>
>     Cc: "Luck, Tony" <tony.luck@intel.com>
>     Cc: Mel Gorman <mel@csn.ul.ie>
>     Cc: Yinghai Lu <yinghai@kernel.org>
>     Cc: Minchan Kim <minchan.kim@gmail.com>
>     Cc: Johannes Weiner <hannes@cmpxchg.org>
>     Cc: David Rientjes <rientjes@google.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> 
> Description says:
> "This patch intends to fix-up zone->present_pages when memory are freed to
>     buddy system on x86_64 and IA64 platforms."
> 
> but I use 32 bit kernel
> 
> Revert this commit solves problem.

This is good to know, thanks for bisecting it!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
