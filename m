Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2GTRUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:20:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50725 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab2GTRUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:20:52 -0400
Message-ID: <50099361.6050300@zytor.com>
Date: Fri, 20 Jul 2012 10:20:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
In-Reply-To: <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 09:37 AM, Vladimir Davydov wrote:
> If 'clearcpuid=N' is specified in boot options, CPU feature #N won't be
> reported in /proc/cpuinfo and used by the kernel. However, if a
> userpsace process checks CPU features directly using the cpuid
> instruction, it will be reported about all features supported by the CPU
> irrespective of what features are cleared.
> 
> The patch makes the clearcpuid boot option not only clear CPU features
> in kernel but also mask them in hardware for Intel and AMD CPUs that
> support it so that the features cleared won't be reported even by the
> cpuid instruction.
> 
> This can be useful for migration of virtual machines managed by
> hypervisors that do not support/use Intel VT/AMD-V hardware-assisted
> virtualization technology.
> 
> If CPUID masking is supported, this will be reported in
> /proc/cpuinfo:flags as 'cpuidmask'.

I am a bit concerned about this patch:

1. it silently changes existing behavior.
2. even on enabled hardware, only some of the bits are maskable.

	-hpa


