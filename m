Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0EHJLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 05:11:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61191 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab0EHJLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 05:11:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: cpumask: fix compat getaffinity
Date: Sat, 8 May 2010 11:11:08 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ken Werner <ken.werner@web.de>
References: <201005071445.50147.arnd@arndb.de> <201005081800.48240.rusty@rustcorp.com.au>
In-Reply-To: <201005081800.48240.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005081111.08720.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Q71OcUjGMx3mDZlmY9DbfnSczlrkt3tUhi3U
 TSEpXq002TUm6yzWWPXKef+PuXexwxixdoiy69Afbqqv8OtliU
 39P+27GgSD/ubhadDuCfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 May 2010 10:30:47 Rusty Russell wrote:
> 
> On Fri, 7 May 2010 10:15:49 pm Arnd Bergmann wrote:
> > Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> > libnuma, which abuses sched_getaffinity to find out NR_CPUS
> > in order to parse /sys/devices/system/node/node*/cpumap.
> > 
> > On NUMA systems with less than 32 possibly CPUs, the
> > current compat_sys_sched_getaffinity now returns '4'
> > instead of the actual NR_CPUS/8, which makes libnuma
> > bail out when parsing the cpumap.
> 
> Really?  AFAICT the cpumap is printed using nr_cpu_ids too.  Can you
> give an example of what cpumap is on this system?

On Ken's PS3 running the Fedora 12 kernel (2.6.32-something), the output
from my memory is 00000000,00000000,00000000,00000003\n. NR_CPUs
is 128, nr_cpu_ids is most likely 2.

	Arnd
