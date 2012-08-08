Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470Ab2HHRxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:53:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54562 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab2HHRxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:53:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6797"; a="222652008"
Message-ID: <5022A79E.6050504@codeaurora.org>
Date: Wed, 08 Aug 2012 10:53:34 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 01/11] ARM: topology: mark init_cpu_topology as __init
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1344437248-20560-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/12 07:47, Arnd Bergmann wrote:
> The init_cpu_topology function can be put into the __init section
> and discarded after boot, because it is only called from
> smp_prepare_cpus, which is also marked __init. This was reported
> by gcc after Vincent Guittot added the parse_dt_topology function
> in 339ca09d7ada "ARM: 7463/1: topology: Update cpu_power according to DT
> information".
>
> Without this patch, building kzm9g_defconfig results in:
>
> WARNING: vmlinux.o(.text+0xb5a0): Section mismatch in reference from the function init_cpu_topology() to the function .init.text:parse_dt_topology()
> The function init_cpu_topology() references
> the function __init parse_dt_topology().
> This is often because init_cpu_topology lacks a __init
> annotation or the annotation of parse_dt_topology is wrong.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---

This is already in the patch tracker

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7482/1

I also notice that store_cpu_topology() should be marked __cpuinit and
update_siblings_mask, middle_capacity, cpu_capacity, and
update_cpu_power should be static. We should probably also rename
update_cpu_power() so as to not conflict with the one in kernel/sched/fair.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

