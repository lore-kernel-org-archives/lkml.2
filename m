Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2FXJqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 05:46:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:15884 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab2FXJqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 05:46:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160047502"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Liu, ShuoX" <shuox.liu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Andrew J. Schorr" <aschorr@telemetry-investments.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: RE: [PATCH] cpuidle: move field disable from per-driver to per-cpu
Thread-Topic: [PATCH] cpuidle: move field disable from per-driver to per-cpu
Thread-Index: AQHNUMw8PlUNATYhA0GqDtXbgmDm55cJOQxA
Date: Sun, 24 Jun 2012 09:46:03 +0000
Message-ID: <144086DDB7BB6D429C79280EB1C804D40C2791@SHSMSX101.ccr.corp.intel.com>
References: <4FD95200.1090701@intel.com>
 <20120622161030.da016ccf.akpm@linux-foundation.org>
In-Reply-To: <20120622161030.da016ccf.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

You are right. It's just to reuse current functions, which show 64bit usage/time. Should we add 2 new macros to define new functions for int?

Yanmin

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Saturday, June 23, 2012 7:10 AM
To: Liu, ShuoX
Cc: linux-kernel@vger.kernel.org; Brown, Len; Zhang, Yanmin; Andrew J. Schorr; Deepthi Dharwar
Subject: Re: [PATCH] cpuidle: move field disable from per-driver to per-cpu

On Thu, 14 Jun 2012 10:52:48 +0800
ShuoX Liu <shuox.liu@intel.com> wrote:

> From: ShuoX Liu <shuox.liu@intel.com>
> 
> Andrew J.Schorr raises a question. When he changes the disable setting 
> on a single CPU, it affects all the other CPUs. Basically, currently, 
> the disable field is per-driver instead of per-cpu. All the C states 
> of the same driver are shared by all CPU in the same machine.
> 
> Below patch changes field disable to per-cpu, so we could set this 
> separately for each cpu.
> 
> ...
>
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -34,6 +34,7 @@ struct cpuidle_driver;  struct cpuidle_state_usage {
>  	void		*driver_data;
>  
> +	unsigned long long	disable;

hrmpf.  We're using 64 bits for this where one bit would do, afaict because the magic macros in drivers/cpuidle/sysfs.c are using %llu.

