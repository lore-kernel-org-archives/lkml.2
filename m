Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab1GMGFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 02:05:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:22592 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1GMGFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 02:05:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,523,1304319600"; 
   d="scan'208";a="27285044"
From: Andi Kleen <andi@firstfloor.org>
To: MK <mk@cognitivedissonance.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AVX "Sandy Bridge" hardware issue?
References: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
Date: Tue, 12 Jul 2011 17:49:35 -0700
In-Reply-To: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
	(mk@cognitivedissonance.ca's message of "Tue, 12 Jul 2011 16:16:16
	-0400")
Message-ID: <m2k4bn57j4.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MK <mk@cognitivedissonance.ca> writes:
>
> In which Andreas Schwab points out (rightly or wrongly) that according
> to the /proc/cpuinfo from the slice, the processor actually does not
> support AVX.  However,  the "model name", "Intel(R) Xeon(R) CPU
> E31230", is according to this a Sandy Bridge processor with AVX:

If it's in a VM then the VM may not expose AVX to the guest
(the VMs have to do that explicitely because AVX has additional state). 
If it's not in /proc/cpuinfo on the guest that's likely the case.

However glibc should of course not use AVX in this case.

> Does anyone have any idea why I would get this identical backtrace, and
> a failed reproducer test, on hardware which supposedly supports AVX
> (but not according to the kernel in /proc/cpuinfo)?

If there's a problem then it's likely in the VM. Maybe it leaks
AVX partially through only.

For example I had a similar problem a long time ago on a system
which had inconsistent CPU features for different CPUs. The kernel
will chose the least common denominator, but an application
directly calling CPUID can sometimes see different flags and then
crash when it switches CPUs.

The symptoms would be consistent with that.

I would contact the VM vendor.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
