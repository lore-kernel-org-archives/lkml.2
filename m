Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab1ESNyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:54:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63734 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab1ESNya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P6xgg8kf6gwm+xGt/KGPEHcm3E79vB1dBFgMGAmdXNHWeAGl75F5saC2tGJQ3pzLYg
         fOPPJY/4q3FdH8af4TgVjYhNri5g7rVvYfx7tN5jEJl4huK2Ofkv8MkJDWF+pB93YDOJ
         UNZRKhb+Z8HClbVMPIIzrO/Dk3dcxcE0PejWs=
Date: Thu, 19 May 2011 15:54:25 +0200
From: Tejun Heo <tj@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: early kernel crash when kmemleak is enabled
Message-ID: <20110519135425.GI627@htj.dyndns.org>
References: <20110515105505.GA21631@joi.lan>
 <20110519134218.GH627@htj.dyndns.org>
 <1305812924.26710.41.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305812924.26710.41.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 02:48:44PM +0100, Catalin Marinas wrote:
> Thanks for tracking this down. Untested (I can add a log afterwards):
> 
> diff --git a/init/main.c b/init/main.c
> index 4a9479e..48df882 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -580,8 +580,8 @@ asmlinkage void __init start_kernel(void)
>  #endif
>  	page_cgroup_init();
>  	enable_debug_pagealloc();
> -	kmemleak_init();
>  	debug_objects_mem_init();
> +	kmemleak_init();
>  	setup_per_cpu_pageset();
>  	numa_policy_init();
>  	if (late_time_init)

Heh, that was swift.  Yeap, seems to work here.  Please feel free to
add my Tested-by.

Thank you.

-- 
tejun
