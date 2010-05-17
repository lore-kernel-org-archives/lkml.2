Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0EQS71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:59:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0EQS70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:59:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: cpumask: fix compat getaffinity
Date: Mon, 17 May 2010 20:58:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Milton Miller <miltonm@bga.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org, anton@samba.org
References: <1273653045_3386@mail4.comsite.net> <201005142209.14473.rusty@rustcorp.com.au> <20100517134320.A190.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100517134320.A190.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005172058.50642.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/K4rgNSHPkEGNdMqi7csOLsXHVrGHISoIg43k
 KAGVH3Oz1EMrhVl0GXrrpWW5aWJz01vshaINugfto0vIWjaGQW
 G5eiuW2fKqx0vGmo6mrNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, KOSAKI Motohiro wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Subject: [PATCH] cpumask: fix compat getaffinity
> 
> Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> libnuma, which abuses sched_getaffinity to find out NR_CPUS
> in order to parse /sys/devices/system/node/node*/cpumap.
> 
> On NUMA systems with less than 32 possibly CPUs, the
> current compat_sys_sched_getaffinity now returns '4'
> instead of the actual NR_CPUS/8, which makes libnuma
> bail out when parsing the cpumap.
> 
> The libnuma call sched_getaffinity(0, bitmap, 4096)
> at first. It mean the libnuma expect the return value of
> sched_getaffinity() is either len argument or NR_CPUS.
> But it doesn't expect to return nr_cpu_ids.
> 
> Strictly speaking, userland requirement are
> 
> 1) Glibc assume the return value mean the lengh of initialized
>    of mask argument. E.g. if sched_getaffinity(1024) return 128,
>    glibc make zero fill rest 896 byte.
> 2) Libnuma assume the return value can be used to guess NR_CPUS
>    in kernel. It assume len-arg<NR_CPUS makes -EINVAL. But
>    it try len=4096 at first and 4096 is always bigger than
>    NR_CPUS. Then, if we remove strange min_length normalization,
>    we never hit -EINVAL case.
> 
> sched_getaffinity() already solved this issue. This patch
> adapt compat_sys_sched_getaffinity() as it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>

You should also add a Cc:stable@vger.kernel.org line to the
description so Greg's scripts catch it when it gets merged
upstream.

	Arnd
