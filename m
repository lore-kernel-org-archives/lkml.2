Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2FVXKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:10:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2FVXKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:10:32 -0400
Date: Fri, 22 Jun 2012 16:10:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuox.liu@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Andrew J. Schorr" <aschorr@telemetry-investments.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpuidle: move field disable from per-driver to per-cpu
Message-Id: <20120622161030.da016ccf.akpm@linux-foundation.org>
In-Reply-To: <4FD95200.1090701@intel.com>
References: <4FD95200.1090701@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 10:52:48 +0800
ShuoX Liu <shuox.liu@intel.com> wrote:

> From: ShuoX Liu <shuox.liu@intel.com>
> 
> Andrew J.Schorr raises a question. When he changes the disable setting
> on a single CPU, it affects all the other CPUs. Basically, currently,
> the disable field is per-driver instead of per-cpu. All the C states of
> the same driver are shared by all CPU in the same machine.
> 
> Below patch changes field disable to per-cpu, so we could set this
> separately for each cpu.
> 
> ...
>
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -34,6 +34,7 @@ struct cpuidle_driver;
>  struct cpuidle_state_usage {
>  	void		*driver_data;
>  
> +	unsigned long long	disable;

hrmpf.  We're using 64 bits for this where one bit would do, afaict
because the magic macros in drivers/cpuidle/sysfs.c are using %llu.

