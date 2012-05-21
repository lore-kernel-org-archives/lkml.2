Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2EUIa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:30:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55058 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2EUIay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:30:54 -0400
Message-ID: <4FB9FD37.4090905@linaro.org>
Date: Mon, 21 May 2012 09:30:47 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
In-Reply-To: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> In file included from drivers/mfd/ab8500-core.c:21:0:
> include/linux/mfd/dbx500-prcmu.h:614:19: error: redefinition of 'prcmu_abb_read'
> include/linux/mfd/db8500-prcmu.h:673:19: note: previous definition of 'prcmu_abb_read' was here
> include/linux/mfd/dbx500-prcmu.h:619:19: error: redefinition of 'prcmu_abb_write'
> include/linux/mfd/db8500-prcmu.h:678:19: note: previous definition of 'prcmu_abb_write' was here
> include/linux/mfd/dbx500-prcmu.h:630:19: error: redefinition of 'prcmu_config_clkout'
> include/linux/mfd/db8500-prcmu.h:643:19: note: previous definition of 'prcmu_config_clkout' was here
> include/linux/mfd/dbx500-prcmu.h:692:20: error: redefinition of 'prcmu_ac_wake_req'
> include/linux/mfd/db8500-prcmu.h:683:20: note: previous definition of 'prcmu_ac_wake_req' was here
> include/linux/mfd/dbx500-prcmu.h:694:20: error: redefinition of 'prcmu_ac_sleep_req'
> include/linux/mfd/db8500-prcmu.h:685:20: note: previous definition of 'prcmu_ac_sleep_req' was here
>
> Caused (exposed?) by commit d28f1db8187d ("mfd: Remove confusing
> ab8500-i2c file and merge into ab8500-core").  I assume that this has
> only had very restricted build testing :-(

I 'believe' that you 'might' be missing MFD_DB8500_PRCMU from your 
config. Can you check this for me please Stephen?

MFD_DB8500_PRCMU is selected by
UX500_SOC_DB8500 is selected by
MACH_MOP500 is selected by
MACH_HREFV60 | MACH_SNOWBALL is selected by
u8500_defconfig

Can I ask how you build the kernel and which defconfig you are using please?

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
