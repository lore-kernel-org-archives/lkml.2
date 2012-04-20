Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2DTD4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:56:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab2DTD4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:56:20 -0400
Date: Thu, 19 Apr 2012 23:56:02 -0400 (EDT)
Message-Id: <20120419.235602.266003767868541080.davem@davemloft.net>
To: yong.zhang0@gmail.com
Cc: sam@ravnborg.org, konrad@gaisler.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, daniel@gaisler.com
Subject: Re: [PATCH 1/1] sparc: task_cpu() for stopper thread on sparc32
 returns 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120420033634.GA13068@zhy>
References: <1334827362-3434-1-git-send-email-konrad@gaisler.com>
	<20120419153428.GB1120@merkur.ravnborg.org>
	<20120420033634.GA13068@zhy>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 19 Apr 2012 20:56:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Date: Fri, 20 Apr 2012 11:36:34 +0800

> diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
> index 1210fde..bb017e7 100644
> --- a/arch/sparc/kernel/leon_smp.c
> +++ b/arch/sparc/kernel/leon_smp.c
> @@ -78,6 +78,8 @@ void __cpuinit leon_callin(void)
>  	local_flush_tlb_all();
>  	leon_configure_cache_smp();
>  
> +	notify_cpu_starting(cpuid);
> +

This is the most reasonable theory I've seen for this
problem :-)

