Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0LOOlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:41:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab0LOOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:41:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Hunt <joshhunt00@gmail.com>
Subject: Re: cpumask: fix compat getaffinity
Date: Wed, 15 Dec 2010 15:40:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Milton Miller <miltonm@bga.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        anton@samba.org
References: <1273653045_3386@mail4.comsite.net> <20100517134320.A190.A69D9226@jp.fujitsu.com> <AANLkTi=ghZn9o_7Dab2GQebZUZBZk+um0vYbZZLC3dMf@mail.gmail.com>
In-Reply-To: <AANLkTi=ghZn9o_7Dab2GQebZUZBZk+um0vYbZZLC3dMf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151540.51975.arnd@arndb.de>
X-Provags-ID: V02:K0:I7LFc+t5hS3mNr+Jlp4dyy2FF0awA9dFsqlxUHteQ0I
 sH3KCQnCmz+KXXTDCSYhFCZO+bbWTEoaST9G9+0K0Nq54G6nAe
 ITHIf/ZITQozGEefFt38UN4eWrQu8K86u4izK44YDCxYE2rV3L
 TWNlKJBcYM5FgFW2gUceYyGSoZYon/tlkDcttUfN+qMFTlKHHi
 K6/LpFFgobnwlQ0mkU5PQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 December 2010, Josh Hunt wrote:
> 
> I realize this thread is fairly old, but I have a question about this
> statement in the changelog:
> 
> > On NUMA systems with less than 32 possibly CPUs, the
> > current compat_sys_sched_getaffinity now returns '4'
> > instead of the actual NR_CPUS/8, which makes libnuma
> > bail out when parsing the cpumap.
> 
> This does not seem accurate, at least not on my system with NR_CPUS=32
> and nr_cpu_ids=8. The smallest value retlen will ever be set to is
> sizeof(long) which is 8 on most modern systems. This breaks the
> statement that this function will now return NR_CPUS/8.

Yes, I think the description is a bit misleading there.
The point was that it should return the number that the
sysfs files are based on, instead of the smallest multiple
of sizeof(compat_long) that can hold the installed CPUs.

	Arnd
