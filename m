Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0EaEmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 00:42:08 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57704 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0EaEmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 00:42:06 -0400
Date: Mon, 31 May 2010 13:41:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MIPS: Fix deferred console messages during CPU hotplug
Message-ID: <20100531044144.GA20358@linux-sh.org>
References: <1b31306f28573a4bee56f164b1f74962fced9bc5@localhost.localdomain> <526fcbfa605500d9da9b04ac0f93ef2beddca6ed@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526fcbfa605500d9da9b04ac0f93ef2beddca6ed@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 12:35:58AM -0700, Kevin Cernekee wrote:
> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index 6cdca19..bf8923f 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -219,6 +220,10 @@ int __cpuinit __cpu_up(unsigned int cpu)
>  
>  	cpu_set(cpu, cpu_online_map);
>  
> +	/* Flush out any buffered log messages from the new CPU */
> +	if (try_acquire_console_sem() == 0)
> +		release_console_sem();
> +
>  	return 0;
>  }
>  
Since this is entirely generic why not just have kernel/printk.c register
a hotcpu notifier and handle this in the CPU_ONLINE case?
