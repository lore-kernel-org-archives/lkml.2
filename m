Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1AJXBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:01:12 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:64140 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab1AJXBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:01:09 -0500
Date: Mon, 10 Jan 2011 18:01:01 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] cpuidle: Make cpuidle_enable_device() call poll_idle_init()
In-reply-to: <201101080029.20744.rjw@sisk.pl>
Message-id: <alpine.LFD.2.02.1101101754320.7945@x980>
References: <201101080029.20744.rjw@sisk.pl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /**
>   * cpuidle_enable_device - enables idle PM for a CPU
>   * @dev: the CPU
> @@ -176,6 +215,8 @@ int cpuidle_enable_device(struct cpuidle
>  		ret = __cpuidle_register_device(dev);
>  		if (ret)
>  			return ret;
> +	} else {
> +		poll_idle_init(dev);
>  	}

how about calling poll_idle_init() unconditionally here
and deleting the call to it from within __cpuidle_register_device()?

thanks,
Len Brown, Intel Open Source Technology Center

