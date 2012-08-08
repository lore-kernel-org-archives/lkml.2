Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab2HHTOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:14:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab2HHTOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:14:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 01/11] ARM: topology: mark init_cpu_topology as __init
Date: Wed, 8 Aug 2012 19:14:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Namhyung Kim <namhyung@kernel.org>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-2-git-send-email-arnd@arndb.de> <5022A79E.6050504@codeaurora.org>
In-Reply-To: <5022A79E.6050504@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081914.17651.arnd@arndb.de>
X-Provags-ID: V02:K0:lAFPJmiWsp13ssJtXKWZyv6uD/XUPADDyWKM66XFpQC
 XTNLVZBfMb8StSs2L6YeMQy2Qy5zmwjtzoXjXpm25ExHEF5BsF
 yJrkVkETZub8YAwys4lYZ0RNFuYsuJ33Vi7CxIz3FgDrh9Eqd8
 64cIN2I/OMeYuFDvaNZM+HxcOtz4+6DXBPB8fO7rH/JSpSEuvm
 pOZiAatAKZvETRQ6ECRSZBYL/rn2Z19jb4eHzZYNnXE5TBXPXw
 4PidrNHN9/JhJVfv0IQLgWZbx+8q71xqObLDbHgff+JUEEMgOb
 mA2aniepsOAOlPRLYkcrRt2pUGTcglzV5tO15PmMebVmroc7px
 Wzwy54IxLDY6w8gMKrXw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Stephen Boyd wrote:
> 
> On 08/08/12 07:47, Arnd Bergmann wrote:
> > The init_cpu_topology function can be put into the __init section
> > and discarded after boot, because it is only called from
> > smp_prepare_cpus, which is also marked __init. This was reported
> > by gcc after Vincent Guittot added the parse_dt_topology function
> > in 339ca09d7ada "ARM: 7463/1: topology: Update cpu_power according to DT
> > information".
> >
> > Without this patch, building kzm9g_defconfig results in:
> >
> > WARNING: vmlinux.o(.text+0xb5a0): Section mismatch in reference from the function init_cpu_topology() to the function .init.text:parse_dt_topology()
> > The function init_cpu_topology() references
> > the function __init parse_dt_topology().
> > This is often because init_cpu_topology lacks a __init
> > annotation or the annotation of parse_dt_topology is wrong.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > ---
> 
> This is already in the patch tracker
> 
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7482/1

Ok, dropped here.

> I also notice that store_cpu_topology() should be marked __cpuinit and
> update_siblings_mask, middle_capacity, cpu_capacity, and
> update_cpu_power should be static. We should probably also rename
> update_cpu_power() so as to not conflict with the one in kernel/sched/fair.c

Yes, all good points. 

	Arnd
