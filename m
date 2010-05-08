Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0EHIa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:30:57 -0400
Received: from ozlabs.org ([203.10.76.45]:60027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0EHIaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:30:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: cpumask: fix compat getaffinity
Date: Sat, 8 May 2010 18:00:47 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ken Werner <ken.werner@web.de>
References: <201005071445.50147.arnd@arndb.de>
In-Reply-To: <201005071445.50147.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005081800.48240.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 10:15:49 pm Arnd Bergmann wrote:
> Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> libnuma, which abuses sched_getaffinity to find out NR_CPUS
> in order to parse /sys/devices/system/node/node*/cpumap.
> 
> On NUMA systems with less than 32 possibly CPUs, the
> current compat_sys_sched_getaffinity now returns '4'
> instead of the actual NR_CPUS/8, which makes libnuma
> bail out when parsing the cpumap.

Really?  AFAICT the cpumap is printed using nr_cpu_ids too.  Can you
give an example of what cpumap is on this system?

Confused,
Rusty.
