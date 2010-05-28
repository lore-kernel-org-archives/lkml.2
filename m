Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab0E1D5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 23:57:50 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:56402 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0E1D5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 23:57:49 -0400
Date: Thu, 27 May 2010 23:57:42 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for select
 intel processors
In-reply-to: <20100526204426.fd2be7e0.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.1005272354100.24823@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
 <20100526204426.fd2be7e0.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ... What happens when an additional CPU is brought online? 
> It melts?  ;)

With the current driver, processors hot-added after modprobe
will use C1 only, and not use deeper C-states.

Taking online processors offline and bringing them back online
(like we do during suspend) works fine.

> > +		dev->cpu = i;
> > +		if (cpuidle_register_device(dev)) {
> > +			pr_debug(PREFIX "cpuidle_register_device %d failed!\n", i);
> > +			free_percpu(intel_idle_cpuidle_devices);
> > +			return -EIO;
> 
> Should this unregister all the thus-far-registered devices?

yes, that was a bug!

thanks,
Len Brown, Intel Open Source Technology Center

